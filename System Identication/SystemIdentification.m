clc;
clear;
close all;
%%
global gama1 gama2 K1 K2 A1 A2 A3 A4 a1 a2 a3 a4 g V1 V2 V1max V2max;
%% Parameters
D13=18;d13=1.2;
D24=15;d24=1;
gama1=0.4;gama2=0.3;
K1=13;K2=13;
A1=pi*(0.5*D13)^2;A3=pi*(0.5*D13)^2;
A2=pi*(0.5*D24)^2;A4=pi*(0.5*D24)^2;
a1=pi*(0.5*d13)^2;
a3=pi*(0.5*d13)^2;
a2=pi*(0.5*d24)^2;
a4=pi*(0.5*d24)^2;
g=981;
V1max=12;
V2max=12;

Nc=4;
NTrial=1;
% tav1 =28.9 and tav2 = 34.1 then duration musb be between 0.5 to 1x of bigger one and dutycycle must be in range between 0.3 and 0.7.
min_Duration=15;
max_Duration=34;
min_DutyCycle=0.3;
max_DutyCycle=0.7;
TimeLength=1000; 
T0 = 0;
Ts = 1;
t = T0:Ts:TimeLength-Ts ; t = t' ;
N = numel(t) ;

NoizVar=0.2;
NoizStd=sqrt(NoizVar); %0.447 cm
WCost=1*[0.5,0.5,0.03,0.03];
%% IdentificationResults using INTERIOR POINT with norm 1
tic();
Teta=zeros(Nc,NTrial);
Fval=zeros(1,NTrial);exitflag=zeros(1,NTrial); 
outputInit.exitflag=0;
outputInit.output=0;
outputInit.lambda=0;
outputInit.grad=0;
outputInit.hessian=0;
output=repmat(outputInit,1,NTrial);
prbs_signal1=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
prbs_signal2=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
k01=rand(1);k02=rand(1);k03=10*rand(1)+5;k04=10*rand(1)+5;
for j=1:NTrial
    y1 = zeros(size(t));y2 = zeros(size(t));y3 = zeros(size(t));y4 = zeros(size(t));    %simulated model
    h0=[0;0;0;0];
    Time=0:Ts;
    for i = 2:N
        V1=prbs_signal1(i-1);V2=prbs_signal2(i-1);
        [T,H] = ode45(@QTP,Time,h0);
        y1(i)=H(end,1);
        y2(i)=H(end,2);
        y3(i)=H(end,3);
        y4(i)=H(end,4);
        h0=H(end,:);
    end
    y1c=y1+NoizStd.*randn(size(y1));
    y2c=y2+NoizStd.*randn(size(y2));
    y3c=y3+NoizStd.*randn(size(y3));
    y4c=y4+NoizStd.*randn(size(y4));    
    Yc=abs([y1c;y2c;y3c;y4c]);    %perturbed model
    K0=[k01,k02,k03,k04]';
    K=K0;
    LB=[0.10,0.10,05,05]';
    UB=[0.90,0.90,15,15]';
    method=1;
    costtype=1;
    if costtype==1
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,1) + norm(WCost.*K,1)  ; 
    else
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,2) + norm(WCost.*K,2)  ;
    end

    if method==1
        options = optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunctionEvaluations',20000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB ,[],options) ;
    elseif method==2
        options = optimoptions('fmincon','Display','iter','Algorithm','SQP','MaxFunctionEvaluations',20000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB, [], options) ;
    else
        [K , Fval(j)] = fminunc(Cost, K);
    end

    Teta(:,j)=K;
end

ElapsedTime=toc();
save('IdentificationResultsINT1.mat')
figure(1)
subplot(2,1,1);plot(t , prbs_signal1 ,t , prbs_signal2 , 'LineWidth' , 2) ;
grid on
xlabel('Time') ; ylabel('Amp') ;legend('u1','u2');
subplot(2,1,2);plot(t , y1 ,'b-',t , y2 ,'r-', t , y1c ,'b--', t , y2c ,'r--', 'LineWidth' , 2);
grid on
xlabel('Time') ; ylabel('Amp') ;legend('y1','y2','y1c','y2c');
figure(2)
plot(1:NTrial , Teta(1,:) ,1:NTrial , Teta(2,:) ,1:NTrial , Teta(3,:) ,1:NTrial , Teta(4,:) , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Amp') ;legend('K1','K2','K3','K4');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);
figure(3)
plot(1:NTrial , Fval , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Fval') ;
legend('Fval');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);

%% IdentificationResults using INTERIOR POINT with norm 2
tic();
Teta=zeros(Nc,NTrial);
Fval=zeros(1,NTrial);exitflag=zeros(1,NTrial);
outputInit.exitflag=0;
outputInit.output=0;
outputInit.lambda=0;
outputInit.grad=0;
outputInit.hessian=0;
output=repmat(outputInit,1,NTrial);
prbs_signal1=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
prbs_signal2=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
k01=rand(1);k02=rand(1);k03=10*rand(1)+5;k04=10*rand(1)+5;
for j=1:NTrial
    y1 = zeros(size(t));y2 = zeros(size(t));y3 = zeros(size(t));y4 = zeros(size(t));    %simulated model
    h0=[0.01;0.01;0.01;0.01];
    Time=0:Ts;
    for i = 2:N
        V1=prbs_signal1(i-1);V2=prbs_signal2(i-1);
        [T,H] = ode45(@QTP,Time,h0);
        y1(i)=H(end,1);
        y2(i)=H(end,2);
        y3(i)=H(end,3);
        y4(i)=H(end,4);
        h0=H(end,:);
    end
    y1c=y1+NoizStd.*randn(size(y1));
    y2c=y2+NoizStd.*randn(size(y2));
    y3c=y3+NoizStd.*randn(size(y3));
    y4c=y4+NoizStd.*randn(size(y4));    
    Yc=abs([y1c;y2c;y3c;y4c]);    %perturbed model
    K0=[k01,k02,k03,k04]';
    K=K0;
    LB=[0.10,0.10,05,05]';
    UB=[0.90,0.90,15,15]';
    method=1;
    costtype=2;
    if costtype==1
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,1) + norm(WCost.*K,1)  ; 
    else
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,2) + norm(WCost.*K,2)  ;
    end

    if method==1
        options = optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunctionEvaluations',20000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB ,[],options) ;
    elseif method==2
        options = optimoptions('fmincon','Display','iter','Algorithm','SQP','MaxFunctionEvaluations',20000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB, [], options) ;
    else
        [K , Fval(j)] = fminunc(Cost, K);
    end

    Teta(:,j)=K;
end

ElapsedTime=toc();
save('IdentificationResultsINT2.mat')
figure(1)
subplot(2,1,1);plot(t , prbs_signal1 ,t , prbs_signal2 , 'LineWidth' , 2) ;
grid on
xlabel('Time') ; ylabel('Amp') ;legend('u1','u2');
subplot(2,1,2);plot(t , y1 ,'b-',t , y2 ,'r-', t , y1c ,'b--', t , y2c ,'r--', 'LineWidth' , 2);
grid on
xlabel('Time') ; ylabel('Amp') ;legend('y1','y2','y1c','y2c');
figure(2)
plot(1:NTrial , Teta(1,:) ,1:NTrial , Teta(2,:) ,1:NTrial , Teta(3,:) ,1:NTrial , Teta(4,:) , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Amp') ;legend('K1','K2','K3','K4');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);
figure(3)
plot(1:NTrial , Fval , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Fval') ;
legend('Fval');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);

%% IdentificationResults using SQP with norm 1
tic();
Teta=zeros(Nc,NTrial);
Fval=zeros(1,NTrial);exitflag=zeros(1,NTrial);
outputInit.exitflag=0;
outputInit.output=0;
outputInit.lambda=0;
outputInit.grad=0;
outputInit.hessian=0;
output=repmat(outputInit,1,NTrial);
prbs_signal1=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
prbs_signal2=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
k01=rand(1);k02=rand(1);k03=10*rand(1)+5;k04=10*rand(1)+5;
for j=1:NTrial
    y1 = zeros(size(t));y2 = zeros(size(t));y3 = zeros(size(t));y4 = zeros(size(t));    %simulated model
    h0=[0.01;0.01;0.01;0.01];
    Time=0:Ts;
    for i = 2:N
        V1=prbs_signal1(i-1);V2=prbs_signal2(i-1);
        [T,H] = ode45(@QTP,Time,h0);
        y1(i)=H(end,1);
        y2(i)=H(end,2);
        y3(i)=H(end,3);
        y4(i)=H(end,4);
        h0=H(end,:);
    end
    y1c=y1+NoizStd.*randn(size(y1));
    y2c=y2+NoizStd.*randn(size(y2));
    y3c=y3+NoizStd.*randn(size(y3));
    y4c=y4+NoizStd.*randn(size(y4));    
    Yc=abs([y1c;y2c;y3c;y4c]);    %perturbed model
    K0=[k01,k02,k03,k04]';
    K=K0;
    LB=[0.10,0.10,05,05]';
    UB=[0.90,0.90,15,15]';
    method=2;
    costtype=1;
    if costtype==1
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,1) + norm(WCost.*K,1)  ; 
    else
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,2) + norm(WCost.*K,2)  ;
    end

    if method==1
        options = optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunctionEvaluations',2000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB ,[],options) ;
    elseif method==2
        options = optimoptions('fmincon','Display','iter','Algorithm','SQP','MaxFunctionEvaluations',2000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB, [], options) ;
    else
        [K , Fval(j)] = fminunc(Cost, K);
    end

    Teta(:,j)=K;
end

ElapsedTime=toc();
save('IdentificationResultsSQP1.mat')
figure(1)
subplot(2,1,1);plot(t , prbs_signal1 ,t , prbs_signal2 , 'LineWidth' , 2) ;
grid on
xlabel('Time') ; ylabel('Amp') ;legend('u1','u2');
subplot(2,1,2);plot(t , y1 ,'b-',t , y2 ,'r-', t , y1c ,'b--', t , y2c ,'r--', 'LineWidth' , 2);
grid on
xlabel('Time') ; ylabel('Amp') ;legend('y1','y2','y1c','y2c');
figure(2)
plot(1:NTrial , Teta(1,:) ,1:NTrial , Teta(2,:) ,1:NTrial , Teta(3,:) ,1:NTrial , Teta(4,:) , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Amp') ;legend('K1','K2','K3','K4');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);
figure(3)
plot(1:NTrial , Fval , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Fval') ;
legend('Fval');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);

%% IdentificationResults using SQP with norm 2
tic();
Teta=zeros(Nc,NTrial);
Fval=zeros(1,NTrial);exitflag=zeros(1,NTrial);
outputInit.exitflag=0;
outputInit.output=0;
outputInit.lambda=0;
outputInit.grad=0;
outputInit.hessian=0;
output=repmat(outputInit,1,NTrial);
prbs_signal1=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
prbs_signal2=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,TimeLength);
k01=rand(1);k02=rand(1);k03=10*rand(1)+5;k04=10*rand(1)+5;
for j=1:NTrial
    y1 = zeros(size(t));y2 = zeros(size(t));y3 = zeros(size(t));y4 = zeros(size(t));    %simulated model
    h0=[0.01;0.01;0.01;0.01];
    Time=0:Ts;
    for i = 2:N
        V1=prbs_signal1(i-1);V2=prbs_signal2(i-1);
        [T,H] = ode45(@QTP,Time,h0);
        y1(i)=H(end,1);
        y2(i)=H(end,2);
        y3(i)=H(end,3);
        y4(i)=H(end,4);
        h0=H(end,:);
    end
    y1c=y1+NoizStd.*randn(size(y1));
    y2c=y2+NoizStd.*randn(size(y2));
    y3c=y3+NoizStd.*randn(size(y3));
    y4c=y4+NoizStd.*randn(size(y4));    
    Yc=abs([y1c;y2c;y3c;y4c]);    %perturbed model
    K0=[k01,k02,k03,k04]';
    K=K0;
    LB=[0.20,0.20,05,05]';
    UB=[0.70,0.70,15,15]';
    method=2;
    costtype=2;
    if costtype==1
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,1) + norm(WCost.*K,1)  ; 
    else
           Cost = @(K) norm(IdentifiedModel(K,T0,Ts,TimeLength,prbs_signal1,prbs_signal2)- Yc,2) + norm(WCost.*K,2)  ;
    end

    if method==1
        options = optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunctionEvaluations',1000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB ,[],options) ;
    elseif method==2
        options = optimoptions('fmincon','Display','iter','Algorithm','SQP','MaxFunctionEvaluations',1000);
        [K , Fval(j),output(j).exitflag,output(j).output,output(j).lambda,output(j).grad,output(j).hessian] = fmincon(Cost, K , [] , [] , [] , [] , LB , UB, [], options) ;
    else
        [K , Fval(j)] = fminunc(Cost, K);
    end

    Teta(:,j)=K;
end

ElapsedTime=toc();
save('IdentificationResultsSQP2.mat')
figure(1)
subplot(2,1,1);plot(t , prbs_signal1 ,t , prbs_signal2 , 'LineWidth' , 2) ;
grid on
xlabel('Time') ; ylabel('Amp') ;legend('u1','u2');
subplot(2,1,2);plot(t , y1 ,'b-',t , y2 ,'r-', t , y1c ,'b--', t , y2c ,'r--', 'LineWidth' , 2);
grid on
xlabel('Time') ; ylabel('Amp') ;legend('y1','y2','y1c','y2c');
figure(2)
plot(1:NTrial , Teta(1,:) ,1:NTrial , Teta(2,:) ,1:NTrial , Teta(3,:) ,1:NTrial , Teta(4,:) , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Amp') ;legend('K1','K2','K3','K4');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);
figure(3)
plot(1:NTrial , Fval , 'LineWidth' , 2) ;
grid on
xlabel('Trial') ; ylabel('Fval') ;
legend('Fval');title(['Res(Noiz Var = ',num2str(NoizVar), '): K1 = ',num2str(mean(Teta(1,:))),'    K2 = ',num2str(mean(Teta(2,:))),'    K3 = ',num2str(mean(Teta(3,:))),'    K4 = ',num2str(mean(Teta(4,:)))]);

%% Shutting down the system after all optimizations are complete
system('shutdown -s');

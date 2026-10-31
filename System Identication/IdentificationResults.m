clc;
clear;
close all;
format 'compact';

%% -----------Reported results in Table 2 in paper-----------------
load('IdentificationResultsINT1.mat');Teta,Fval %#ok<*NOPTS>
load('IdentificationResultsSQP1.mat');Teta,Fval
load('IdentificationResultsINT2.mat');Teta,Fval
load('IdentificationResultsSQP2.mat');Teta,Fval
clc
load('IdentificationResultsINT1.mat');T_INT1=[Teta(:,1)]',Fval_INT1=Fval(1) %#ok<*NBRAK>
load('IdentificationResultsSQP1.mat');T_SQP1=[Teta(:,6)]',Fval_SQP1=Fval(6)

load('IdentificationResultsINT2.mat');T_INT2=[Teta(:,2)]',Fval_INT2=Fval(2)
load('IdentificationResultsSQP2.mat');T_SQP2=[Teta(:,4)]',Fval_SQP2=Fval(4)

% The index of the experiment in which each algorithm is demonstrated in the paper is as follows:
% INT1  --->1
% SQP1  --->6
% INT2  --->2
% SQP2  --->4
clear;

%% -----------Reported Figure 3 in paper and another axiliary plot-----------------
load('IdentificationResultsINT1');
paramsNumber=2;

D13=18;d13=1.2;
D24=15;d24=1;
gama1=Teta(1,paramsNumber);gama2=Teta(2,paramsNumber);
K1=Teta(3,paramsNumber);K2=Teta(4,paramsNumber);
A1=pi*(0.5*D13)^2;A3=pi*(0.5*D13)^2;
A2=pi*(0.5*D24)^2;A4=pi*(0.5*D24)^2;
a1=pi*(0.5*d13)^2;
a3=pi*(0.5*d13)^2;
a2=pi*(0.5*d24)^2;
a4=pi*(0.5*d24)^2;
g=981;
V1max=12;
V2max=12;

y1Id = zeros(size(t));y2Id = zeros(size(t));y3Id = zeros(size(t));y4Id = zeros(size(t));
h0=[0.01;0.01;0.01;0.01]; % to eliminate numerical errors we set initial heights to 0.01 instead of 0.
Time=0:Ts;
for i = 2:N
    V1=prbs_signal1(i-1);V2=prbs_signal2(i-1);
    [T,H] = ode45(@QTP,Time,h0);
    y1Id(i)=real(H(end,1));
    y2Id(i)=real(H(end,2));
    y3Id(i)=real(H(end,3));
    y4Id(i)=real(H(end,4));
    h0=H(end,:);
end

YID=[y1Id;y2Id;y3Id;y4Id]; % the height of tanks in identified model

% Plot Figure 3 in paper
figure(3)
LineWidth=2.0;
TextColor='black';FontName='Times new Roman';FontWeight= 'bold';
FontSizeSeq=12;FontSizeLeg=12;FontSizeAx=12;xLimit=1000;
t_prbs=1:1:1000;u1_prbs=zeros(size(t_prbs));u2_prbs=zeros(size(t_prbs));
xCut1=100;xCut2=900;xGap=25;
plt1=subplot(3,2,1);
plot(t_prbs,prbs_signal1,'b-','LineWidth' , LineWidth);
ylabel('Voltage (v)');
xlim([1 xLimit]);ylim([0 1.1*V1max]);title('Pump 1');
cutout(plt1,xCut1,xCut2,xGap);
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

plt2=subplot(3,2,2);
plot(t_prbs,prbs_signal2,'b-','LineWidth' , LineWidth);
ylabel('Voltage (v)');
xlim([1 xLimit]);ylim([0 1.1*V2max]);title('Pump 2');
cutout(plt2,xCut1,xCut2,xGap);
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(3,2,3);
plot(t , y3 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y3c ,'r:', 'LineWidth' , LineWidth);
plot(t , y3Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]); ylabel('Height (cm)');title('Tank 3');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(3,2,4);
plot(t , y4 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y4c ,'r:', 'LineWidth' , LineWidth);
plot(t , y4Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]); ylabel('Height (cm)');title('Tank 4');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(3,2,5);
plot(t , y1 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y1c ,'r:','LineWidth' , LineWidth);
plot(t , y1Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time (s)');ylabel('Height (cm)');title('Tank 1');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(3,2,6);
plot(t , y2 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y2c ,'r:', 'LineWidth' , LineWidth);
plot(t , y2Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time (s)');ylabel('Height (cm)');title('Tank 2');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';ax.YGrid= 'on';

% Axiliary plot
figure()
subplot(2,2,1);
plot(t , y3 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y3c ,'r-.', 'LineWidth' , LineWidth);
plot(t , y3Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time(s)') ; ylabel('Height');title('Tank 3');legend('Simulated model','Perturbed model','Identified model'); legend('Location','south');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(2,2,2);
plot(t , y4 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y4c ,'r-.', 'LineWidth' , LineWidth);
plot(t , y4Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time(s)') ; ylabel('Height');title('Tank 4');legend('Simulated model','Perturbed model','Identified model'); legend('Location','south');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(2,2,3);
plot(t , y1 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y1c ,'r-.','LineWidth' , LineWidth);
plot(t , y1Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time(s)') ; ylabel('Height');title('Tank 1');legend('Simulated model','Perturbed model','Identified model'); legend('Location','south');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';

subplot(2,2,4);
plot(t , y2 ,'b-', 'LineWidth' , LineWidth);hold on;
plot(t , y2c ,'r-.', 'LineWidth' , LineWidth);
plot(t , y2Id ,'g--', 'LineWidth' , LineWidth);
xlim([1 xLimit]);xlabel('Time(s)') ; ylabel('Height');title('Tank 2');legend('Simulated model','Perturbed model','Identified model'); legend('Location','south');
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.GridColor= [0.25 0.25 0.25];
ax.GridAlpha= 0.25;
ax.GridLineStyle= '-.';
ax.XGrid= 'on';ax.YGrid= 'on';ax.YGrid= 'on';

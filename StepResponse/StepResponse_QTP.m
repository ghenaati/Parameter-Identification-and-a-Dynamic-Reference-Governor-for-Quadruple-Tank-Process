clc;
clear;
close all;
%%
global gama1 gama2 K1 K2 A1 A2 A3 A4 a1 a2 a3 a4 g V1 V2;
D13=18;d13=1.2;
D24=15;d24=1;
%-------------------------------------------------------------------------- 
% we implememted obtained parameters from Table 2 in section 2.2, 
% where solver is interior point method and objective function is based on norm l1
% we have stated this fact in the last paragraph of section 2.2
gama1=0.4;gama2=0.299;
K1=12.935;K2=13.074;
%-------------------------------------------------------------------------- 

A1=pi*(0.5*D13)^2;A3=pi*(0.5*D13)^2;
A2=pi*(0.5*D24)^2;A4=pi*(0.5*D24)^2;
a1=pi*(0.5*d13)^2;
a3=pi*(0.5*d13)^2;
a2=pi*(0.5*d24)^2;
a4=pi*(0.5*d24)^2;
g=981;
%%
Ts=10;
Tf=1000;
Time=0:Ts:Tf;
V1=12;V2=0; 

h0=zeros(4,1);  % for Step Responce
[~,H] = ode45(@QTP,Time,h0);
Y11=H(:,1)/V1;Y21=H(:,2)/V1;

V1=0;V2=12;
h0=zeros(4,1);% for Step Responce
[T,H] = ode45(@QTP,Time,h0);
Y12=H(:,1)/V2;Y22=H(:,2)/V2;
%%
figure()
plot(T,Y11,'b-',T,Y21,'r-',T,Y12,'b--',T,Y22,'r--');grid on;
xlabel('Time t');
ylabel('Height of Tanks  h');
legend('Y11','Y21','Y12','Y22');
save('StepResponse.mat','Y11','Y21','Y12','Y22','Ts','Tf','T');



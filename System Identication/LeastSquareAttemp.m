% we tried obtain parameters using least square method, however, we failed. 

% Direct least squares for valve positions (gamma_i) and pump gains (k_i) in the four-tank model
% is unsuitable without variable change: the model contains products gamma_i*k_i, so it is
% nonlinear in these parameters and cannot be written as A*theta = b.
% Nonlinear LS is nonconvex, sensitive to initial guesses, has local minima, and needs
% constraints 0<=gamma_i<=1, k_i>0. For discrete (open/closed) valves, continuous LS is invalid.

% we didn't use this method in original paper.

clc;
clear;
close all;
%%
global gama1 gama2 K1 K2 A1 A2 A3 A4 a1 a2 a3 a4 g V1 V2 V1max V2max;
%% Paper Parameters
% gama1=0.4;gama2=0.3;
% K1=1;K2=1;
% A1=28;A2=32;A3=28;A4=32;
% a1=71e-03*1;
% a2=57e-03*1;
% a3=71e-03*1;
% a4=57e-03*1;
% g=981;
% V1=12;V2=12;
%% New Parameters
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
T0 = 0 ;
Ts = 10 ;
Tf = 10000 ;
t = T0:Ts:Tf-Ts ; t = t' ;
N = numel(t) ;
% u1 = idinput(N , 'rgs') ;u2 = idinput(N , 'rgs') ;
u1_temp1=7*rand(size(t))+5; u2_temp1=7*rand(size(t))+5;
u1_temp2=7*rand(size(t))+5; u2_temp2=7*rand(size(t))+5;
u1=[u1_temp1(1:N/2)',u1_temp2(1:N/2)'];
u2=[u2_temp1(1:N/2)',u2_temp2(1:N/2)'];
y1 = zeros(size(t));
h0=[0;0;0;0];
for i = 11:N
    %     y(i) = a * y(i-1) + b * sin(y(i-2)) + c * u(i-1) + e(i) ;
    Time=0:Ts;
    
%     u1(i-1)=10;u2(i-1)=10;
    V1=u1(i-1);V2=u2(i-1);
  
    [T,H] = ode45(@QTP,Time,h0);
    y1(i)=H(end,1);
    h0=H(end,:);
end
PHI = zeros(N , 20) ;
for i =  11:N
    PHI(i , :) = [u2(i-1), u2(i-2), u2(i-3), u2(i-4), u2(i-5),u2(i-6), u2(i-7), u2(i-8), u2(i-9), u2(i-10),u1(i-1), u1(i-2),u1(i-3), u1(i-4), u1(i-5),u1(i-6), u1(i-7), u1(i-8), u1(i-9), u1(i-10) ]' ;
end
teta = PHI\y1  %% (PHI' * PHI)^-1 * PHI' *Y
u1test=8;
u2test=8;
for i = 4:N
%      y1_hat(i) = PHI(i , :)*teta;
     y1_hat(i) = [u2test, u2test, u2test, u2test, u2test, u2test, u2test, u2test, u2test, u2test,u1test, u1test, u1test, u1test, u1test,u1test, u1test, u1test, u1test, u1test]*teta;
end
%%
plot(t ,u1 ,t ,u2 ,t ,y1 ,t ,y1_hat , 'LineWidth' , 2) ;
grid on
xlabel('Time') ; ylabel('Amp') ;
legend('u1','u2','y1','y1 hat')
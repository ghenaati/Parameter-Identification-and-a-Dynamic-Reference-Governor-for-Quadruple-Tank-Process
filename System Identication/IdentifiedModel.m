function yhat=IdentifiedModel(K,T0,Ts,Tf,u1,u2)
%% New Parameters
global gama1 gama2 K1 K2 A1 A2 A3 A4 a1 a2 a3 a4 g V1 V2 V1max V2max;
D13=18;d13=1.2;
D24=15;d24=1;
gama1=K(1);gama2=K(2);
K1=K(3);K2=K(4);
% The real values in the simulated model are as follows.
% gama1=0.4; gama2=0.3; K1=13; K2=13

A1=pi*(0.5*D13)^2;A3=pi*(0.5*D13)^2;
A2=pi*(0.5*D24)^2;A4=pi*(0.5*D24)^2;
a1=pi*(0.5*d13)^2;
a3=pi*(0.5*d13)^2;
a2=pi*(0.5*d24)^2;
a4=pi*(0.5*d24)^2;
g=981;
V1max=12;
V2max=12;
%%
t = T0:Ts:Tf-Ts ; t = t' ;
N = numel(t) ;
yhat1 = zeros(size(t));yhat2 = zeros(size(t));yhat3 = zeros(size(t));yhat4 = zeros(size(t));
h0=[0;0;0;0];
Time=0:Ts;
for i = 2:N
    V1=u1(i-1);V2=u2(i-1);
    [~,H] = ode45(@QTP,Time,h0);
    yhat1(i)=H(end,1);
    yhat2(i)=H(end,2);
    yhat3(i)=H(end,3);
    yhat4(i)=H(end,4);    
    h0=H(end,:);
end
yhat=[yhat1;yhat2;yhat3;yhat4];

end
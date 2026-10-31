function [c,ceq] =NLC_Scenario(dU,u,i,p,m,h0, Ts)
global V1 V2 Vmin Vmax Y1max Y2max Y3max Y4max;
%---------------------------------------------------------------------------------------------------------------
if i>1
    u1_old = u(i-1,1);u2_old = u(i-1,2);
else
    u1_old = 0;u2_old = 0;
end
% c1=[cumsum([u1_old;dU(1:m)]);cumsum([u2_old;dU(m+1:2*m)])]-Vmax;
% c2=[cumsum([u1_old;dU(1:m)]);cumsum([u2_old;dU(m+1:2*m)])]-Vmin;
%---------------------------------------------------------------------------------------------------------------
Time=0:Ts/3:Ts;
% Y1max=6.79;Y2max=9;Y3max=?;Y4max=?; %call from outside
Y1_Pred = zeros(p,1);Y2_Pred = zeros(p,1);Y3_Pred = zeros(p,1);Y4_Pred = zeros(p,1);
for j=1:p
    if j<=m
        V1=u1_old+sum(dU(1:j));
        V2=u2_old+sum(dU(1+m:j+m));
    end
    [~,H] = ode45(@QTP,Time,h0);
    Y1_Pred(j) = H(end,1);
    Y2_Pred(j) = H(end,2);
    Y3_Pred(j) = H(end,3);
    Y4_Pred(j) = H(end,4);    
    h0=H(end,:);
end
c3=Y1_Pred-Y1max;
c4=Y2_Pred-Y2max;
c5=Y3_Pred-Y3max;
c6=Y4_Pred-Y4max;

c=[c5;c6];
ceq=[];
end




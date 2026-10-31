function [Z_ToTAL, Sol]= DMC_Cost(dU, G, FreeResponse, W, i, p, m, Q1, R)
%% Initialization
global Y1max Y2max Y3max Y4max;
W1=W(i:i+p-1,1);W2=W(i:i+p-1,2);
Y1_Pred = zeros(p,1);Y2_Pred = zeros(p,1);
Ref1=W1;Ref2=W2;

%% Prediction

Y_Pred=G*dU(1:2*m)+FreeResponse;
Y1_Pred = Y_Pred(1:p);
Y2_Pred = Y_Pred(p+1:end);

%% Cost
w1=Q1;w2=Q1;w3=R;%w4=Q2;w5=Q2;w6=Q3;
z1=Q1*sum((Y1_Pred-Ref1).^2);
z2=Q1*sum((Y2_Pred-Ref2).^2);
z3=R*sum(dU(1:2*m).^2);
% z4=Q2*sum((W1-Ref1).^2);
% z5=Q2*sum((W2-Ref2).^2);
% z6=Q3*(Chi'*Chi);
Z_ToTAL = z1+z2+z3;
%% --------------------------------------------------------------------------------------
Sol.dU=dU;
Sol.w1=w1;
Sol.w2=w2;
Sol.w3=w3;
Sol.z1=z1;
Sol.z2=z2;
Sol.z3=z3;
Sol.Z_ToTAL=Z_ToTAL;
Sol.W1=W1;
Sol.W2=W2;
Sol.Ref1=Ref1;
Sol.Ref2=Ref2;
Sol.Y1max=Y1max;Sol.Y2max=Y2max;Sol.Y3max=Y3max;Sol.Y4max=Y4max;
Sol.Y1_Pred=Y1_Pred;Sol.Y2_Pred=Y2_Pred;
end
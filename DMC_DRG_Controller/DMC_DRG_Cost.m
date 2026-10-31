function [Z_ToTAL, Sol]= DMC_DRG_Cost(dU, G, FreeResponse, h0, W, RefTrackFlg, i, p, m, Q1, R, Q2, Q3)
%% Initialization
global Y1max Y2max Y3max Y4max;
W1=W(i:i+p-1,1);W2=W(i:i+p-1,2);
Y1_Pred = zeros(p,1);Y2_Pred = zeros(p,1);
Ref1 = zeros(p,1);Ref2 = zeros(p,1);
Chi=dU(2*m+1:2*m+p);
DeltaChi=abs(diff([0;Chi]));
if (RefTrackFlg==1)
    Ref1(1)= Chi(1)*h0(1)+(1-Chi(1))*W(i,1);
    Ref2(1)= Chi(1)*h0(2)+(1-Chi(1))*W(i,2);
    for j=2:p
        Ref1(j)= Chi(j)*Ref1(j-1)+(1-Chi(j))*W(j+i-1,1);
        Ref2(j)= Chi(j)*Ref2(j-1)+(1-Chi(j))*W(j+i-1,2);
    end
else
    Ref1=W1;Ref2=W2;
end

%% Prediction

Y_Pred=G*dU(1:2*m)+FreeResponse;
Y1_Pred = Y_Pred(1:p);
Y2_Pred = Y_Pred(p+1:end);

%% Cost
w1=Q1;w2=Q1;w3=R;w4=Q2;w5=Q2;w6=Q3;
z1=Q1*sum((Y1_Pred-Ref1).^2);
z2=Q1*sum((Y2_Pred-Ref2).^2);
z3=R*sum(dU(1:2*m).^2);
z4=Q2*sum((W1-Ref1).^2);
z5=Q2*sum((W2-Ref2).^2);
z6=Q3*(Chi'*Chi);
Z_ToTAL = z1+z2+z3+z4+z5+z6;
%% --------------------------------------------------------------------------------------
Sol.dU=dU;
Sol.w1=w1;
Sol.w2=w2;
Sol.w3=w3;
Sol.w4=w4;
Sol.w5=w5;
Sol.w6=w6;
Sol.z1=z1;
Sol.z2=z2;
Sol.z3=z3;
Sol.z4=z4;
Sol.z5=z5;
Sol.z6=z6;
Sol.Z_ToTAL=Z_ToTAL;
Sol.Chi=Chi;
Sol.DeltaChi=DeltaChi;
Sol.W1=W1;
Sol.W2=W2;
Sol.Ref1=Ref1;
Sol.Ref2=Ref2;
Sol.Y1max=Y1max;Sol.Y2max=Y2max;Sol.Y3max=Y3max;Sol.Y4max=Y4max;
Sol.Y1_Pred=Y1_Pred;Sol.Y2_Pred=Y2_Pred;
end
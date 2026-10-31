clear;clc;close all;

A1 = 254.47;% cm^2
a1 = 1.13;% cm^2
A2 = 176.71;% cm^2
a2 = 0.785;% cm^2
A3 = 254.47;% cm^2
a3 = 1.13;% cm^2
A4 = 176.71;% cm^2
a4 = 0.785;% cm^2
g=981;% cm/S^2

% Operation points based on Refrences.
Hs1=[8.1,5.2,4.6];
Hs2=[11.3,7.2,4.5];
Hs3=[3.3,2.1,2.5];
Hs4=[5  ,3.2,1.3];

for i= 1:size(Hs1,2)
    hs1 = Hs1(i);hs2 = Hs2(i);hs3 = Hs3(i);hs4 = Hs4(i);  
    tau1 = (A1 / a1) * sqrt(2 * hs1 / g);
    tau2 = (A2 / a2) * sqrt(2 * hs2 / g);
    tau3 = (A3 / a3) * sqrt(2 * hs3 / g);
    tau4 = (A4 / a4) * sqrt(2 * hs4 / g);
    fprintf('calculate tau for the operating point %i :\n', i);
    fprintf('hs1 %2.2f (cm) --->  tau1  %2.2f (s)\n', hs1, tau1);
    fprintf('hs2 %2.2f (cm) --->  tau2  %2.2f (s)\n', hs2, tau2);
    fprintf('hs3 %2.2f (cm) --->  tau3  %2.2f (s)\n', hs3, tau3);
    fprintf('hs4 %2.2f (cm) --->  tau4  %2.2f (s)\n', hs4, tau4);
    fprintf('-----------------------------------------------\n');
end

%% Results
% calculate tau for the operating point 1 :
% hs1 8.10 (cm) --->  tau1  28.94 (s)
% hs2 11.30 (cm) --->  tau2  34.17 (s)
% hs3 3.30 (cm) --->  tau3  18.47 (s)
% hs4 5.00 (cm) --->  tau4  22.73 (s)
% -----------------------------------------------
% calculate tau for the operating point 2 :
% hs1 5.20 (cm) --->  tau1  23.19 (s)
% hs2 7.20 (cm) --->  tau2  27.27 (s)
% hs3 2.10 (cm) --->  tau3  14.73 (s)
% hs4 3.20 (cm) --->  tau4  18.18 (s)
% -----------------------------------------------
% calculate tau for the operating point 3 :
% hs1 4.60 (cm) --->  tau1  21.81 (s)
% hs2 4.50 (cm) --->  tau2  21.56 (s)
% hs3 2.50 (cm) --->  tau3  16.08 (s)
% hs4 1.30 (cm) --->  tau4  11.59 (s)
% -----------------------------------------------

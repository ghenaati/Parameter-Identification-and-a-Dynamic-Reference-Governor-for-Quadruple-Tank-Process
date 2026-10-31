%% Load data
clc
clear
close all;format long;
y1init=5;u1init=0;Vmax=12;
y2init=5;u2init=0;Vmin=0;


Color1 = [230,125, 50]/255; 
Color2 = [ 10, 10,255]/255; 
Color3 = [ 10,255, 10]/255; 
Color4 = [230, 26, 26]/255; 
Color5 = [163, 20, 46]/255; 

LineStyle1='-';
LineStyle2='-.';
LineStyle3=':';
LineStyle4='--';

LineWidth1=6;
LineWidth2=3; 
TextColor='black';FontName='Times new Roman';FontWeight= 'bold';
FontSizeLeg=32;
FontSizeAx=32;

%% plot Results for Paper
%--------------------------------------------------------------------------
% Figure (4) in paper
figure(4)
load('StepResponse.mat');
stairs(T,Y11,'b-','LineWidth',LineWidth1);hold on;grid on;
stairs(T,Y21,'-.','Color', [0.35, 1.0, 0.35],'LineWidth',LineWidth1);
stairs(T,Y12,'-.','Color', [0.35, 0.35, 1.0],'LineWidth',LineWidth1);
stairs(T,Y22,'g-','LineWidth',LineWidth1);
xlim([0 200])
ylim([0 0.72])
xlabel('Time (s)');
ylabel('Height of Tanks (cm/V)');title('Step Response');
legend('Tank1 from Pump1','Tank2 from Pump1','Tank1 from Pump2','Tank2 from Pump2','EdgeColor','k','NumColumns', 3,'FontSize',FontSizeLeg);

grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%--------------------------------------------------------------------------

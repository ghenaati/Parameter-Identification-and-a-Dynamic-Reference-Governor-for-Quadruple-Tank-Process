clc
clear
close all
%----------------------------------------
load('StepResponse.mat');
Main     =  'Results_DMC_DRG_Scenario1';
CompareName='Results_DMC_Scenario1';
Compare=1;

Color1 = [230,125, 50]/255; 
Color2 = [ 10, 10,255]/255; 
Color3 = [ 10,255, 10]/255; 
Color4 = [230, 26, 26]/255; 
Color5 = [163, 20, 46]/255; 

LineStyle1='-';
LineStyle2='-.';
LineStyle3=':';
LineStyle4='--';

LineWidth1=4.1;
LineWidth2=3; 

TextColor='black';FontName='Times new Roman';FontWeight= 'bold';
FontSizeLeg=16;
FontSizeAx=24;

load(Main);
RefTrajectory=zeros(Nt,2);
for i=1:Nt-1
    RefTrajectory(i,1)=Sol(i).Ref1(1);
    RefTrajectory(i,2)=Sol(i).Ref2(1);
end

%% Figure (11) in paper
figure(11)
subplot(2, 2, 1);
load(Main);
TSIM=Ts*(1:Nt-1)';
plot(TSIM, W(1:Nt-1,1),'Color',Color1, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1); hold on
plot(TSIM, Y(1:end-1,1),'Color',Color2, 'LineStyle',LineStyle1,  'LineWidth' , LineWidth1);
plot(TSIM, RefTrajectory(1:end-1,1),'Color',Color3, 'LineStyle',LineStyle2,  'LineWidth' , LineWidth1);
plot(TSIM, Y1max*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,  'LineWidth' , LineWidth1);
if (Compare==1)
 load(CompareName);
 plot(TSIM, Y(1:end-1,1),'Color',Color5, 'LineStyle',LineStyle3,  'LineWidth' , LineWidth2);
 legend({'Desired Reference 1 ({\it w}^{1})' , 'Measured Output 1 ({\it y}_{{\it m}}^{1})', 'Governed Reference 1 ({\it r}_{{\it w}}^{1})','Constraint','Simple DMC'},'Location','best','FontSize',FontSizeLeg,'NumColumns',2);
else
 legend({'Desired Reference 1 ({\it w}^{1})' , 'Measured Output 1 ({\it y}_{{\it m}}^{1})', 'Governed Reference 1 ({\it r}_{{\it w}}^{1})','Constraint'},'Location','best','FontSize',FontSizeLeg,'NumColumns',2);
end 

% xlim([10,2010]);
ylim([0,10]);
yticks(2:2:12);
xlabel('Time (s)');
ylabel('Height (cm)');
% title('DRG-DMC Algorithm');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%------------------------------------------------------------
subplot(2, 2, 2);
load(Main);
plot(TSIM, W(1:Nt-1,2),'Color',Color1, 'LineStyle',LineStyle1,  'LineWidth' , LineWidth1); hold on
plot(TSIM, Y(1:end-1,2),'Color',Color2, 'LineStyle',LineStyle1,  'LineWidth' , LineWidth1);
plot(TSIM, RefTrajectory(1:end-1,2),'Color',Color3, 'LineStyle',LineStyle2,  'LineWidth' , LineWidth1);
plot(TSIM, Y2max*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,  'LineWidth' , LineWidth1);
if (Compare==1)
 load(CompareName);
 plot(TSIM, Y(1:end-1,2),'Color',Color5, 'LineStyle',LineStyle3,  'LineWidth' , LineWidth2);
 legend({'Desired Reference 2 ({\it w}^{2})' , 'Measured Output 2 ({\it y}_{{\it m}}^{2})', 'Governed Reference 2 ({\it r}_{{\it w}}^{2})','Constraint','Simple DMC'},'Location','best','FontSize',FontSizeLeg,'NumColumns',2);
else
 legend({'Desired Reference 2 ({\it w}^{2})' , 'Measured Output 2 ({\it y}_{{\it m}}^{2})', 'Governed Reference 2 ({\it r}_{{\it w}}^{2})','Constraint'},'Location','best','FontSize',FontSizeLeg,'NumColumns',2);    
end 

% xlim([10,2010]);
ylim([0,15]);
yticks(2:2:14);
xlabel('Time (s)');
ylabel('Height (cm)');
% title('DRG-DMC Algorithm');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%-----------------------------------------------
subplot(2, 2, 3);
load(Main);
plot(TSIM, Y(1:end-1,3),'Color',Color2, 'LineStyle',LineStyle1,  'LineWidth' , LineWidth1); hold on
plot(TSIM, Y3max*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,  'LineWidth' , LineWidth1); hold on
if (Compare==1)
 load(CompareName);
 plot(TSIM, Y(1:end-1,3),'Color',Color5, 'LineStyle',LineStyle3,  'LineWidth' , LineWidth2);
 legend({'Tank 3','Constraint','Simple DMC'},'Location','best','FontSize',FontSizeLeg);
else
 legend({'Tank 3','Constraint'},'Location','best','FontSize',FontSizeLeg);
end 

% xlim([10,2010]);
ylim([0,Y3max+1]);
xlabel('Time (s)');
ylabel('Height (cm)');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%-----------------------------------------------
subplot(2, 2, 4);
load(Main);
plot(TSIM, Y(1:end-1,4),'Color',Color2, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1); hold on
plot(TSIM, Y4max*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,  'LineWidth' , LineWidth1); hold on
if (Compare==1)
 load(CompareName);
 plot(TSIM, Y(1:end-1,4),'Color',Color5, 'LineStyle',LineStyle3,  'LineWidth' , LineWidth2);
 legend({'Tank 4','Constraint','Simple DMC'},'Location','best','FontSize',FontSizeLeg);
else
 legend({'Tank 4','Constraint'},'Location','best','FontSize',FontSizeLeg);
end 
% xlim([10,2010]);
ylim([0,Y4max+1]);
xlabel('Time (s)');
ylabel('Height (cm)');
% legend({'Tank 4','Constraint'},'Location','best','FontSize',FontSizeLeg);
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%% Figure (12) in paper
figure(12)
load(Main);
plot(TSIM,CHI(1:end-1,1) ,'Color',Color2, 'LineWidth' , LineWidth1,'LineStyle',LineStyle1); hold on
plot(TSIM,CHI(1:end-1,2) ,'Color',Color1, 'LineWidth' , LineWidth1,'LineStyle',LineStyle2);
plot(TSIM,CHI(1:end-1,3) ,'Color',Color3, 'LineWidth' , LineWidth1,'LineStyle',LineStyle3);
plot(TSIM,CHI(1:end-1,4) ,'Color',Color4, 'LineWidth' , LineWidth1,'LineStyle',LineStyle4);
plot(TSIM,CHI(1:end-1,5) ,'Color',Color5, 'LineWidth' , LineWidth1,'LineStyle',LineStyle1);
% xlim([10,2010]);
ylim([0,1.05]);
xlabel('Time (s)');
ylabel('Values');
legend({'\chi 1','\chi 2','\chi 3','\chi 4','\chi 5'},'Location','best','FontSize',FontSizeLeg+10);
title('Reference Adjustment Vector');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%% Figure (13) in paper
figure(13)
plot(TSIM,Fval(1:end-1,1) ,'Color',Color2, 'LineWidth' , LineWidth1,'LineStyle',LineStyle1);
title('\itJ_{DRG}');
% xlim([10,2010]);
xlabel('Time (s)');
ylabel('Value');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';


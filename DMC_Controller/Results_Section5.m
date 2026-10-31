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

LineWidth1=4.1;
LineWidth2=3; 
TextColor='black';FontName='Times new Roman';FontWeight= 'bold';
FontSizeLeg=24;
FontSizeAx=24;

ANA=strcat('Results_DMC_ANA');
SQP=strcat('Results_DMC_Section5');
%% plot Results for Paper
%--------------------------------------------------------------------------
% Figure (5) in paper
figure(5)
LineStyleArrow1='-';
LineStyleArrow2='--';
LineStyleArrow3='-.';
LineStyleArrow4=':';
annotation('textbox',[.420 .885 .04 0.04],'String','Past','FontName', FontName,'FontWeight',FontWeight,'FontSize',FontSizeAx-2,'FitBoxToText','on','EdgeColor','None');
annotation('textbox',[.500 .885 .04 0.04],'String','Future','FontName', FontName,'FontWeight',FontWeight,'FontSize',FontSizeAx-2,'FitBoxToText','on','EdgeColor','None');
annotation('arrow',  [.474 .474],[.35 .93],'LineStyle',LineStyleArrow2,'LineWidth',LineWidth2);
annotation('doublearrow',  [.388 .559],[.88 .88],'LineStyle',LineStyleArrow2,'LineWidth',LineWidth2);
annotation('textbox',[.477 .800 .09 0.01],'String','Current Input','FontName', FontName,'FontWeight',FontWeight,'FontSize',FontSizeAx-2,'FitBoxToText','on','EdgeColor','None');
annotation('doublearrow',  [.476 .559],[.77 .77],'LineStyle',LineStyleArrow2,'LineWidth',LineWidth2);
annotation('textbox',[.600 .730 .11 0.04],'String','Prediction and Control Horizon','FontName', FontName,'FontWeight',FontWeight,'FontSize',FontSizeAx-2,'FitBoxToText','on','EdgeColor','None');
annotation('doublearrow',  [.476 .905],[.73 .73],'LineStyle',LineStyleArrow2,'LineWidth',LineWidth2);

load(SQP);
TSIM=Ts*(1:Nt-1)';
NS1=5;
NS2=NS1+p;
TSIM1=TSIM(1:NS1);
TSIM2=[TSIM(NS1);TSIM(NS1:NS1+1)];
TSIM3=[TSIM(NS1+1);TSIM(NS1+1:NS2)];
TSIMT=TSIM(1:NS2+1);

U1TSIM1_SQP=[U(1:NS1-1,1);U(NS1-1,1)];
U2TSIM1_SQP=[U(1:NS1-1,2);U(NS1-1,2)];
U1TSIM2_SQP=[U(NS1-1,1);U(NS1,1);U(NS1,1)];
U2TSIM2_SQP=[U(NS1-1,2);U(NS1,2);U(NS1,2)];
U1TSIM3_SQP=[U(NS1-1,1)+cumsum(dU_Rep(1:m,NS1));U(NS1-1,1)+sum(dU_Rep(1:m,NS1))];   
U2TSIM3_SQP=[U(NS1-1,2)+cumsum(dU_Rep(m+1:2*m,NS1));U(NS1-1,2)+sum(dU_Rep(m+1:2*m,NS1))];   

stairs(TSIM1 ,U1TSIM1_SQP,'Color',Color2, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM2 ,U1TSIM2_SQP,'Color',Color2, 'LineStyle',LineStyle2, 'LineWidth' , LineWidth1) ; 
stairs(TSIM3 ,U1TSIM3_SQP,'Color',Color2, 'LineStyle',LineStyle3, 'LineWidth' , LineWidth1) ; 
stairs(TSIM1 ,U2TSIM1_SQP,'Color',Color3, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1) ; 
stairs(TSIM2 ,U2TSIM2_SQP,'Color',Color3, 'LineStyle',LineStyle2, 'LineWidth' , LineWidth1) ; 
stairs(TSIM3 ,U2TSIM3_SQP,'Color',Color3, 'LineStyle',LineStyle3, 'LineWidth' , LineWidth1) ; 

load(ANA);
U1TSIM1_ANA=[U(1:NS1-1,1);U(NS1-1,1)];
U2TSIM1_ANA=[U(1:NS1-1,2);U(NS1-1,2)];
U1TSIM2_ANA=[U(NS1-1,1);U(NS1,1);U(NS1,1)];
U2TSIM2_ANA=[U(NS1-1,2);U(NS1,2);U(NS1,2)];
U1TSIM3_ANA=[U(NS1-1,1)+cumsum(dU_Rep(1:m,NS1));U(NS1-1,1)+sum(dU_Rep(1:m,NS1))];   
U2TSIM3_ANA=[U(NS1-1,2)+cumsum(dU_Rep(m+1:2*m,NS1));U(NS1-1,2)+sum(dU_Rep(m+1:2*m,NS1))]; 

stairs(TSIM1 ,U1TSIM1_ANA,'Color',Color1, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM2 ,U1TSIM2_ANA,'Color',Color1, 'LineStyle',LineStyle2, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM3 ,U1TSIM3_ANA,'Color',Color1, 'LineStyle',LineStyle3, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM1 ,U2TSIM1_ANA,'Color',Color5, 'LineStyle',LineStyle1, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM2 ,U2TSIM2_ANA,'Color',Color5, 'LineStyle',LineStyle2, 'LineWidth' , LineWidth1) ; hold on
stairs(TSIM3 ,U2TSIM3_ANA,'Color',Color5, 'LineStyle',LineStyle3, 'LineWidth' , LineWidth1) ; hold on

plot(TSIMT ,Vmax*ones(size(TSIMT)),'Color',Color4, 'LineStyle',LineStyle4, 'LineWidth' , LineWidth1) ; hold on
plot(TSIMT ,Vmin*ones(size(TSIMT)),'Color',Color4, 'LineStyle',LineStyle4, 'LineWidth' , LineWidth1) ; hold on
xlabel('Time (s)') ;
ylabel('Voltage (v)') ;
xlim([10,100]);
ylim([-2,15]);

legend({'Implemeted Input V_1(SQP)','Current Input V_1(SQP)','Predicted Input V_1(SQP)','Implemeted Input V_2(SQP)','Current Input V_2(SQP)','Predicted Input V_2(SQP)',...
        'Implemeted Input V_1(ANA)','Current Input V_1(ANA)','Predicted Input V_1(ANA)','Implemeted Input V_2(ANA)','Current Input V_2(ANA)','Predicted Input V_2(ANA)',...
        'Constraint'},'Location','southoutside','NumColumns',5,'EdgeColor','k','FontSize',FontSizeLeg-4);
title('Input Signal');
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%--------------------------------------------------------------------------
% Figure (6) in paper
figure(6) ;
load(SQP);TSIM=Ts*(0:Nt-1)';
plot( TSIM ,[W(1,1), W(1:Nt-1,1)'],'Color',Color1, 'LineStyle',LineStyle1,'LineWidth',LineWidth1) ; hold on
plot( TSIM ,[y1init,Y(1:end-1,1)'],'Color',Color2, 'LineStyle',LineStyle1,'LineWidth',LineWidth1) ; hold on
load(ANA);TSIM=Ts*(0:Nt-1)';
plot( TSIM ,[y1init,Y(1:end-1,1)'],'Color',Color3, 'LineStyle',LineStyle3,'LineWidth',LineWidth1) ; hold on

xlabel('Time (s)');
ylabel('Height (cm)') ;ylim([1,10]);
title('DMC Algorithm') ;
legend({'Desired Reference 1 ({\it w}^{1})' ,'SQP','Analytical'},'Location','southeast','NumColumns',1,'EdgeColor','k','FontSize',FontSizeLeg)
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%--------------------------------------------------------------------------
% Figure (7) in paper
figure(7) ;
load(SQP);TSIM=Ts*(0:Nt-1)';
plot( TSIM ,[W(1,2), W(1:Nt-1,2)'],'Color',Color1, 'LineStyle',LineStyle1,'LineWidth',LineWidth1) ; hold on
plot( TSIM ,[y2init,Y(1:end-1,2)'],'Color',Color2, 'LineStyle',LineStyle1,'LineWidth',LineWidth1) ; hold on
load(ANA);TSIM=Ts*(0:Nt-1)';
plot( TSIM ,[y2init,Y(1:end-1,2)'],'Color',Color3, 'LineStyle',LineStyle3,'LineWidth',LineWidth1) ; hold on

xlabel('Time (s)');
ylabel('Height (cm)') ;ylim([1,12]);
title('DMC Algorithm') ;
legend({'Desired Reference 2 ({\it w}^{2})' , 'SQP','Analytical'},'Location','southeast','NumColumns',1,'EdgeColor','k','FontSize',FontSizeLeg)
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%--------------------------------------------------------------------------
% Figure (8) in paper
figure(8) ;
load(SQP);TSIM=Ts*(1:Nt-1)';
stairs(TSIM ,U(1:end-1,1),'Color',Color2, 'LineStyle',LineStyle1,'LineWidth',LineWidth1); hold on
stairs(TSIM ,U(1:end-1,2),'Color',Color3, 'LineStyle',LineStyle1,'LineWidth',LineWidth1); hold on
plot(TSIM ,Vmax*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,'LineWidth',LineWidth1); hold on
plot(TSIM ,Vmin*ones(size(TSIM)),'Color',Color4, 'LineStyle',LineStyle4,'LineWidth',LineWidth1); hold on
xlabel('Time (s)') ;
ylabel('Voltage (v)') ;ylim([-0.2,13]);
legend({'V_1','V_2','Constraint'},'Location','southeast','NumColumns',1,'EdgeColor','k','FontSize',FontSizeLeg)
title('Input Signal') ;
grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

%--------------------------------------------------------------------------
% Figure (9) in paper
figure(9) ;
load(SQP);TSIM=Ts*(1:Nt-1)';
plot(TSIM , Fval(1:end-1),'Color',Color2, 'LineStyle',LineStyle1,'LineWidth',LineWidth1); hold on
xlabel('Time (s)') ;
ylabel('Cost Function') ;
title('\itJ_{QTP}')

grid on
ax = gca;
ax.FontName = FontName;
ax.FontWeight= FontWeight;
ax.FontSize= FontSizeAx;
ax.XColor=TextColor;
ax.YColor=TextColor;
ax.GridLineStyle= '-.';

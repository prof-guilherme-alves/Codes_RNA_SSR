clear all
clc

data_grafico = xlsread('data_plot_graphic.xlsx');

% LIMITES DA SSR - 20 hrs
Ypred_mvar=data_grafico(:,1) ;
Ypred_mw=data_grafico(:,2) ;
Ypred_seg=data_grafico(:,3) ;
Ypred_v=data_grafico(:,4) ;
Ypred_term=data_grafico(:,5) ;

alpha=.3;
h=1;  
x=1;

% PONTO OPERACIONAL DO SISTEMA - 20 hrs:
OP1=132.7400; % PG1
OP2= 83.9700; % PG2
OP3= 79.3000; % PG3
Pd= 293.8950;
Qd= 107.2950;

%% PLOTA G2 E G3
figure()
hold on

% LIMITE DE MVAR:
Y=Ypred_mvar;
g2_mvar=[Y(9:16,x);Y(9,x)];
g3_mvar=[Y(17:end,x);Y(17,x)];

patch(g2_mvar,g3_mvar,[107/255 66/255 38/255],'EdgeColor',[107/255 66/255 38/255]); % marrom

% LIMITE TÉRMICO:
Y=Ypred_term;
g2_term=[Y(9:16,x);Y(9,x)];
g3_term=[Y(17:end,x);Y(17,x)];

patch(g2_term,g3_term,[0 0 1],'EdgeColor',[0 0 1]) % azul

% LIMITE DE MW:
Y=Ypred_mw;
g2_mw=[Y(9:16,x);Y(9,x)];
g3_mw=[Y(17:end,x);Y(17,x)];

patch(g2_mw,g3_mw,[1 165/255 0],'EdgeColor',[1 165/255 0]); %laranja

% LIMITE DE SEGURANÇA:
Y=Ypred_seg;
g2_seg=[Y(9:16,x);Y(9,x)];
g3_seg=[Y(17:end,x);Y(17,x)];

patch(g2_seg,g3_seg,'y','EdgeColor','y') % amarelo

% LIMITE DE TENSÃO:
Y=Ypred_v;
g2_v=[Y(9:16,x);Y(9,x)];
g3_v=[Y(17:end,x);Y(17,x)];

patch(g2_v,g3_v,[127/255 1 0],'EdgeColor',[127/255 1 0]) %verde

% Define a RSE
[x,y] = polybool('and',g2_mvar,g3_mvar,g2_mw,g3_mw);
[x,y] = polybool('and',x,y,g2_seg,g3_seg);
[x,y] = polybool('and',x,y,g2_term,g3_term);
[x,y] = polybool('and',x,y,g2_v,g3_v);

patch(x,y,[0 0.5  0 ],'EdgeColor',[0 0.5  0 ])
 
% Plota ponto operacional:
plot(OP2(h),OP3(h),'-s','MarkerSize',8,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')

%Legendas:
xlabel('\bf G2 (MW)')
ylabel('\bf G3 (MW)')
legend({'\bf Reactive Power','\bf Thermal','\bf Active Power','\bf Security','\bf Voltage', '\bf SSR'},'FontSize', 10)

x = [0.29 0.34];
y = [0.66 0.66];
annotation('textarrow',x,y,'String','\bfOP ')

xlim([0 280])
ylim([-5 120])
xticks(-20:20:280)
yticks(0:10:120)

% cor de fundo do gráfico:
set(gca,'color','r')
 
 grid on
 



clear all
clc

data_grafico = xlsread('data_graphic.xlsx');
base=8000;

% LIMITES DA SSR - 6 da manhã
Ypred_mvar=data_grafico(:,1) ;
Ypred_mw=data_grafico(:,2) ;
Ypred_seg=data_grafico(:,3) ;
Ypred_v=data_grafico(:,4) ;
Ypred_term=data_grafico(:,5) ;

alpha=.3;
h=1;  

% PONTO OPERACIONAL DO SISTEMA - 6 horas da manhã:
OP1=927.1000;
OP2=1.7811e+03;
OP3=3.3993e+03;
Pd=6.0606e+03;
Qd=1.3882e+03;

%% PLOTA G2 E G3
figure()
hold on

% LIMITE DE MVAR:
Y=Ypred_mvar;
g2_mvar=[Y(9:16,h);Y(9,h)];
g3_mvar=[Y(17:end,h);Y(17,h)];

patch(g2_mvar,g3_mvar,[107/255 66/255 38/255],'EdgeColor',[107/255 66/255 38/255]); % marrom

% LIMITE TÉRMICO:
Y=Ypred_term;
g2_term=[Y(9:16,h);Y(9,h)];
g3_term=[Y(17:end,h);Y(17,h)];

patch(g2_term,g3_term,[0 0 1],'EdgeColor',[0 0 1]) % azul

% LIMITE DE MW:
Y=Ypred_mw;
g2_mw=[Y(9:16,h);Y(9,h)];
g3_mw=[Y(17:end,h);Y(17,h)];

patch(g2_mw,g3_mw,[1 165/255 0],'EdgeColor',[1 165/255 0]); %laranja

% LIMITE DE SEGURANÇA:
Y=Ypred_seg;
g2_seg=[Y(9:16,h);Y(9,h)];
g3_seg=[Y(17:end,h);Y(17,h)];

patch(g2_seg,g3_seg,'y','EdgeColor','y') % amarelo

% LIMITE DE TENSÃO:
Y=Ypred_v;
g2_v=[Y(9:16,h);Y(9,h)];
g3_v=[Y(17:end,h);Y(17,h)];

patch(g2_v,g3_v,[127/255 1 0],'EdgeColor',[127/255 1 0]) %verde

% Define a RSE
[x,y] = polybool('and',g2_mvar,g3_mvar,g2_mw,g3_mw);
[x,y] = polybool('and',x,y,g2_seg,g3_seg);
[x,y] = polybool('and',x,y,g2_term,g3_term);
[x,y] = polybool('and',x,y,g2_v,g3_v);

patch(x,y,[0 0.5  0 ],'EdgeColor',[0 0.5  0 ])
 
plot(OP2(h),OP3(h),'-s','MarkerSize',8,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')

%Legendas:
xlabel('\bf G2 (MW)')
ylabel('\bf G3 (MW)')
legend({'\bf Reactive Power','\bf Thermal','\bf Active Power','\bf Security','\bf Voltage', '\bf SSR'},'FontSize', 10)

x = [0.37 0.42];
y = [0.583 0.583];
annotation('textarrow',x,y,'String','\bfOP ')

 xlim([-500 5000])
 ylim([500 5500])
 xticks(-500:500:5000)
  
% cor de fundo do gráfico:
set(gca,'color','r')
 
 grid on





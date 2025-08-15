clear all
close all
clc

data = xlsread('load_curve_39bus_voltage.xlsx');

tic;
base=8000;

X=data(:,3:7);
Y=data(:,8:end);

[n_po,~] = size(X); % número de pontos operacionais

% Normalização Min-Max entrada
X_norm = X./(base);

% Normalização Min-Max saída
Y_norm = Y./(base);

% Carrega rede treinada:
load('best_net.mat')

% Faz as predições:
Y_pred=best_net(X_norm'); % saída está normalizada

% Erro médio quadrático
Y_real=Y';
Y_est=Y_pred*base;

mse_value_pu  = mse(Y_norm' - Y_pred) 
mse_value_mw  = mse(Y_real - Y_est) 

% Erro absoluto em pu e mw:
Erro_abs_pu=(Y_norm'-Y_pred);
max_erro_abs_pu=max(max(abs(Erro_abs_pu)))

Erro_abs_mw=((Y_real-Y_est));
max_erro_abs_mw=max(max(abs(Erro_abs_mw)))

[y_linha, y_col] = find(abs(Erro_abs_mw) == (max_erro_abs_mw), 1);

hora_maior_erro_abs=y_col-1

%% PLOTA G2 E G3
figure()
hold on

[~, col] = find(abs(Erro_abs_mw) == (max_erro_abs_mw), 1);  
x=col; % condição operativa com maior erro absoluto em mw

OP2=X(x,2);
OP3=X(x,3);

% REGIÃO REAL:
g2_mvar=[Y_real(9:16,x);Y_real(9,x)];
g3_mvar=[Y_real(17:end,x);Y_real(17,x)];

plot(g2_mvar,g3_mvar,'k')
 
 % REGIÃO ESTIMADA:
g2_mvar=[Y_est(9:16,x);Y_est(9,x)];
g3_mvar=[Y_est(17:end,x);Y_est(17,x)];

plot(g2_mvar,g3_mvar,'r')

% Plota ponto operacional:
plot(OP2,OP3,'-s','MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
 
 %Legendas:
xlabel('\bf G2 (MW)')
ylabel('\bf G3 (MW)')
 legend({'\bf Real','\bf Estimada', '\bf PO'},'FontSize', 10)

title('Limite de Tensão')

tempo=toc

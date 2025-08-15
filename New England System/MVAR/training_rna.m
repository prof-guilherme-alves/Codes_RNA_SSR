clear all
clc
close all

tic
% Fixar a seed para reprodutibilidade
rng(100);

% Potência base
base=8000;

% Leitura dos dados
data = xlsread('data_39bus_mvar.xlsx');

% Obter o número de linhas na matriz
num_linhas = size(data, 1);

% Gerar uma permutação aleatória dos índices das linhas
indices_permutados = randperm(num_linhas);

% Reorganizar a matriz de acordo com a permutação aleatória
data_ale = data(indices_permutados, :);

X = data_ale(:, 3:7);
Y = data_ale(:, 8:end);

% Normalização Min-Max entrada
X_norm = X ./ base;

% Normalização Min-Max saída
Y_norm = Y ./base;

% Configuração de hiperparâmetros
num_max_camadas_ocultas = 2; % Número máximo de camadas ocultas
num_max_neuronios_por_camada = 28; % Número máximo de neurônios por camada
CR = [21 17]; % Configuração dos neurônios nas camadas ocultas vinda da busca bayesiana

% Número de folds para validação cruzada
k = 10;
indices = crossvalind('Kfold', num_linhas, k);

emq_values = zeros(k, 1);
best_net = [];
best_emq = inf;

for i = 1:k
    % Dividir os dados em treinamento e validação
    testIdx = (indices == i); % Índices do conjunto de teste
    trainIdx = ~testIdx; % Índices do conjunto de treinamento

    X_train = X_norm(trainIdx, :)';
    Y_train = Y_norm(trainIdx, :)';
    X_test = X_norm(testIdx, :)';
    Y_test = Y_norm(testIdx, :)';
    
    % Configurar a rede neural
    net = feedforwardnet(CR);
    net.trainParam.max_fail = 10;
    net.trainParam.min_grad = 1e-6;
    
    % Configurar a rede com os dados de entrada para definir corretamente os tamanhos
    net = configure(net, X_train, Y_train);

    % Inicializar manualmente os pesos e biases
    inputSize = size(X_train, 1); % Número de características de entrada
    outputSize = size(Y_train, 1); % Número de saídas
    
    % Treinando a rede neural
    [net, tr] = train(net, X_train, Y_train);
    
    % Avaliar o desempenho nos dados de teste
    Y_pred = net(X_test);
    
    % Ajustar dimensões de Y_test e Y_pred para o cálculo do EMQ
    Y_test = Y_test(:);
    Y_pred = Y_pred(:);
    
    % Calcular o EMQ
    emq_values(i) = mean((Y_test - Y_pred).^2);
    
    % Verificar se esta rede tem o menor EMQ
    if emq_values(i) < best_emq
        best_emq = emq_values(i);
        best_net = net;
        best_tr = tr; % Guardar o objeto de treinamento para a melhor rede
    end
end

% Calcular a média e desvio padrão do EMQ
emq_mean = mean(emq_values);
emq_std = std(emq_values);

disp(['Média do EMQ: ', num2str(emq_mean)]);
disp(['Desvio Padrão do EMQ: ', num2str(emq_std)]);
disp(['Melhor EMQ: ', num2str(best_emq)]);

% Salvar a melhor rede neural em um arquivo .mat
save('best_net.mat', 'best_net');

% Salvar o objeto best_tr em um arquivo .mat
save('best_net_results.mat', 'best_tr');

toc

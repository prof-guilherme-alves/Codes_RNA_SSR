clear all
clc

data = xlsread('data_9bus_mvar.xlsx');
base=315;

% Obter o número de linhas na matriz
num_linhas = size(data, 1);

% Gerar uma permutação aleatória dos índices das linhas
indices_permutados = randperm(num_linhas);

% Reorganizar a matriz de acordo com a permutação aleatória
data_ale = data(indices_permutados, :);

X=data_ale(:,3:7);
Y=data_ale(:,8:end);

% Normalização entrada
X_norm=X./base;

% Normalização  saída
Y_min = min(min(Y));
Y_max = max(max(Y));
Y_norm = Y./base;

inputs=X_norm';
targets=Y_norm';

% Definir os hiperparâmetros para otimização
optimVars = [
    optimizableVariable('num_neurons_layer1', [1, 28], 'Type', 'integer');
    optimizableVariable('num_neurons_layer2', [1, 28], 'Type', 'integer');
    optimizableVariable('num_layers', [1, 2], 'Type', 'integer')
];

% Função de otimização bayesiana
results = bayesopt(@(x)trainAndEvaluate(x.num_layers, x.num_neurons_layer1, x.num_neurons_layer2, inputs, targets), ...
    optimVars, 'MaxObjectiveEvaluations', 50);

% Obter os melhores parâmetros
best_params = bestPoint(results);

% Salvar os resultados da busca bayesiana
save('bayesopt_results.mat', 'results', 'best_params');

function mse = trainAndEvaluate(num_layers, num_neurons_layer1, num_neurons_layer2, inputs, targets)
if num_layers == 1
    net = feedforwardnet(num_neurons_layer1);
else
    net = feedforwardnet([num_neurons_layer1, num_neurons_layer2]);
end

net = train(net, inputs, targets);
predictions = net(inputs);
mse = perform(net, targets, predictions);
end



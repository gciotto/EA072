%% Funcao numberNeuronsMLP
%  Esta funcao utiliza os programas utilizados pelo professor
%  (nn1h_k_folds.m e analysis.m) para automatizar o processo de teste para
%  diversos valores de neuronios na camada intermediaria e numeros de
%  iteracoes a serem utilizadas pelo algoritmo otimizador. Recebe como
%  parametro o valor maximo do numero de neuronios.
%  AUTOR: Gustavo CIOTTO PINTON
function numberNeuronsMLP (N)

close all;

erro_tot_avg_iter = [];
mean_eqmv_min_avg_itr = [];

% Conjuntos a serem testados para o numero de neuronios na camada
% intermediaria e iteracoes do algoritmo otimizador
neurons_interval = 5:N;
iter_interval = [50:50:200  300:100:1000];

% Para cada nukmero de iteracoes
for n = iter_interval
    
    % Vetor linha que contera todas as medias dos erros quadraticos medios
    % de validacao das MLPs treinadas.
    mean_eqmv_min_avg_array = []; 
    
    % Vetor linha que contera todas as medias dos erros quadraticos medios
    % de teste das MLPs treinadas.
    error_tot_avg_array = [];
    
    for i=neurons_interval
        
        disp(['==== ' num2str(n)  ' ITERACOES ==== ' num2str(i) ' NEURONS =====']);
        
        % Treimanento da rede MLP utilizando o algoritmo fornecido pelo
        % professor. As unicas alteracoes realizadas foram que, ao inves de
        % pedirmos ao usuario os dados, a funcao os recebe como parametro.
        % 'matrizes' eh o arquivo contendo as matrizes X e S. 1 eh a
        % resposta para o metodo 'Start the training from a random initial
        % condition' e 10, o numero de folds
        nn1h_k_folds('matrizes', 10, i, 1, n);
        
        % Da mesma forma, analysis.m foi alterada para retornar como
        % parametro os erros que foram calculados durante sua execucao.
        % Parametros tambem substituem pedidos de entrada pelo teclado
        [error_tot_avg mean_eqmv_min_avg eqm_ens] = analysis('matrizes', 1, 10);
        
        % Armazena erros no respectivos vetores
        mean_eqmv_min_avg_array = [mean_eqmv_min_avg_array mean_eqmv_min_avg];
        error_tot_avg_array = [error_tot_avg_array error_tot_avg];
        
    end
    
    % erro_tot_avg_iter eh a matriz que armazena todos o erros gerados para
    % cada valor de iteracao. Cada coluna dessa matriz representa os erros
    % de teste gerados para um valor n (iteracao) para todos o valores de neuronios
    % (i) na camada intermediaria. mean_eqmv_min_avg_itr representa a mesma
    % coisa, mas para os erros de validacao
    erro_tot_avg_iter = [erro_tot_avg_iter error_tot_avg_array'];
    mean_eqmv_min_avg_itr = [mean_eqmv_min_avg_itr mean_eqmv_min_avg_array'];
    
    % Determinacao da menor media dos erros quadraticos medios de validacao
    % para este valor de n. Eh possivel determinar portanto o valor de i
    % correspondente a essa media.
    [A B] = sort(mean_eqmv_min_avg_array, 'ascend');
    disp(sprintf('Numero de neuronios para minimizar erro de validacao: %d', B(1) + min (neurons_interval) - 1));

    % Constroi-se o grafico para cada valor das iteracoes n das medias dos
    % erros quadraticos medios de validacao e teste.
    figure
    plot(neurons_interval, mean_eqmv_min_avg_array);
    xlabel('Numero de neuronios');
    hold on; 
    plot(neurons_interval, error_tot_avg_array, 'r');
    legend('Erro de validacao', 'Erro de teste');
    plot(neurons_interval, mean_eqmv_min_avg_array, '*');
    plot(neurons_interval, error_tot_avg_array, 'r*');
    title(sprintf('Erros para N = 5 .. %d e n. iteracoes = %d', i, n));
    
    grid on;
    hold off;
end

% Enfim, controi-se o ultimo grafico contendo as medias das performances
% calculadas anteriormente em funcao do numero de iteracoes.
figure 
plot (iter_interval, mean(mean_eqmv_min_avg_itr));
hold on;
plot (iter_interval, mean(erro_tot_avg_iter), 'r');
legend('Media dos erros de validacao', 'Media dos erros de teste');
xlabel('Numero de iteracoes');
plot (iter_interval, mean(mean_eqmv_min_avg_itr),'*');
plot (iter_interval, mean(erro_tot_avg_iter), '*r');
title('Media dos erros para valores de N = 5 .. 20');
hold off;
grid on;

end


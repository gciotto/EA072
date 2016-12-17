%% Funcao elm
%  Esta funcao treina maquinas de aprendizado extremo para diversos valores
%  do numero de neuronios na camada intermediaria. Utilizamos aqui o metodo
%  de crossfold validation e a otimizacao dos pesos sinapticos da ultima
%  camada eh realizada atraves do metodo de minimos quadrados regularizado.
%  AUTOR: Gustavo CIOTTO PINTON
function elm

close all;

E = 5 + 1; % Numero de entradas em cada neuronio (5 entradas e mais 1 constante).

% Numero de folds a ser utilizado
folds = 10;

% Obtem os dados a partir de denge_SP.mat
M = 5;
R = 1;
[X, Y] = gera_dados('dengue_SP.mat', 'resultado.mat', M, R);

% C eh o tamanho do conjunto e V, do conjunto de validacao
C = length (X(:,1));
V = round(C/folds);

% Variaveis que armazenarao o menor erro encontrado e os respectivos
% numeros de neuronios e parametro c.
m_erro = inf;
n_menor = 0;
c_menor = 0;

for n=[100 150 250 400 500 1000]
    
    % Inicia aleatoriamente os pesos da camada intermediaria. w_int eh uma
    % matriz em que a n-esima coluna representa os pesos sinapticos do
    % n-esimo neuronio.
    w_int = randn(E, n);
    
    erro_reg_k_folds = [];
    erro_reg_tr_k_folds = [];
    w_k_folds = [];
    
    for k = 1:folds
        
        % gera a ko. pasta para ser usada como validacao
        k_fold_set = (k - 1)*V + 1 : k*V;
        
        % pega o restante para treinamento. Setdiff realiza a diferenca de
        % conjuntos entre { 1 2 .... C } e os indices selecionados para a
        % validacao
        conjunto_treinamento = setdiff(1:C, k_fold_set);
        
        % Inicia matrizes H
        Htr = zeros (C - V, n );
        Hval = zeros (V, n );
        
        
        % Inicializa matriz H usada para o treinamento. Cada elemento ixk desta
        % matriz eh da forma f( wk * xi ) , em * eh o produto interno dos
        % pesos sinapticos do ko. neuronio com i-esima linha da entrada
        aux = 1;
        for i = conjunto_treinamento
      
            for k = 1:n
                
                Htr(aux, k) = tanh([ X(i,:) 1] * w_int(:, k));
 
            end
            
            aux = aux + 1;
        end
        
        % Adiciona um coluna de 1s referente a entrada constante do
        % neuronios da ultima camada
        Htr = [Htr ones(C-V, 1)];
        
        
        % Inicializa matriz H usada para o validacao. Mesmo raciocinio
        % utilizado no caso precedente
        aux = 1;
        for i = k_fold_set
      
            for k = 1:n
                
                Hval(aux, k) = tanh([ X(i,:) 1] * w_int(:, k));
                
            end
            aux = aux + 1;
        end
        
        % Adiciona um coluna de 1s referente a entrada constante do
        % neuronios da ultima camada
        Hval = [Hval ones(V, 1)];
        
        Ytr = Y (conjunto_treinamento,:);
        Yval = Y (k_fold_set,:);
        
        erro_reg = [];
        erro_reg_tr = [];
        w_reg = [];
        
        for c = -24:1:25
            
            % Calcula caso regularizado segundo enunciado (pag. 6)
            HHt_tr_inv = (Htr'*Htr + (2^c)*eye(n+1)) \ eye (n+1);
            w = HHt_tr_inv * Htr'*Ytr;
            
            % Armazena vetor w que acabou de ser calculado. w_reg
            % eh uma matriz n x 50 portanto em que cada coluna eh uma vetor b
            % calculado para um valor de c
            w_reg = [w_reg w];
            
            % Calcula e armazena erros quadraticos medios de validacao e
            % treinamento. erro_reg e erro_reg_tr sao vetores linhas (1x50), em cada
            % coluna eh o erro associado ao parametro c.
            erro_reg = [erro_reg  sqrt((norm(Hval*w - Yval)^2)/V)];
            erro_reg_tr = [erro_reg_tr sqrt((norm(Htr*w - Ytr)^2)/C)];
            
        end
        
        
        % Guarda a matriz w_reg calculada nas iteracoes passadas numa matriz
        % tridimensional, que contera 10 matrizes w_reg, calculadas para cada
        % uma das configuracoes das folds.
        w_k_folds = cat(3, w_k_folds, w_reg);
        
        
        % Guarda os vetores erro_reg e erro_reg_tr nas matrizes
        % erro_reg_k_folds e erro_reg_tr_k_folds, respectivamente, de forma que
        % cada linha dessas matrizes corresponda a uma das configuracoes da
        % folds. Cada coluna corresponde ao erro calculado para um c. Exemplo:
        % a linha 1 e coluna 4 dessas matrizes contem os erros correspondentes 
        % a situcao em que a primeira 1/k parte dos dados foi usada para validacao
        % e c eh igual a % 2^-20.
        erro_reg_k_folds = [erro_reg_k_folds; erro_reg];
        erro_reg_tr_k_folds = [erro_reg_tr_k_folds; erro_reg_tr];
    end
    
    % Faz o grafico das perfomances medias dos erros em funcao do parametro c.
    % mean (matriz) retorna um vetor linha com as medias de cada coluna da
    % matriz. Neste caso, obteremos a media dos erros para todos os c.
    fig = figure
    semilogx( 2.^(-24:25), mean(erro_reg_k_folds));
    hold on;
    semilogx( 2.^(-24:25), mean(erro_reg_k_folds),'*');
    hold off;
    title(['Evolucao do erro quadratico medio para N = ' num2str(n)]);
    ylabel('Media do erro quadratico medio das 10 execucoes');
    xlabel('Parametro c');
    grid on
    
    % Salva figura diretamente em arquivo
    print(fig,sprintf('elm_%d_neurons', n),'-dpng');
    
    [menor_erro, menor_index] = sort(mean(erro_reg_k_folds), 'ascend');

    w_k_folds(:,menor_index(1),:)
    disp(['Vetores b para c = ' int2str(menor_index(1) - 25) ' e erro medio de '...
                                                num2str(menor_erro(1))]);
    
    % Guarda menor erro encontrada ate aqui, juntamente com as informacoes
    % referentes a ele.
    if m_erro > menor_erro(1)
        
        m_erro = menor_erro(1);
        n_menor = n;
        c_menor = menor_index(1) - 25;
        
    end 
end

% Imprime menor erro encontrado e informacoes referentes a ele.
disp(sprintf('Menor erro quadratico medio obtido %d para N = %d e c = 2^%d = %d', ...
     m_erro, n_menor, c_menor, 2^c_menor));
end
%% Funcao resolve_k_folds
%  Esta funcao calcula os preditores lineares regularizados e nao
%  regularizado com auxilio do metodo crossfold validation para o caso
%  regularizado. Ela recebe como parametro a quantidade k de pastas a serem
%  utilizadas e o arquivo 'dados' onde os dados estao contidos. Retorna:
%  b_nreg :     o vetor b para o caso nao regularizado
%  b_k_folds:   uma matriz tridimensional contendo todos os vetores b 
%               regularizados para cada fold e cada c.
%  erro_nreg:   o erro quadratico medio para o caso nao regularizado.
%  erro_reg_k_folds: os erros quadraticos medios de validacao para todas as
%                    execucoes (para cada configuracao das folds e parametro c)
% erro_reg_tr_k_folds : os erros quadraticos medios de treinamento para todas as
%                    execucoes (para cada configuracao das folds e
%                    parametro c)
% AUTOR: Gustavo CIOTTO PINTON

function [b_nreg, erro_nreg, b_k_folds, erro_reg_k_folds, erro_reg_tr_k_folds] =... 
                        resolve_sistema_k_folds(dados,k)

close all;

k = 10;
M = 5; % Numero de entradas do modelo 
R = 1; 

% Gera matriz de entrada X e de saida Y
[X, Y] = gera_dados('dengue_SP.mat', 'resultado.mat', M, R);

% Calcula tamanhos dos conjunto de TReinamento, Validacao e TEste.
Tr = length(X(:,1));
V = round(Tr/k); % O conjunto de validacao correponde a 1/k do conj. de treinamento.
Te = 0;

% Controi-se matriz para o caso nao-regularizado. Utiliza-se neste caso
% todo o conjunto de dados.
A_nreg = [ X ones(Tr ,1) ];
ATA = (A_nreg'*A_nreg)\eye(M + 1);

% Resolve-se metodo dos minimos quadrados.
b_nreg = ATA*A_nreg'*Y;
% Calcula-se erro quadratico medio.
erro_nreg = sqrt((norm(A_nreg*b_nreg - Y))^2/Tr);

erro_reg_k_folds = [];
erro_reg_tr_k_folds = [];
b_k_folds = [];

for i = 1:k
    
    % gera a ko. pasta para ser usada como validacao
    k_fold_set = (i - 1)*V + 1 : i*V;
    
    % pega o restante para treinamento. Setdiff realiza a diferenca de
    % conjuntos entre { 1 2 .... Tr } e os indices selecionados para a
    % validacao
    conjunto_treinamento = setdiff(1:Tr, k_fold_set);
    
    % Controi as matrizes A e Y somente com dados de treinamento
    Atr = [ X(conjunto_treinamento, :) ones(Tr - V - Te ,1) ];
    ATA = (Atr'*Atr)\eye(M + 1); % Calcula inversa
    Ytr = Y (conjunto_treinamento,:);
    
    b_nreg = ATA*Atr'*Ytr;
    erro_nreg = sqrt((norm(Atr*b_nreg - Ytr))^2/(Tr - V - Te));
        
    Aval = [ X(k_fold_set, :) ...
        ones(V,1) ];
    Yval = Y(k_fold_set, :);
    
    % Inicializa variaveis que serao utilizadas para armazenar erros.
    erro_reg = [];
    erro_reg_tr = [];
    b_reg = [];
    n_b_reg = []; % Vetor que armazena as normas dos vetores b a serem calculados.
    
    for c_teste = -24:25
        
        % Calcula caso regularizado segundo enunciado (pag. 6)
        ATA_ = (Atr'*Atr + (2^c_teste)*eye(M + 1)) \ eye(M + 1);
        
        b = ATA_*Atr'*Ytr; % Vetor coluna com M + 1 linhas
        
        % Armazena vetor b que acabou de ser calculado e sua norma. b_reg
        % eh uma matriz M+1 x 50 portanto em que cada coluna eh uma vetor b
        % calculado para um valor de c
        b_reg = [b_reg b];
        n_b_reg = [n_b_reg norm(b)];
        
        % Calcula e armazena erros quadraticos medios de validacao e
        % treinamento. erro_reg e erro_reg_tr sao vetores linhas (1x50), em cada
        % coluna eh o erro associado ao parametro c.
        erro_reg = [erro_reg  sqrt((norm(Aval*b - Yval)^2)/V)];
        erro_reg_tr = [erro_reg_tr sqrt((norm(Atr*b - Ytr)^2)/(Tr-V))];
    end
   
    % Guarda a matriz b_reg calculada nas iteracoes passadas numa matriz
    % tridimensiona, que contera 10 matrizes b_reg, calculadas para cada
    % uma das configuracoes das folds.
    b_k_folds = cat(3, b_k_folds, b_reg);
    
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
figure
semilogx( 2.^(-24:25), mean(erro_reg_k_folds));
hold on;
semilogx( 2.^(-24:25), mean(erro_reg_k_folds),'*');
hold off;
title('Evolucao do erro quadratico medio');
ylabel('Media do erro quadratico medio das 10 execucoes');
xlabel('Parametro c');
grid on

% Seleciona o menor erro dentre as medias dos erros quadraticos medios e o
% respectivo index (que representa c)
[menor_erro, menor_index] = sort(mean(erro_reg_k_folds), 'ascend');

% Imprime os vetores e valores relacionados aos minimos
disp(['Vetores b para c = ' int2str(menor_index(1) - 25) ' e erro medio de ' num2str(menor_erro(1))]);
b_k_folds(:,menor_index(1),:)

end
function est = knnImputeRo( mat, k, ks, sMV, ms )
% KnnImpute 
% Ref: Candillier, Laurent, et al. "State-of-the-art recommender systems."
% Collaborative and Social Information Retrieval and Access Techniques for Improved User Modeling (2009).
%
% Dados de entrada:
% ------------------
% mat: matriz com os dados de treinamento
% k: valor de k do knn
% ks: matriz de 2 colunas com as posicoes (linha e coluna) dos dados faltantes a serem estimados
% sMV: valor que representa os dados faltantes na matriz mat
% ms: matriz de similaridade entre as linhas da matriz mat (opcional)
%
% Dados de saida:
% ----------------
% est: vetor com as estimativas
% -------------------------------------------------------------------------
    if nargin < 5
        % Calculando a matriz com o indice wPearson
        ms = similarityMatrix( mat, sMV );
    end
    
    % Pega os k vizinhos mais proximos de cada linha
    [~,viz] = sort(ms,2,'descend');
    viz = viz(:,1:k);
    
    W = mat ~= sMV; % matriz binaria com 1 onde nao tem valor faltante
    Z = mat .* W; % a matriz Z contem 0 nos locais de valores faltantes
    ras = sum(Z,2) ./ sum(W,2);
    est = NaN * ones(size(ks,1),1);
    for i = 1:size(ks,1)
        lin = ks(i,1); % linha com o valor a ser estimado
        col = ks(i,2); % coluna com o valor a ser estimado
        nn = viz(lin,:); % vetor com os vizinhos da linha lin
        sim = ms(lin,nn) .* W(nn,col)'; % desconsidero os vizinhos que nao tem nota na coluna col
        den = sum(sim);
        if den ~= 0
            ruis = Z(nn,col);
            rus = ras(nn);
            est(i) = ras(lin) + (sim * (ruis - rus)) / den; % calculando a estimativa
        end
    end
end

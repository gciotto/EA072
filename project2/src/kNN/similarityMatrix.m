function ms = similarityMatrix( mat, sMV )
% Calcula a similaridade entre todas as linhas da matriz usando correlacao
% de Pearson ponderada por Jaccard.
%
% Dados de entrada:
% ----------------
% mat: matriz de dados
% sMV: valor que representa os dados faltantes da matriz
%
%Dados de saida:
% --------------
% ms: matriz quadrada com a similaridade entre todas as linhas da matriz
% mat
% -------------------------------------------------------------------------
    n = size(mat,1);
    ms = -Inf * ones(n,n);
    for i = 1:(n - 1)
        pi = find(mat(i,:) ~= sMV); % Pega as colunas com notas da linha i
        for j = (i + 1):n
            pj = find(mat(j,:) ~= sMV); % Pega as colunas com notas da linha j
            piuj = union(pi,pj);
            piij = intersect(pi,pj);
            if ~isempty(piij) % Se existem notas em comum entre i e j
                RHO = corr(mat(i,piij)', mat(j,piij)'); % Pearson Correlation
                if isnan(RHO)
                   RHO = 1;
                end
                J = length(piij) / length(piuj); % Jaccard Index
                res = J * RHO;
                ms(i,j) = res;
                ms(j,i) = res;
            end
        end
    end
end

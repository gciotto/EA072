%% Funcao gera_dados
%  Esta funcao recebe uma serie temporal contida no arquivo 'dados'
%  e retorna uma matriz X com m colunas e uma matriz Y com r colunas. Ambas
%  as matrizes sao salvas no arquivo 'saida' igualmente.
%  Autor: Gustavo CIOTTO PINTON
function [X, Y] = gera_dados(dados, saida, m, r)

    load(dados);

    data = dengue_SP;

    % Transforma os dados de maneira que sua media seja 0 e desvio padrao
    % 1.
    data = (data - mean(data))/std(data);
    n_data = length (data);

    X = [];
    Y = [];
    Z = [];

    % Insere-se sequencialmente os dados no vetor auxiliar Z, conforme
    % descrito no enunciado.
    % Linha 1: x1 x2 ... xm   xm+1 ... xm+r
    % Linha 2: x2 x3 ... xm+1 xm+2 ... xm + 2 + r
    % Linha n: ...
    for j=(m+r):n_data,
        Z = [Z; data( (j-m-(r-1)):j, 1 )'];
    end

    % Seleciona X e Y de acordo com parametros
    X = Z(:, 1:m);
    Y = Z(:, (m+1):(m+r));

    save(saida, 'X', 'Y');

end
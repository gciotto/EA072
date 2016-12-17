function [X, Y] = gera_dados(dados, saida)

data = [];

load(dados, data);

m = 20;         % dimensão do espaço de entrada
r = 1;          % dimensão do espaço de saida

n_data = length (data);

X = [];
Y = [];

for j=(m+1):n_data,
        X = [X; data( (j-m):j, 1 )'];
end

save(saida, X, Y);

end
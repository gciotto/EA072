%% Script movieLens_impute_data
%  Script responsavel por predizer ratings que um dado usuario poderia
%  fazer baseado no seu grau de semelhanca com k vizinhos proximos.

clear all;

empty_element = -1;
load ms;
data = build_Data (empty_element);

k_neighbors = 3;
user_id = 898;

%% Verifica k_neighnors usuarios com maior similaridade
[A B] = sort(ms(user_id, :), 'descend');
col_max_user = B(1:k_neighbors);

%% Recupera indices dos elementos vazios
k_col = find (data(user_id, :) == empty_element);
k_indexes = [user_id*ones(length(k_col), 1) k_col'];

%% Aplica algoritmo k-NN
est = knnImputeRo( data, k_neighbors, k_indexes, empty_element, ms ); % estimativas
not_NaN_indexes = find(~isnan(est)); % Recupera somente recomendacoes bem sucedidas

%% Imprime recomendacoes e valores dos ratings feitos pelos vizinhos
display('=============================');
display(sprintf('Estimativas para usuario %d', user_id));
display('=============================');

for k = 1:length(not_NaN_indexes)
    
    item_id = k_indexes(not_NaN_indexes(k),2);
    display(sprintf('Recomendacao para filme %d : %.2f', item_id , est(not_NaN_indexes(k))));

end

for n=1:k_neighbors

    display('==================================================');
    display(sprintf('Ratings do usuario %d de maior similaridade (%.3g)', col_max_user(n), ...
        ms(user_id, col_max_user(n))));
    display('==================================================');

    for k = 1:length(not_NaN_indexes)

        item_id = k_indexes(not_NaN_indexes(k),2);

        if data(col_max_user(n), item_id) ~= empty_element
            display(sprintf('Rating para filme %d : %.2f', item_id, data(col_max_user(n), item_id)));
        end
    end
end
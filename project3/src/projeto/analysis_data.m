load('/home/gciotto/workspace/UNICAMP - EA072 - EFC3/Redes bayesianas/projeto/data/dados_BN_EFC3.mat');

n_atributos = length(data(1,:));
n_dados = length(data);

maxs = zeros (1, n_atributos);
mins = zeros (1, n_atributos);

disp(sprintf('Numero de atributos eh %d e de registros eh %d', ...
        n_atributos, n_dados));

for k = 1:n_atributos
    
    maxs(k) = max (data(:,k));
    mins(k) = min (data(:,k));

    disp(sprintf('Maximo do atributo %d eh %d e minimo eh %d', ...
        k , maxs(k), mins(k)));
    
    for n=1:maxs(k)
        disp (sprintf('Elemento %d aparece %d vezes.', n, ...
            length(find(data(:,k) == n) )));
    end
    
end
    


    
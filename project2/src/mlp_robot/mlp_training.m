% Programa vinculado ao EFC2
% EA072 - Inteligencia Artificial em Aplicacoes Industriais
% FEEC/Unicamp
% Prof. Fernando J. Von Zuben
% 07/10/2015

function weights = mlp_training (n_neurons, map, xStart, yStart, rDirection, speed)

weights = [];

% Define o tamanho da populacao [tam_pop], como um numero par
tam_pop = 100;

% Define as taxas de crossover e de mutacao
pc = 0.9;
pm = 0.8;

% Define o intervalo de excursao das variaveis
v_inf = 0.0;
v_sup = 5.0;

% Define o numero de geracoes
n_ger = 100;

% Estruturas para preservar o melhor individuo a cada geracao e seu fitness
v_melhor_fitness = [];
v_fitness_medio = [];
v_melhor_ind = [];

% Numero de entradas: d1, d2, d3 e termo constante
E = 3 + 1;

% Gera a populacao inicial. Cada individuo a uma linha da matriz [pop].
% Cada linha tera (E * n_neurons) + (n_neurons + 1) colunas, correspondentes aos pesos
% sinapticos e a camada final, respectivamente.
pop = randn(tam_pop, E * n_neurons + n_neurons + 1);

% Avalia a populacao inicial
for i=1:tam_pop,
    
    colision_i = robot_control_mlp (map, xStart, yStart, ...
                    rDirection, speed, pop (i, :), n_neurons, 0);
    
    fitness(i,1) = 1/(colision_i + 1);
end

% Loop para gerar a nova populacao ate atingir um numero maximo de geracoes
[melhor_fitness,melhor_ind] = max(fitness);
v_melhor_fitness = [v_melhor_fitness;melhor_fitness];
v_fitness_medio = [v_fitness_medio;mean(fitness)];
v_melhor_ind = [v_melhor_ind;pop(melhor_ind,:)];
v_delta = [];

for k = 1:n_ger,
    % Em lugar da roleta, adota-se torneio de 3, pois deve-se excluir os
    % individuos de fitness nulo e a implementacao fica melhor
    candidatos = [];
    for i=1:tam_pop,
        if fitness(i,1) > 0,
            candidatos = [candidatos;i];
        end
    end
    
    n_tam_pop = length(candidatos);
    n_pop = [];
%    [[1:tam_pop]' pop fitness]
    for i=1:tam_pop,
        torneio = randi(n_tam_pop,[3 1]);
        c_fitness(1,1) = fitness(candidatos(torneio(1,1),1),1);
        c_fitness(2,1) = fitness(candidatos(torneio(2,1),1),1);
        c_fitness(3,1) = fitness(candidatos(torneio(3,1),1),1);
        [v_max,ind_max] = max(c_fitness);
        n_pop = [n_pop;pop(candidatos(torneio(ind_max,1),1),:)];
    end
    % Aplicacao de crossover onde for escolhido
    for j=1:(tam_pop/2),
        if rand(1,1) <= pc,
            % 50% de chance de ocorrer o crossover aritmetico
            if rand(1,1) <= 0.5,
                a = rand(1,1);
                n_pop1 = a*n_pop(2*(j-1)+1,:)+(1-a)*n_pop(2*(j-1)+2,:);
                n_pop2 = (1-a)*n_pop(2*(j-1)+1,:)+a*n_pop(2*(j-1)+2,:);
                n_pop(2*(j-1)+1,:) = n_pop1;
                n_pop(2*(j-1)+2,:) = n_pop2;
            else
                % 50% de chance de ocorrer o crossover uniforme
                for z=1:(E * n_neurons + n_neurons + 1),
                    if rand(1,1) <= 0.5;
                        n_pop1(1,z) = n_pop(2*(j-1)+1,z);
                        n_pop2(1,z) = n_pop(2*(j-1)+2,z);
                    else
                        n_pop1(1,z) = n_pop(2*(j-1)+2,z);
                        n_pop2(1,z) = n_pop(2*(j-1)+1,z);
                    end
                end
                n_pop(2*(j-1)+1,:) = n_pop1;
                n_pop(2*(j-1)+2,:) = n_pop2;
            end
        end
    end
    % Aplicacao de mutacao nao-uniforme onde for escolhido
    n_mut = round(tam_pop*3*pm);
    bits_mutados = randi([1 tam_pop*3],n_mut,1);
    for i=1:n_mut,
        if rem(bits_mutados(i),3) == 0,
            linha = fix(bits_mutados(i)/3);
            coluna = 3;
        else
            linha = fix(bits_mutados(i)/3)+1;
            coluna = rem(bits_mutados(i),3);
        end
        if rand(1,1) <= 0.5,
            delta = mut_nunif(k,v_sup-n_pop(linha,coluna),n_ger);
            v_delta = [v_delta;delta];
            n_pop(linha,coluna) = n_pop(linha,coluna) + delta;
        else
            delta = mut_nunif(k,n_pop(linha,coluna)-v_inf,n_ger);
            v_delta = [v_delta;delta];
            n_pop(linha,coluna) = n_pop(linha,coluna) - delta;
        end
    end
    % Avaliacao da nova populacao
    for i=1:tam_pop,
        colision_i = robot_control_mlp (map, xStart, yStart, ...
                    rDirection, speed, pop (i, :), n_neurons, 0);
    
        fitness(i,1) = 1/(colision_i + 1);
        
        if fitness(i,1) == 1
            weights = pop(i,:);
        end
    end
    % Preservacao do melhor individuo da geracao anterior, se melhor que o
    % melhor da nova geracao
    melhor_fitness1 = melhor_fitness;
    melhor_ind1 = melhor_ind;
    [melhor_fitness,melhor_ind] = max(fitness);
    if melhor_fitness1 > melhor_fitness,
        [pior_fitness,pior_ind] = min(fitness);
        n_pop(pior_ind,:) = pop(melhor_ind1,:);
        
        fitness(pior_ind,1) = melhor_fitness1;
        melhor_fitness = melhor_fitness1;
        melhor_ind = pior_ind;
    end
    pop = n_pop;
    v_melhor_fitness = [v_melhor_fitness;melhor_fitness];
    v_fitness_medio = [v_fitness_medio;mean(fitness)];
    v_melhor_ind = [v_melhor_ind;pop(melhor_ind,:)];
    
    
%     kp = pop(melhor_ind,1);
%     kd = pop(melhor_ind,2);
%     ki = pop(melhor_ind,3);
%     figure(1);step(planta(kp,kd,ki));drawnow;
%     S = stepinfo(planta(kp,kd,ki));
%     [Gm,Pm,Wcg,Wcp] = margin(planta(kp,kd,ki));
%     disp(sprintf('Geracao %d: T_sub = %g | T_acom = %g | Sobrs = %g | Margfase = %g',k,S.RiseTime,S.SettlingTime,S.Overshoot,Pm));
%     disp(sprintf('Geracao %d: Os melhores valores encontrados foram: k_p = %g; k_d = %g; k_i = %g',k,kp,kd,ki));
     disp(sprintf('Geracao %d: Fitness deste melhor individuo = %g',k,melhor_fitness));
     
     
end
figure;plot(v_melhor_fitness,'k');hold on;plot(v_fitness_medio,'r');hold off;
title('Melhor fitness (preto) e fitness medio (vermelho) da populacao ao longo das geracoes');
% figure(3);plot(v_melhor_ind(:,1),'k');hold on;plot(v_melhor_ind(:,2),'r');plot(v_melhor_ind(:,3),'b');hold off;
% title('Evolucao dos ganhos do controlador PID: k_p (preto) | k_d (vermelho) | k_i (azul)');
% xlabel('Numero de geracoes');
figure;plot(v_delta);
title('Intensidade da mutacao nao-uniforme ao longo das geracoes');

end
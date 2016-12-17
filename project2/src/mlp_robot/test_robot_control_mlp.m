clear all;
close all;

n_neurons = 10;

% Constroi mapa 1.
labyrinth_matrix = zeros(20,20);
labyrinth_matrix (1:2, :) = '#';
labyrinth_matrix (20, :) = '#';
labyrinth_matrix (:, 1) = '#';
labyrinth_matrix (:, 19:20) = '#';
labyrinth_matrix (7:20, 5:15) = '#';
labyrinth_matrix (2:4, 2:4) = fliplr(triu(ones(3)))*'#';
labyrinth_matrix (2:5, 16:19) = triu(ones(4))*'#';
labyrinth_matrix (18:19, 16:18) = 'F';

weights = mlp_training(n_neurons, labyrinth_matrix, 3,3, pi/2, 1);

robot_control_mlp (labyrinth_matrix, 3,3, pi/2, 1, weights, n_neurons ,1);

% Constroi mapa 2.
labyrinth_matrix = zeros(20,20);
labyrinth_matrix (1:2, :) = '#';
labyrinth_matrix (20, :) = '#';
labyrinth_matrix (:, 1) = '#';
labyrinth_matrix (:, 19:20) = '#';
labyrinth_matrix (7:20, 5:15) = '#';
labyrinth_matrix (16:20, 5:20) = '#';
labyrinth_matrix (2:4, 2:4) = fliplr(triu(ones(3)))*'#';
labyrinth_matrix (2:5, 16:19) = triu(ones(4))*'#';
labyrinth_matrix (12:15, 16:19) = flipud(triu(ones(4)))*'#';
labyrinth_matrix (10:15, 6:15) = 0;
labyrinth_matrix (10:15, 6) = 'F';

robot_control_mlp (labyrinth_matrix, 3,3, pi/2, 1, weights, n_neurons, 1);
%%  FUNCAO robot_control
%   Funcao responsavel por controlar o robo segundo as regras formalizadas
%   na secao '3.0 Definicao dos Consequentes'.
%   Parametros: matrix eh o labirinto onde o robo sera colocado.
%               xStart e yStart sao as coordenadas iniciais do robo.
%               rDirection eh a direcao inicial do robo.
%               speed eh a velocidade do robo.
%   Autor: Gustavo CIOTTO PINTON
function colisions = robot_control_mlp(matrix, xStart, yStart, rDirection, speed, mlp_weights, n_neurons, show_image)

labyrinth_matrix = matrix;
teste = matrix;
robot_direction = rDirection;
x_robot = xStart;
y_robot = yStart;
colisions = 0;
m_length = length (labyrinth_matrix);

steps = 500;
s_count = 0;

% Movimenta o robo ate achar um ponto de destino, isto e, 'F'
while   (round(x_robot) <= length(labyrinth_matrix (1,:))) ...
        && (round(x_robot) >= 1) ...
        && (round(m_length + 1 - y_robot) >= 1) ...
        && (round(m_length + 1 - y_robot) <= m_length) ...
        && (labyrinth_matrix (round(m_length + 1 - y_robot), round(x_robot)) ~= 'F')  ...
        && (s_count <= steps);
    
    
    s_count = s_count + 1;
    
    
    % Procura o o obstaculo mais proximo na direcao d1.
    % Itera ate encontrar tal obstaculo.
    x_d1 = x_robot + cos(robot_direction + pi/4 );
    y_d1 = y_robot + sin(robot_direction + pi/4 );
    while (round(x_d1) >= 1) && (round(x_d1) <= length(labyrinth_matrix (1,:)) ) ...
            && (round(m_length + 1 - y_d1) >= 1) ...
            && (round(m_length + 1 - y_d1) <= m_length) ...
            && (labyrinth_matrix (round(m_length + 1 - y_d1), round(x_d1)) ~= '#')
        
        x_d1 = x_d1 + cos(robot_direction + pi/4);
        y_d1 = y_d1 + sin(robot_direction + pi/4);
        
    end
    
    % Calcula distancia ao obstaculo mais proximo encontrado.
    distance_d1 = sqrt((x_d1 - x_robot)^2 + (y_d1 - y_robot)^2);
    
    % Procura o o obstaculo mais proximo na direcao d2.
    % Itera ate encontrar tal obstaculo.
    x_d2 = x_robot + cos(robot_direction);
    y_d2 = y_robot + sin(robot_direction);
    while (round(x_d2) >= 1) && (round(x_d2) <= length(labyrinth_matrix (1,:)) ) ...
            && (round(m_length + 1 - y_d2) >= 1) ...
            && (round(m_length + 1 - y_d2) <= m_length) ...
            && (labyrinth_matrix (round(m_length + 1 - y_d2), round(x_d2)) ~= '#')
        
        x_d2 = x_d2 + cos(robot_direction);
        y_d2 = y_d2 + sin(robot_direction);
        
    end
    
    % Calcula distancia ao obstaculo mais proximo encontrado.
    distance_d2 = sqrt((x_d2 - x_robot)^2 + (y_d2 - y_robot)^2);
    
    % Procura o o obstaculo mais proximo na direcao d3.
    % Itera ate encontrar tal obstaculo.
    x_d3 = x_robot + cos(robot_direction - pi/4);
    y_d3 = y_robot + sin(robot_direction - pi/4);
    while (round(x_d3) >= 1) && (round(x_d3) <= length(labyrinth_matrix (1,:)) ) ...
            && (round(m_length + 1 - y_d3) >= 1) ...
            && (round(m_length + 1 - y_d3) <= m_length) ...
            && (labyrinth_matrix (round(m_length + 1 - y_d3), round(x_d3)) ~= '#')
        
        x_d3 = x_d3 + cos(robot_direction - pi/4);
        y_d3 = y_d3 + sin(robot_direction - pi/4);
        
    end
    
    % Calcula distancia ao obstaculo mais proximo encontrado.
    distance_d3 = sqrt((x_d3 - x_robot)^2 + (y_d3 - y_robot)^2);
    
    % Constroi vetor das entradas de cada neuronio
    mlp_input = [distance_d1 distance_d2 distance_d3 1];
    
    % middle_layer_output contera as saidas de cada neuronio da camanda
    % intermediaria
    middle_layer_output = zeros (1, n_neurons);
    
    % Calcula a saida de cada neuronio. mlp_weights contem todos os pesos
    % sinapticos da rede 
    for n = 1 : n_neurons
        
        middle_layer_output (1, n) = ...
            tanh(mlp_input * mlp_weights (1 + (n - 1)* 4 : 4 + (n - 1)* 4)');
        
    end
    
    % a entrada da ultima camada eh a saida da camada intermediaria e uma
    % termo constante.
    last_layer_input = [middle_layer_output 1];
    
    % Calcula o desvio na direcao do robo.
    d_angle = ...
        last_layer_input * mlp_weights (1 + 4 * n_neurons : 1 + 4 * n_neurons + n_neurons)';
    
    robot_direction = robot_direction + d_angle;
    
    teste (round(m_length + 1 - y_robot), round(x_robot)) = 'r';
    
    % Calcula nova posicao.
    x_robot = x_robot + speed*cos(robot_direction);
    y_robot = y_robot + speed*sin(robot_direction);
    
    % Verifica se a nova posicao esta dentro do mapa.
    if (round(x_robot) > length(labyrinth_matrix (1,:))) ...
            || (round(x_robot) < 1) ...
            || (round(m_length + 1 - y_robot) < 1) ...
            || (round(m_length + 1 - y_robot) > m_length)
        
        % Penalisa movimentos que levam o robo fora do mapa.
        colisions = colisions + 1000;
        
    % Detecta colisao.
    elseif (labyrinth_matrix (round(m_length + 1 - y_robot), round(x_robot)) == '#')
        
        % Aumenta contador de colisoes.
        colisions = colisions + 1;
    end
    
end

if (s_count >= steps)
    colisions = colisions + 100;
end

if (show_image == 1)
figure 
    imagesc(teste);
    colormap(flipud(gray));
    grid on;
    grid minor;
end

end
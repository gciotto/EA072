%%  FUNCAO robot_control
%   Funcao responsavel por controlar o robo segundo as regras formalizadas
%   na secao '3.0 Definicao dos Consequentes'.
%   Parametros: matrix eh o labirinto onde o robo sera colocado.
%               xStart e yStart sao as coordenadas iniciais do robo.
%               rDirection eh a direcao inicial do robo.
%               speed eh a velocidade do robo.
%   Autor: Gustavo CIOTTO PINTON
function robot_control(matrix, xStart, yStart, rDirection, speed)

labyrinth_matrix = matrix;
robot_direction = rDirection;
x_robot = xStart;
y_robot = yStart;

m_length = length (labyrinth_matrix);

steps = 0;

% Movimenta o robo ate achar um ponto de destino, isto e, 'F' 
while (labyrinth_matrix (round(m_length + 1 - y_robot), round(x_robot)) ~= 'F')
    
    labyrinth_matrix (round(m_length + 1 - y_robot), round(x_robot)) = 'r';
    
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
    
    % Verifica valores das funcoes de pertinencia para cada sensor.
    d1_rules = get_D1_D3_Rule(distance_d1);
    d2_rules = get_D2_Rule(distance_d2);
    d3_rules = get_D1_D3_Rule(distance_d3);
    
    % Verifica quais regras foram ativadas.
    active_rules = get_Angle_Rule(d1_rules, d2_rules, d3_rules);
    
    % Processo de defuzzyficacao. A partir das regras ativas, calcula-se o
    % desvio a ser feito na direcao do robo.
    d_angle = get_Angle (active_rules);
    
    robot_direction = robot_direction + d_angle;
    
    % Calcula nova posicao.
    x_robot = x_robot + speed*cos(robot_direction);
    y_robot = y_robot + speed*sin(robot_direction);
end

% Imprime matriz do labirinto.
figure 
imagesc(labyrinth_matrix);
colormap(flipud(gray));
grid on;
grid minor;
end
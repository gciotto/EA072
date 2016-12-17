%%  FUNCAO get_D1_D3_Rule
%   Calcula pertinencia para todos os possiveis estados de D1 e D3.
%   Parametros: sensor_capture eh a distancia medida pelo sensor.
%   Retorno   : Vetor com os valores das pertinencias atribuidas a cada
%   regra.
%   Autor: Gustavo CIOTTO PINTON
function S = get_D1_D3_Rule( sensor_capture )

% Calcula pertinencia para P
relevance_P = trap_pertinencia (sensor_capture, 0, 0, 1, 2, (sensor_capture < 0));

% Calcula pertinencia para M
relevance_M = trap_pertinencia (sensor_capture, 1, 2, 3, 4, 0);

% Calcula pertinencia para G
relevance_G = trap_pertinencia (sensor_capture, 3, 4, 5, 5, (sensor_capture > 5));

S = [relevance_P relevance_M relevance_G];

end


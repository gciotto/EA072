%%  FUNCAO get_D2_Rule
%   Calcula pertinencia para todos os possiveis estados de D2.
%   Parametros: sensor_capture eh a distancia medida pelo sensor.
%   Retorno   : Vetor com os valores das pertinencias atribuidas a cada
%   regra.
%   Autor: Gustavo CIOTTO PINTON
function S = get_D2_Rule( sensor_capture )

% Testar para MP
relevance_MP = trap_pertinencia (sensor_capture, 0, 0, 1, 2, (sensor_capture < 0));

% Testar para PP
relevance_PP = trap_pertinencia (sensor_capture, 1, 2, 3, 4, 0);

% Testar para PG
relevance_PG = trap_pertinencia (sensor_capture, 3, 4, 5, 6, 0);

% Testar para MG
relevance_MG = trap_pertinencia (sensor_capture, 5, 6, 7, 7, (sensor_capture > 7));

S = [relevance_MP relevance_PP relevance_PG relevance_MG];

end



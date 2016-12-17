%%  FUNCAO get_Angle
%   Funcao responsavel por calcular o desvio no angulo do robo com base na
%   regras que foram ativadas pelos sensores.
%   Parametros: active_rules possui as regras que foram ativadas e suas
%   respectivas pertinencias.
%   Retorno:    o desvio que devera ser feito na direcao do robo
%   Autor: Gustavo CIOTTO PINTON
function angle = get_Angle (active_rules)

% Discretizacao do intervalo dos possiveis angulos.
available_angles = -20:0.5:20;

% c_values eh uma matriz, em que cada componente representa o resultado
% representa o minimo entre a funcao de pertinencia calculada em um ponto e
% o valor da pertinencia de uma regra ativa.  Como ha 5 possiveis funcoes
% de pertinencia (MN, PN, Z, PP e MP), a matriz possui 5 linhas.
c_values = zeros (5, length(available_angles));

% parameters eh uma matriz que contem os parametros que descrevem os
% trapezios relativos a cada uma das possiveis funcoes de pertinencia de
% do desvio angular.
parameters = [ -20 -20 -15 -10 0 ;
               -15 -10  -5   0 0 ;
               -5    0   0   5 0 ;
                0    5  10  15 0 ;
                10  15  20  20 0 ];

% Itera todos os possiveis angulos.            
for k = 1: length(available_angles)
    
    % Para cada angulo e cada funcao de pertinencia, calcula-se o
    % respectivo valor de pertinencia.
    for n = 1:5
    
        % O valor de pertinencia eh o minimo entre o resultado da n-esima funcao
        % de pertinencia e a pertinencia da regra que corresponde a aquela
        % mesma funcao.
        c_values(n, k) = min (active_rules(n), trap_pertinencia(available_angles(k), ...
            parameters(n ,1),  parameters(n ,2), parameters(n ,3), parameters(n ,4), ...
            parameters(n ,5)));
    end
    
end

% Recupera os maximos dos valores de pertinencia entre todas as funcoes de
% pertinencia segundo o metodo do MAXIMO dos MINIMOS.
max_values = max(c_values);

% Calcula o centro de massa.
angle = sum(available_angles.*max_values)/sum(max_values);

% Converte o resultado em radianos.
angle = angle*pi/180;

end
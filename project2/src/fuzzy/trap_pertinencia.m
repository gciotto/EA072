%%  FUNCAO trap_pertinencia 
%   Funcao responsavel por calcular a pertinencia em uma dada coordenada x.
%   Parametros: x eh a coordenada para qual calcula-se a pertinencia.
%               a, b, c e d sao os parametros referentes ao trapezio.
%               out_of_range representa o resultado que deve ser atribuido
%               caso x esteja fora do intervalo [a, d].
%   Autor: Gustavo CIOTTO PINTON
function pert = trap_pertinencia( x, a, b, c, d , out_of_range)

if (x < a) || (x > d)
    pert = out_of_range; 
    
elseif (x < b)  
    if (a ~= b)
        pert = (x - a)/(b -a);
    else
        pert = 1;
    end 
    
elseif (x < c)
    pert = 1; 
    
else 
    if (c ~= d)
        pert = (d - x)/(d - c);
    else
        pert = 1;
    end   
end
end


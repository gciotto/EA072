% C�lculo do coeficiente de autocorrela��o amostral de uma s�rie temporal
% Fornecer como entrada um �nico vetor contendo toda a s�rie temporal
% Uma fun��o similar do Matlab � corrcoef(), mas ela j� precisa receber os
% vetores cujas correla��es devem ser calculadas.
% 28/04/2015 - FEEC/Unicamp
%
function [coef] = calc_cor(x)
Ncor = input('N�mero de autocorrela��es (Sugest�o: 20) = ');
Ncor = Ncor+1;
N = length(x);
if Ncor > (N/2),
    error('O n�mero de autocorrela��es � muito alto para o tamanho da s�rie');
end
figure(1);
plot(x);
title('S�rie temporal fornecida como entrada');
for i=1:Ncor,
    X(:,i) = x(Ncor-i+1:(N+1-i),1);
end
for i=1:Ncor,
    Xmed(1,i) = sum(X(:,i))/(length(X(:,i)));
end
for i=1:Ncor,
    desv(1,i) = sqrt((sum((X(:,i)-Xmed(i)).^2))/(length(X(:,i))-1));
end
for i=1:Ncor,
    for j=1:Ncor,
        cov(i,j) = (sum((X(:,i)-Xmed(i)).*(X(:,j)-Xmed(j))))/(length(X(:,i))-1);
    end
end
for i=1:Ncor,
    coef(i,1)=cov(1,i)/(desv(i)*desv(1));
end
ind_max = length(coef);
v_x = 0:(ind_max-1);
figure(2);
plot(v_x,coef);hold on;plot(v_x,coef, '*');hold off;
title('Coeficientes de autocorrelacao amostral');
grid;

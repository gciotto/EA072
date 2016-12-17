function [b_nreg, erro_nreg, b_reg, erro_reg, erro_reg_tr] = resolve_sistema(dados)

close all;

M = 5;
R = 1;

[X, Y] = gera_dados(dados, 'resultado.mat', M, R);

Tr = length(X(:,1)); 

V = round(0.2 * Tr);
Te = 0;

conjunto_validacao      = randperm(Tr);
conjunto_validacao      = conjunto_validacao(1:V);

conjunto_treinamento    = setdiff(1:Tr, conjunto_validacao);

conjunto_teste          = randperm( length(conjunto_treinamento) );
conjunto_teste          = conjunto_treinamento( conjunto_teste ( 1: Te) );

conjunto_treinamento    = setdiff(conjunto_treinamento, conjunto_teste);

Atr = [ X(conjunto_treinamento, :) ones(Tr - V - Te ,1) ];
ATA = (Atr'*Atr)\eye(M + 1);
Ytr = Y (conjunto_treinamento,:);

b_nreg = ATA*Atr'*Ytr;
erro_nreg = sqrt((norm(Atr*b_nreg - Ytr))^2/(Tr - V - Te));


Aval = [ X(conjunto_validacao, :) ...
                    ones(V,1) ];
Yval = Y(conjunto_validacao, :);

erro_reg = [];
erro_reg_tr = [];
b_reg = [];
n_b_reg = [];

for c_teste = -24:25

    ATA_ = (Atr'*Atr + (2^c_teste)*eye(M + 1)) \ eye(M + 1);

    b = ATA_*Atr'*Ytr;
    
    b_reg = [b_reg b];
    n_b_reg = [n_b_reg norm(b)];
        
    erro_reg = [erro_reg sqrt((norm(Aval*b - Yval)^2)/V)];
    erro_reg_tr = [erro_reg_tr sqrt((norm(Atr*b - Ytr)^2)/V)];
end

figure
semilogx( 2.^(-24:25), erro_reg);
title('Evolucao do erro quadratico medio');
ylabel('Erro quadratico medio');
xlabel('Parametro c');
grid on


% figure
% title('Evolucao do modulo de b');
% ylabel('Modulo de b');
% xlabel('Parametro c');
% semilogx( 2.^(-24:25), n_b_reg);
% grid on

end
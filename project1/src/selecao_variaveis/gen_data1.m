% Gera dados para a série SUNSPOT
% 28/08/2015 - FEEC/Unicamp
%
function [] = gen_data1()
atrasos = 20;
aleat = 5;
load sunspot;
v_max = max(d);
d = d./v_max;
nl = length(d);
dados = [];
for j=(atrasos+1):nl,
    dados = [dados;d((j-atrasos):j,1)'];
end
X = dados(:,1:atrasos);
nl = length(X(:,1));
X = [X rand(nl,aleat)];
S = dados(:,(atrasos+1));
save dados1 X S;
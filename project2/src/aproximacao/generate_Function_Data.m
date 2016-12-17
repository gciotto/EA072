close all;
clear all;

variancia = 0.64;

x =  -2*pi:0.01:2*pi;

y = exp (sin(x) + cos(x)) + abs(x);
y_noise = y + sqrt(variancia)*randn(1,length(x));

figure
plot (x, y);
title('Comportamento da função f(x) = e^{sinx + cosx} + |x|')

figure 
plot (x, y);
hold on
title('Comportamento da função f(x) = e^{sinx + cosx} + |x|')
plot (x, y_noise, '.');
hold off

y_eureqa = 1.61174601463431 + 1.83009402215019*sin(0.792660864528948 + x) + 0.557643717610482*sin(1.99324796219123*x) + abs(x);

figure
plot (x, y);
hold on
plot (x, y_eureqa,'--');
title('Diferença do mapeamento com e sem ruídos')
legend('Sem ruídos', 'Com ruídos, gerado pelo Eureqa');
hold off


x1 = [-3:0.01:1];
x2 = [1:0.01:5];
x3 = [-4:0.02:4];

y2 = x1.*log10 (x2/3)/log10(pi) + sqrt(2)*x3;
y2_noise = y2 + sqrt(variancia)*randn(1,length(x1));
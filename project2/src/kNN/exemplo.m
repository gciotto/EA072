close all; clear all;

% Dados do problema:
sMV = 999 % valor que representa os dados faltantes
mat = [4 3 4 sMV; 1 4 sMV sMV; 5 2 2 2; 5 sMV 1 5; 4 1 3 2] % matriz de dados
ks = [1 4; 2 3] % posicao dos valores a serem estimados
k = 2 % numero de vizinhos do k-nn

% Estimando os valores faltantes:
ms = similarityMatrix( mat, sMV ) % matriz de similaridade
est = knnImputeRo( mat, k, ks, sMV, ms ) % estimativas
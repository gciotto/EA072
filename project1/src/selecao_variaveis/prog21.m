% 02/05/2015
% prog21.m
% Sele��o de entradas via wrapper de poda
% Emprego de modelos de regress�o
% Emprego de k-folds cross-validation
% Considera 11 atributos de entrada
% As colunas 12 a 16 s�o entradas aleat�rias
%
seqVARIAVEIS_MODELO = [];
seqEVOLUCAOERRO = [];
seqERROMODELO = [];
seqERROALEATORIA = [];

save teste2_back seqVARIAVEIS_MODELO seqEVOLUCAOERRO

for turn_CIOTTO = 1:5
    
    clear all;format long;format compact;
    load teste2_back seqVARIAVEIS_MODELO seqEVOLUCAOERRO
    k = 10;
    filename = 'train';
    atrasos = 11;
    aleat = 5;
    load wineq;
    nl = length(X(:,1));
    X = [X rand(nl,aleat)];
    save train X S;
    gen_k_folds(filename,k)
    entradas = [1:(atrasos+aleat)];
    seq_saida = [];
    nc = atrasos+aleat;
    seq_EQpl = [];
    while nc > 1,
        mEQpl = [];
        for i=1:nc,
            EQpl = zeros(k,1);
            for fold = 1:k,
                Xacc = [];Sacc = [];
                for j=1:k,
                    if j~=fold,
                        load(strcat(filename,sprintf('%d',j)));
                        Xacc = [Xacc;X];Sacc = [Sacc;S];
                    else
                        load(strcat(filename,sprintf('%d',j)));
                        Xv = X;
                        Sv = S;
                    end
                end
                X = Xacc;S = Sacc;
                entradas_aux = [];
                for r=1:length(entradas),
                    if r ~= i,
                        entradas_aux = [entradas_aux entradas(r)];
                    end
                end
                X_aux = [];Xv_aux = [];
                for r=1:length(entradas_aux),
                    X_aux = [X_aux X(:,entradas_aux(r))];
                    Xv_aux = [Xv_aux Xv(:,entradas_aux(r))];
                end
                nl = length(X_aux(:,1));
                nlv = length(Xv_aux(:,1));
                X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
                b = inv(X'*X)*X'*S;
                Spl = Xv*b;
                EQpl(fold,1) = (Sv-Spl)'*(Sv-Spl);
            end
            mEQpl(i,1) = mean(EQpl);
        end
        [minEQ,i_perm] = min(mEQpl);
        seq_saida = [seq_saida;entradas(i_perm)];
        seq_EQpl = [seq_EQpl;minEQ];
        entradas_aux = [];
        for r=1:length(entradas),
            if r ~= i_perm,
                entradas_aux = [entradas_aux entradas(r)];
            end
        end
        entradas = entradas_aux;
        nc = nc-1;
    end
    seq_saida = [seq_saida;entradas]; % Inclui a �ltima entrada que n�o saiu
    disp('Sequ�ncia de entradas que deixam de compor o modelo')
    disp(seq_saida');
    
    seqVARIAVEIS_MODELO = [seqVARIAVEIS_MODELO; seq_saida'];
    
    % � preciso calcular o desempenho com todas as entradas tamb�m
    EQpl = zeros(k,1);
    for fold = 1:k,
        Xacc = [];Sacc = [];
        for j=1:k,
            if j~=fold,
                load(strcat(filename,sprintf('%d',j)));
                Xacc = [Xacc;X];Sacc = [Sacc;S];
            else
                load(strcat(filename,sprintf('%d',j)));
                Xv = X;
                Sv = S;
            end
        end
        X = Xacc;S = Sacc;
        nl = length(X(:,1));
        nlv = length(Xv(:,1));
        X = [X ones(nl,1)];Xv = [Xv ones(nlv,1)];
        b = inv(X'*X)*X'*S;
        Spl = Xv*b;
        EQpl(fold,1) = (Sv-Spl)'*(Sv-Spl);
    end
    seq_EQpl = [mean(EQpl);seq_EQpl];
    disp('Evolu��o do erro ao longo da poda do modelo');
    disp(seq_EQpl');
    
    seqEVOLUCAOERRO = [seqEVOLUCAOERRO; seq_EQpl'];
    
    figure;
    x = [1:(atrasos+aleat)];
    x = (atrasos+aleat+1)-x;
    plot(x,seq_EQpl);grid;
    title('Evolu��o do erro ao longo da poda do modelo');
    xlabel('N�mero de entradas do modelo');
    ylabel('Erro quadr�tico');
    
    save teste2_back seqVARIAVEIS_MODELO seqEVOLUCAOERRO
    
end

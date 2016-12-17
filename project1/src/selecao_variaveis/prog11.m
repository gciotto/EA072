% 02/05/2015
% prog11.m
% Sele��o de entradas via wrapper construtivo
% Emprego de modelos de regress�o
% Emprego de k-folds cross-validation
% Considera 11 atributos de entrada
% As colunas 12 a 16 s�o entradas aleat�rias
%
seqVARIAVEIS_MODELO = [];
seqEVOLUCAOERRO = [];
seqERROMODELO = [];
seqERROALEATORIA = [];

save teste2 seqVARIAVEIS_MODELO seqEVOLUCAOERRO

for turn_CIOTTO = 1:5
    
    clear all;format long;format compact;
    load teste2 seqVARIAVEIS_MODELO seqEVOLUCAOERRO
    
    k = 10;
    filename = 'train';
    atrasos = 11;
    aleat = 5;
    load wineq;
    nl = length(X(:,1));
    X = [X rand(nl,aleat)];
    save train X S;
    gen_k_folds(filename,k)
    seq_entrada = [];
    entradas = zeros(atrasos+aleat,1);
    nc = atrasos+aleat;
    seq_EQpl = [];
    while nc > 0,
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
                X_aux = [];Xv_aux = [];
                for r=1:length(seq_entrada),
                    X_aux = [X_aux X(:,seq_entrada(r))];
                    Xv_aux = [Xv_aux Xv(:,seq_entrada(r))];
                end
                i_efetivo = 0;
                i_real = 0;
                while i_efetivo < i,
                    i_real = i_real+1;
                    if entradas(i_real) == 0,
                        i_efetivo = i_efetivo+1;
                    end
                end
                X_aux = [X_aux X(:,i_real)];
                Xv_aux = [Xv_aux Xv(:,i_real)];
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
        i_efetivo = 0;
        i_real = 0;
        i_fato = i_perm;
        while i_efetivo < i_perm,
            i_real = i_real+1;
            if entradas(i_real) == 1,
                i_fato = i_fato+1;
            else
                i_efetivo = i_efetivo+1;
            end
        end
        entradas(i_fato) = 1;
        seq_entrada = [seq_entrada;i_fato];
        seq_EQpl = [seq_EQpl;minEQ];
        nc = sum(1-entradas);
    end
    disp('Sequ�ncia de entradas que passam a compor o modelo')
    disp(seq_entrada');
    
    seqVARIAVEIS_MODELO = [seqVARIAVEIS_MODELO; seq_entrada'];
    
    
    disp('Evolu��o do erro ao longo da constru��o do modelo');
    disp(seq_EQpl');
    
    seqEVOLUCAOERRO = [seqEVOLUCAOERRO; seq_EQpl'];
    
    figure;
    plot(seq_EQpl);grid;
    title('Evolu��o do erro ao longo da constru��o do modelo');
    xlabel('N�mero de entradas do modelo');
    ylabel('Erro quadr�tico');
        
    save teste2 seqVARIAVEIS_MODELO seqEVOLUCAOERRO
    
end
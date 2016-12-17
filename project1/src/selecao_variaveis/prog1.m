% 02/05/2015
% prog1.m
% Seleção de entradas via wrapper construtivo
% Emprego de modelos de predição lineares
% Emprego de k-folds cross-validation
% Considera os últimos 20 atrasos como candidatos
% As colunas 21 a 25 são entradas aleatórias
%

seqVARIAVEIS_MODELO = [];
seqEVOLUCAOERRO = [];
seqERROMODELO = [];
seqERROALEATORIA = [];

save teste seqVARIAVEIS_MODELO seqEVOLUCAOERRO seqERROMODELO seqERROALEATORIA

for turn_CIOTTO = 1:5
    
    clear all;format long;format compact;
    load teste seqVARIAVEIS_MODELO seqEVOLUCAOERRO seqERROMODELO seqERROALEATORIA
    
    
    k = 10;
    filename = 'train';
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
    disp('Sequência de entradas que passam a compor o modelo')
    disp(seq_entrada');
    
    seqVARIAVEIS_MODELO = [seqVARIAVEIS_MODELO; seq_entrada'];
    
    disp('Evolução do erro ao longo da construção do modelo');
    disp(seq_EQpl');
    seqEVOLUCAOERRO = [seqEVOLUCAOERRO; seq_EQpl'];
    
    figure;
    plot(seq_EQpl);grid;
    title('Evolução do erro ao longo da construção do modelo');
    xlabel('Número de entradas do modelo');
    ylabel('Erro quadrático');
    
    mEQpl = [];
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
        X_aux = X(:,16:20);Xv_aux = Xv(:,16:20);
        nl = length(X_aux(:,1));
        nlv = length(Xv_aux(:,1));
        X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
        b = inv(X'*X)*X'*S;
        Spl = Xv*b;
        EQpl(fold,1) = (Sv-Spl)'*(Sv-Spl);
    end
    mEQpl_prop = mean(EQpl);
    disp('Erro considerando um modelo com as 5 entradas de maior correlação');
    disp(mEQpl_prop);
    
    seqERROMODELO = [seqERROMODELO; mEQpl_prop];
    
    mEQpl = [];
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
        X_aux = X(:,16:25);Xv_aux = Xv(:,16:25);
        nl = length(X_aux(:,1));
        nlv = length(Xv_aux(:,1));
        X = [X_aux ones(nl,1)];Xv = [Xv_aux ones(nlv,1)];
        b = inv(X'*X)*X'*S;
        Spl = Xv*b;
        EQpl(fold,1) = (Sv-Spl)'*(Sv-Spl);
    end
    mEQpl_prop1 = mean(EQpl);
    disp('Erro considerando um modelo com as 5 entradas de maior correlação e as 5 entradas aleatórias');
    disp(mEQpl_prop1);
    
    seqERROALEATORIA = [seqERROALEATORIA; mEQpl_prop1];
    
    save teste seqVARIAVEIS_MODELO seqEVOLUCAOERRO seqERROMODELO seqERROALEATORIA
    
end
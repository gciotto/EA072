function imprimir(dados)

load (dados);

for k = 1:5
    
    [A, B] = sort(seqEVOLUCAOERRO(k,:),'ascend');
    
    C =[];
    
    for i = (16- B(1) + 1):16
    %for i = 1:(B(1))
        C = [C int2str(seqVARIAVEIS_MODELO(k,i)) ' & '];
        
    end
    
    disp(['Numero de variaveis ' int2str(B(1)) ]);
    disp(['Erro mínimo ' num2str(A(1)) ]);
    C
    disp('=============');
    
end


end
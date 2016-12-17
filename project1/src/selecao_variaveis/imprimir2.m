function imprimir2

load wineq;

da = ['\textit{fixed acidity}' '\textit{volatile acidity}' '\textit{citric acid}' '\textit{residual sugar}' '\textit{chlorides}' '\textit{free sulfur dioxide}' '\textit{total sulfur dioxide' '\textit{density} ' '\textit{pH} ' '\textit{sulphates}' '\textit{alcohol' ];

for k=1:11
    
    disp([da(k) ' & ' num2str(mean(X(:,k))) ' & ' num2str(max(X(:,k))) ' & ' num2str(min(X(:,k))) ' & ' num2str(std(X(:,k))) ' \\ \hline' ]);
    
end

disp(['Saída & ' num2str(mean(S(:))) ' & ' num2str(max(S(:))) ' & ' num2str(min(S(:))) ' & ' num2str(std(S(:))) ' \\ \hline' ]);

end
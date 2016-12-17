% 05/05/2012
% gen_k_folds.m
% Generation of k folds from a single dataset containing X and S
%
clear all;
filename = input('Filename of the original dataset (use single quotes): ');
% filename should contain matrices X and S
load(filename);
k = input('Number of folds: k = ');
perc = input('Pencentual of the dataset to be associated with the test dataset = ');
N = length(X(:,1));
Nt = round((perc/100)*N);
n_elem = floor((N-Nt)/k);
excess = mod((N-Nt),k);
order = randperm(N);
Xt = [];St = [];
for i=1:Nt,
    Xt = [Xt;X(order(i),:)];
    St = [St;S(order(i),:)];
end
ind = Nt+1;
excess1 = excess;
for i=1:k,
    for j=1:n_elem,
        Xfold(j,:,i) = X(order(ind),:);
        Sfold(j,:,i) = S(order(ind),:);
        ind = ind+1;
    end
    if excess1 > 0,
        Xfold(n_elem+1,:,i) = X(order(ind),:);
        Sfold(n_elem+1,:,i) = S(order(ind),:);
        ind = ind+1;
        excess1 = excess1-1;
    end
end
excess1 = excess;
if ~isempty(findstr(filename,'.mat')),
    filename = strrep(filename,'.mat','');
end
for i=1:k,
    if excess1 > 0,
        X = Xfold(1:(n_elem+1),:,i);
        S = Sfold(1:(n_elem+1),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
        excess1 = excess1-1;
    else
        X = Xfold(1:(n_elem),:,i);
        S = Sfold(1:(n_elem),:,i);
        save(strcat(filename,sprintf('%d',i)),'X','S');
    end
end
X = Xt;S = St;
save test X S;

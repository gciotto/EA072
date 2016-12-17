% 05/05/2012
% Verification of the performance of the individual neural networks
% and of the ensemble
% Use of the weights obtained after training the neural networks
% Presentation of graphical results
%

function [error_tot_avg mean_eqmv_min_avg eqm_ens] = analysis(filename, opt, k)

    format compact;format long;
%     filename = input('Filename of the test dataset (use single quotes): ');
%     disp('(1) Use weights minimizing the validation error');
%     disp('(2) Use weights minimizing the training error');
%     opt = input('Which set of weights you would like to use? ');
%     k = input('Number of folds: k = ');
    error_tot = 0;
    mean_eqmv_min = 0;
    load(filename);
    N = length(X(:,1));
    X = [X ones(N,1)];
    disp(sprintf('No. of testing patterns = %d',N));
    for fold=1:k,
        disp(sprintf('Fold = %d',fold));
        if opt == 1,
            load(strcat('w1v',sprintf('%d',fold)));
            load(strcat('w2v',sprintf('%d',fold)));
        elseif opt == 2,
            load(strcat('w1',sprintf('%d',fold)));
            load(strcat('w2',sprintf('%d',fold)));
        else
            error('Wrong choice for the set of weights.');
        end
        load(strcat('evol',sprintf('%d',fold)));
        mean_eqmv_min = mean_eqmv_min + eqmv_min;
        n(1,1) = length(w1(:,1));
        n(2,1) = length(w2(:,1));
        r = n(2);
        m = length(w1(1,:))-1;
        np1 = n(1)*(m+1);np2 = n(2)*(n(1)+1);
        npesos = np1+np2;
        if fold == 1,
            disp(sprintf('No. of hidden layer neurons = %d',n(1)));
            disp(sprintf('No. of weights = %d',npesos));
        end
        if opt == 1,
            disp(sprintf('No. of iterations = %d',niter_v));
        elseif opt == 2,
            disp(sprintf('No. of iterations = %d',niter));
        end
        Srn = [tanh(X*w1') ones(N,1)]*w2';
        S_ens(:,:,fold) = Srn;
        verro = reshape(S-Srn,N*r,1);
        eqf = 0.5*(verro'*verro);
        eqm = sqrt((1/(N*r))*(verro'*verro));
        disp(sprintf('Fold %d: Final mean squared error = %.12g',fold,eqm));
        error_tot = error_tot+eqm;
    end
    disp(sprintf('Average mean squared error for the k MLPs in test.mat = %.12g',error_tot/k));
    error_tot_avg = error_tot/k;
    disp(sprintf('Average mean squared error for the k validation folds during training = %.12g',mean_eqmv_min/k));
    mean_eqmv_min_avg = mean_eqmv_min/k;
    S_ens_mean = zeros(N,r);
    for fold=1:k,
        S_ens_mean = S_ens_mean+S_ens(:,:,fold);
    end
    S_ens_mean = S_ens_mean./k;
    verro_ens = reshape(S-S_ens_mean,N*r,1);
    eqm_ens = sqrt((1/(N*r))*(verro_ens'*verro_ens));
    disp(sprintf('Ensemble: Mean squared error in test.mat = %.12g',eqm_ens));
end

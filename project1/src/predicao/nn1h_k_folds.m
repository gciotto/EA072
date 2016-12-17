% 05/05/2012
% nn1h.m (Neural network with one hidden layer)
% Training of a one-hidden-layer feedforward neural network (perceptron)
% Second-order optimization: Extended scaled conjugate gradient algorithm
% Exact computation of the Hessian matrix (product H*p)
% Required data for supervised learning
% train.mat, with X (input matrix) and S (output matrix)
% valid.mat, with Xv (input matrix) and Sv (output matrix)
% Auxiliary functions:
% init_k_folds.m / process.m / qmean.m / qmean2.m / hprocess.m
%
function nn1h_k_folds(filename, k, n_hid, resp, n_iter)

%     clear all;
    format long;format compact;
    % Root mean square of the gradient: minimum value admitted
    threshold = 1.0e-5;
    % Additional parameters of the extended scaled conjugate gradient algorithm
    tax0 = 0.25;
    tax = tax0;
    cut = 0.25;
    % Uploading the available datasets
    % It is assumed that the range of the data is adequate.
    % If not, they have to be normalized or scaled.
%     filename = input('Filename root of the folds (use single quotes): ');
%     % User defined parameters
%     k = input('Number of folds: k = ');
%     n_hid = input('Number of neurons at the hidden layer = ');
%     disp('(1) Generate w10 and w20, and save');
%     disp('(2) Copy existing w10 and w20');
%     disp('(3) Copy existing w1 and w2');
%     resp = input('Type of weight generation: ');
    for fold=1:k,
        disp(sprintf('Fold = %d',fold));
        it1 = 0; % for lambda
        it2 = 0; % for comp
        it1 = it1+1;lambda(it1) = 0.0;
        blambda = 0;
        Xacc = [];Sacc = [];
        for i=1:k,
            if i~=fold,
                load(strcat(filename,sprintf('%d',i)));
                Xacc = [Xacc;X];Sacc = [Sacc;S];
            else
                load(strcat(filename,sprintf('%d',i)));
                Xv = X;
                Sv = S;
            end
        end
        X = Xacc;S = Sacc;
        % X (input matrix [N]x[n_in]) and S (output matrix [N]x[n_out])
        % Xv (input matrix [Nv]x[n_in]) and Sv (output matrix [Nv]x[n_out])
        n_in = length(X(1,:));
        n_out = length(S(1,:));
        n_w = n_hid*(n_in+1)+n_out*(n_hid+1);
        if fold == 1,
            disp(sprintf('Number of neurons = %d',n_hid));
            disp(sprintf('Number of inputs = %d',n_in));
            disp(sprintf('Number of outputs = %d',n_out));
            disp(sprintf('Number of weights in the neural network = %d',n_w));
        end
        N = length(X(:,1));disp(sprintf('Number of input-output patterns (training) = %d',N));
        Nv = length(Xv(:,1));disp(sprintf('Number of input-output patterns (validation) = %d',Nv));
        
        [w1,w2,eq,eqv,stw1,stw2,rms_w,eqv_min,eqmv_min,niter_v] = init_k_folds(n_in,n_hid,n_out,fold,resp); % w1:[n_hid] x [n_in+1]  w2:[n_out] x [n_hid+1]
%         nitermax = fold*100;
        nitermax = n_iter;
        niter = 1;
        
        rms_w = [rms_w;qmean2(w1,w2)];
        [Ew,dEw,Ewv,eqm,eqmv] = process(X,S,Xv,Sv,w1,w2);
        eq = [eq;Ew];%disp(sprintf('Initial squared error (training) = %.12g',Ew));
        eqv = [eqv;Ewv];%disp(sprintf('Initial squared error (validation) = %.12g',Ewv));
        if isempty(eqv_min),
            eqv_min = Ewv;
        end
        iterminor = 1;
        p = -dEw;p_1 = p;r = -dEw;success = 1;
        while qmean(dEw) > threshold & niter < nitermax,
            if success,
                p1 = reshape(p(1:n_hid*(n_in+1)),n_in+1,n_hid)';
                p2 = reshape(p(n_hid*(n_in+1)+1:n_w),n_hid+1,n_out)';
                s = hprocess(X,S,w1,w2,p1,p2);
                delta = p'*s;
            end
            delta = delta+(lambda(it1)-blambda)*(p'*p);
            if delta <= 0, % Making delta positive
                blambda = 2*(lambda(it1)-delta/(p'*p));
                delta = -delta+lambda(it1)*(p'*p);
                it1 = it1+1;lambda(it1) = blambda;
            end
            mi = p'*r;
            alpha = mi/delta;
            vw = [reshape(w1',n_hid*(n_in+1),1);reshape(w2',n_out*(n_hid+1),1)];
            vw1 = vw + alpha*p;
            w11 = reshape(vw1(1:n_hid*(n_in+1)),n_in+1,n_hid)';
            w21 = reshape(vw1(n_hid*(n_in+1)+1:n_w),n_hid+1,n_out)';
            [Ew1,dEw1,Ewv1,eqm1,eqmv1] = process(X,S,Xv,Sv,w11,w21);
            it2 = it2+1;comp(it2) = (Ew-Ew1)/(-dEw'*(alpha*p)-0.5*(alpha^2)*delta);
            %	In replacement to comp(it2) = 2*delta*(Ew-Ew1)/(mi^2); (is the same)
            if comp(it2) > 0,
                Ew = Ew1;eq = [eq;Ew];
                if Ewv1 < eqv_min,
                    eqv_min = Ewv1;
                    eqmv_min = eqmv1;
                    w1_prov = w1;w2_prov = w2;
                    w1 = w11;w2 = w21;
                    save(strcat('w1v',sprintf('%d',fold)),'w1');
                    save(strcat('w2v',sprintf('%d',fold)),'w2');
                    w1 = w1_prov;w2 = w2_prov;
                    niter_v = niter;
                end
                Ewv = Ewv1;eqv = [eqv;Ewv];
                dEw = dEw1;
                deltaw1 = qmean(w1-w11);deltaw2 = qmean(w2-w21);stw1 = [stw1;deltaw1];stw2 = [stw2;deltaw2];
                rms_w = [rms_w;qmean2(w11,w21)];
                w1 = w11;w2 = w21;
                eqm_fim = eqm1;
                niter = niter+1;
                %disp(sprintf('%5d %d %.12g',niter,iterminor,Ew));
                r1 = r;
                r = -dEw;
                blambda = 0;
                success = 1;
                if (iterminor == n_w),
                    p_1 = p;p = r;
                    iterminor = 1;
                    %                 disp(sprintf('Mean squared error (training) = %.12g at iteration %d',eqm_fim,niter));
                    %                 disp(sprintf('Mean squared error (validation) = %.12g at iteration %d',eqmv_min,niter_v));
                    %                 save(strcat('w1',sprintf('%d',fold)),'w1');
                    %                 save(strcat('w2',sprintf('%d',fold)),'w2');
                    %                 save(strcat('evol',sprintf('%d',fold)),'eq','eqv','stw1','stw2','rms_w','niter','lambda','comp','eqv_min','eqmv_min','niter_v');
                else
                    iterminor = iterminor + 1;
                    beta = (r'*r-r'*r1)/(r1'*r1); % Polak-Ribiere (Luenberger, pp. 253)
                    p_1 = p;p = r+beta*p;
                end
                if comp(it2) >= cut,
                    it1 = it1+1;lambda(it1) = tax*lambda(it1-1); % /4
                    tax = tax*tax0;
                end
            else
                blambda = lambda(it1);
                success = 0;
            end
            if comp(it2) < cut,
                it1 = it1+1;lambda(it1) = lambda(it1-1) + (delta*(1-comp(it2))/(p_1'*p_1));
                tax = tax0;
            end
        end
        disp(sprintf('Final mean squared error (training) = %.12g at iteration %d',eqm_fim,niter));
        disp(sprintf('Final mean squared error (validation) = %.12g at iteration %d',eqmv_min,niter_v));
        save(strcat('w1',sprintf('%d',fold)),'w1');
        save(strcat('w2',sprintf('%d',fold)),'w2');
        save(strcat('evol',sprintf('%d',fold)),'eq','eqv','stw1','stw2','rms_w','niter','lambda','comp','eqv_min','eqmv_min','niter_v');
    end
end
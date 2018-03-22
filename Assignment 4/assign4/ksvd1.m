function [D,xCoeff]=ksvd1(y,phi,phiTphi,stdev,p,X)
    % initialize dict
    [m,N]=size(y);   
    K=20; %not sure
    % initialize dict randomly
    D=randn(p,K); % re-initialize dict...size of dict p*K
    for i=1:K;
        D(:,i)=D(:,i)/norm(D(:,i));
    end
    xCoeff=zeros(K,N);
    %some convergence criterion
    nitter=100;
    for it=1:nitter
    %Step1: sparse coding stage (N signals)
        for i=1:N
            A=phi(:,:,i)*D;            
            %v1=omp(y(:,i),A,7);
            %v2=ompInterBased(y(:,i),A,5);
            %xCoeff(:,i)=omp(y(:,i),A,8);
            xCoeff(:,i)=ompInterBased(y(:,i),A,5);            
        end
    %step2: Codebook Update Stage
        old=D;
        for k=1:K
            a=zeros(p,p);
            b=zeros(p,1);
            predictedX=D*xCoeff;
            for i=1:N
                a=a+(phiTphi(:,:,i).*(xCoeff(k,i)^2));
                y_=y(:,i)-phi(:,:,i)*(predictedX(:,i)-(D(:,k).*xCoeff(k,i)));
                b=b+phi(:,:,i)'*y_.*xCoeff(k,i);
            end                
            D(:,k)=a\b;
            D(:,k)=D(:,k)/norm(D(:,k));  % normalize
            predictedX=D*xCoeff;
            for i=1:N
                if(xCoeff(k,i) ~=0)
                    y_=y(:,i)-phi(:,:,i)*(predictedX(:,i)-(D(:,k).*xCoeff(k,i)));
                    a=D(:,k)'*phi(:,:,i)'*y_;
                    b=D(:,k)'*phiTphi(:,:,i)*D(:,k);
                    xCoeff(k,i)=a/b;
               end
            end
        end
        % check
        predX=D*xCoeff;
        fprintf('it: %d %f\n',it,avgRelativeError(X, predX));
    end
end





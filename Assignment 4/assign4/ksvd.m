function [D,xCoeff]=ksvd(y,phi,stdev,p,X)
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
    nitter=50;
    for it=1:nitter
    %Step1: sparse coding stage (N signals)
        for i=1:N
            A=phi(:,:,i)*D;
            %xCoeff(:,i)=omp(y(:,i),A,stdev(i));
            xCoeff(:,i)=ompInterBased(y(:,i),A,5);
            
        end
    %step2: Codebook Update Stage
        old=D;
        for k=1:K
            a=zeros(p,p);
            b=zeros(p,1);
            for i=1:N
                a=a+(phi(:,:,i)'*phi(:,:,i).*(xCoeff(k,i)^2));
                y_=y(:,i)-phi(:,:,i)*(D*xCoeff(:,i)-D(:,k).*xCoeff(k,i));
                b=b+phi(:,:,i)'*y_.*xCoeff(k,i);
            end
            D(:,k)=a\b;
            D(:,k)=D(:,k)/norm(D(:,k));  % normalize
        end
        for k=1:K
            for i=1:N
                y_=y(:,i)-phi(:,:,i)*(D*xCoeff(:,i)-D(:,k).*xCoeff(k,i));
                a=D(:,k)'*phi(:,:,i)'*y_;
                b=D(:,k)'*phi(:,:,i)'*phi(:,:,i)*D(:,k);
                xCoeff(k,i)=a/b;
            end
        end
%         % check
%         rerr=0;
%         for i=1:N
%             rerr=rerr+(norm((D*xCoeff(:,i)-X(:,i)))/norm(X(:,i)));
%         end
%         rerr=(1/N)*rerr;
%         fprintf('%f\n',rerr);
    end
end





function [D,xCoeff]=ksvd2(y,phi,phiTphi,stdev,p,X,mainD)
    % initialize dict
    [m,N]=size(y);   
    K=20; %not sure
    % initialize dict randomly
    D=randn(p,K); % re-initialize dict...size of dict p*K
    for i=1:K;
        D(:,i)=D(:,i)/norm(D(:,i));
    end
    %D=mainD;
    xCoeff=zeros(K,N);
    %some convergence criterion
    nitter=25;
    for it=1:nitter
    %Step1: sparse coding stage (N signals)
        for i=1:N
            A=phi(:,:,i)*D;            
            %v1=omp(y(:,i),A,1);
            %v2=OMP3(5,y(:,i)',A);
            %v2=v2';
            %v3=ompInterBased(y(:,i),A,5);
            %xCoeff(:,i)=omp(y(:,i),A,1);
            xCoeff(:,i)=ompInterBased(y(:,i),A,1,5);  
            %xCoeff(:,i)=v1;
        end
    %step2: Codebook Update Stage        
        oldD=D;
        oldXCoeff=xCoeff;
        for k=1:K            
            a=zeros(p,p);
            b=zeros(p,1);
            predictedX=D*xCoeff;
            for i=1:N
                a=a+(phiTphi{i}.*(xCoeff(k,i)^2));
                y_=y(:,i)-phi(:,:,i)*(predictedX(:,i)-(D(:,k).*xCoeff(k,i)));
                b=b+phi(:,:,i)'*y_.*xCoeff(k,i);
            end                
            Dk=a\b;
            Dk=Dk./norm(Dk);  % normalize
            for i=1:N
                if( xCoeff(k,i) ~=0)              
                    y_=y(:,i)-phi(:,:,i)*(predictedX(:,i)-(D(:,k).*xCoeff(k,i)));
                    a=D(:,k)'*phi(:,:,i)'*y_;
                    b=D(:,k)'*phiTphi{i}*D(:,k);
                    xCoeff(k,i)=a/b;
               end
            end
            D(:,k)=Dk;
        end
        % check
        predX=D*xCoeff;
        rmseD=rmse(oldD,D);
        rmseXCoeff=rmse(oldXCoeff,xCoeff);
        yerr=0;
         for i=1:N
             yerr=yerr+rmse(y(:,i),phi(:,:,i)*predX(:,i));
         end
         yerr=yerr./N;
        fprintf('%d) rmseD:%d \t rmseXCoeff:%f \t yerr:%f \t AvgRErr:%f\n',it,rmseD,rmseXCoeff,yerr,avgRelativeError(X, predX));
    end
end





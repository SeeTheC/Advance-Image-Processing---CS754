function [y,phi,phiTphi,stdev] = initDataSet(X,p,N,m,f)
    %% Creating Phi
    phi=zeros(m,p,N);
    stdev=zeros(N,1);
    y=zeros(m,N);
    a = -1*(1/ sqrt(m));
    b = 1/ sqrt(m);
    for i=1:N
        for j=1:m
            for k=1:p
                if(randi([0,1],1)==0)
                    phi(j,k,i) = a;
                else
                    phi(j,k,i) = b;
                end
            end
        end
    end
    
    %% Finding Phi^2
    phiTphi=zeros(p,p,N);
    for i=1:N        
        phiTphi(:,:,i)=phi(:,:,i)'*phi(:,:,i);
    end
    %% Creating Y
    for i=1:N
        tempY=phi(:,:,i)*X(:,i);
        stdev(i)=f*(1/m*N)*sum(norm(tempY,1));
        %noise=rand([m,1]).*stdev(i);
        noise=randn(m,1).*stdev(i);        
        y(:,i)=tempY+noise;
    end

end

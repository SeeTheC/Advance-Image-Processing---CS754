% Handling case where multiple max occur
function [optTheta,support]=omp1(y,A,eps,r,initSupport,theta)
    support=initSupport;
    i=1;
    [ySize,xSize]=size(A);
    % Recursive : Handling case where multiple max occur
    recurResult={};
    recurCount=0;
    % unit normalizing A
    normACol=sqrt(sum(A.^2));
    uA=bsxfun(@times,A,normACol.^-1);    
    while(norm(r)>eps)    
        fprintf('%d    %f \n',i,norm(r));
        a=r'*uA;
        [aMax, index]=max(a); % return first max element        
        multMax=find(a==aMax);        
        if numel(multMax)>1
            for j=2:numel(multMax)
                recurCount=recurCount+1;
                otherProbableS=[support,multMax(j)];
                [otherProbableR, opTheta]=updateResidual(A,y,otherProbableS);
                recurResult{recurCount}=omp1(y,A,eps,otherProbableR,otherProbableS,opTheta);
            end
        end
        support=[support,index];                
        [r,theta]=updateResidual(A,y,support);        
        i=i+1;
    end
    fprintf('%d    %f \n',i,norm(r));
    thetaFinal=zeros(xSize,1);
    thetaFinal(support)=theta;
    optTheta=thetaFinal; 
    
   % Finding Optimal Result
    if recurCount>0   
        optError=norm(y-A*optTheta);
        for j=1:recurCount
            error=norm(y-A*recurResult{j});
            if error < optError
                optError=error;
                optTheta=recurResult{j};
            end
        end
    end
end

% Updates the residual vector
function [residual,theta]=updateResidual(A,y,newSupport)
        Ati=A(:,newSupport);
        theta=Ati\y;
        %theta1=inv(Ati'*Ati)*Ati'*y;
        residual=y-Ati*theta;
end
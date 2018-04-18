function [x] = reconstruct(y,phi,mvcovar,stdev,m)
    sigma=diag(ones(1,m)*stdev);    
    invMVCovar=inv(mvcovar);
    invSigma=inv(sigma);        
    x=(phi'*invSigma*phi+invMVCovar)\(phi'*invSigma*y);
end


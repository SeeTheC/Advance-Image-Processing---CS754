function [x] = reconstruct(y,phi,mvcovar,stdev,trueX)
    invMVCovar=inv(mvcovar);
    lamda= stdev*(invMVCovar+invMVCovar');
    x=(phi'*phi+lamda)\(phi'*y);
end


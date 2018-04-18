% Generate Multivarient Covarience matrix
function [ mvcovar ] = multivarientCoVar(mtxsize,alpha)
    % Creating 
    rng(100)
    % Creating Non-sigular matrix
    mtx=randn(mtxsize);
    %mtx=randi([1,10],mtxsize);
    [u,~,~]=svd(mtx);
    eigVal=[1:mtxsize];
    eigVal=eigVal.^(-alpha);
    eigVal=diag(eigVal);
    mvcovar=u*eigVal*u';    
end


% Generate Compressive Measurement
function [y,phi,stdevVal] = genCM(X,m,n)
    %% INIT
    f=0.01; % fraction of sigma
    noOfSample=size(X,1);
    %% Creating Phi
    phi=cell(noOfSample,1);
    y=zeros(m,noOfSample);
    for i=1:noOfSample
        ithPhi=randi([0,1],[m,n]);
        ithPhi(ithPhi==0)=-1;
        ithPhi=ithPhi.*(1/ sqrt(m));
        phi{i}=ithPhi;
    end   
    %% Creating Y
    stdevVal=cell(noOfSample,1);
    for i=1:noOfSample
        tempY=phi{i}*X(i,:)';
        stdev=f*mean(tempY); 
        stdevVal{i}=stdev;
        % add gaussain noise
        noise=randn(m,1).*stdev;        
        y(:,i)=tempY+noise;
    end    
end

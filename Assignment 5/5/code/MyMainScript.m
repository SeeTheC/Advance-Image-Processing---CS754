%% MAP Estimate
% Assignment 5-5 
% 
% Rollno: 163059009, 16305R011

%% 1. Init:
alpha=3;
n=128;
noOfX=10; 
m = [40, 50, 64, 80, 100, 120];
%% Test for MVN G

mu = [2 3];
sigma = [1 1.5; 1.5 3];
rng(1,'twister')
R = mvnrnd(mu,sigma,100);
rng(1,'twister')
a1 =mvnrnd(mu,sigma,1);


%% 1.2 Generating 10 x
mu=zeros(1,n);
[ mvcovar ] = multivarientCoVar(n,alpha);
rng(1)
X = mvnrnd(mu,mvcovar,noOfX);

%% 1.3 Finding Compressive measurement
noOfM=numel(m);
yCM=cell(noOfM,1);
rmsError=zeros(noOfM,1);
fprintf('------------------------ \n');
for i=1:noOfM
    [y,phi,stdev] = genCM(X,m(i),n);
    %predictedX=zeros(noOfX,n);
    error=0;
    for j=1:noOfX
        predictedX=reconstruct(y(:,j),phi{j},mvcovar,stdev{j},X(j,:)'); 
        error=rmse(predictedX,X(j,:)')+error;
    end
    error=error/noOfX;
    fprintf('**m=%d rmse:%f \n',m(i),error);    
end


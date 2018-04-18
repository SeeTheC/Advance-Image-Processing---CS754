%% MAP Estimate
% Assignment 5-5 
% 
% Rollno: 163059009, 16305R011

%% 1. Init With aplha as "3"
alpha=3;
n=128;
noOfX=10; 
m = [40, 50, 64, 80, 100, 120];

%% 1.2 Generating 10 x
mu=zeros(1,n);
[ mvcovar ] = multivarientCoVar(n,alpha);
rng(64)
X = mvnrnd(mu,mvcovar,noOfX);

% 1.3 Finding Compressive measurement
noOfM=numel(m);
yCM=cell(noOfM,1);
aplha3RmsError=zeros(noOfM,1);
fprintf('---------[alpha:%d]--------------- \n',alpha);
for i=1:noOfM
    [y,phi,stdev] = genCM(X,m(i),n);    
    error=0;    
    for j=1:noOfX
        predictedX=reconstruct(y(:,j),phi{j},mvcovar,stdev{j},m(i)); 
        error=rmse(predictedX,X(j,:)')+error;
    end
    error=error/noOfX;
    aplha3RmsError(i)=error;
    fprintf('m=%d\trmse:%f \n',m(i),error);    
end

%% 1.4 Plot

figure('name','For aplha:3')
plot(m',aplha3RmsError);

%% Test for MVN G

mu = [2 3];
sigma = [1 1.5; 1.5 3];
rng(1,'twister')
R = mvnrnd(mu,sigma,100);
rng(1,'twister')
a1 =mvnrnd(mu,sigma,1);
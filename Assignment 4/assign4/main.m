%% MyMainScript
%% Assignment3-2 
% Rollno: 163059009, 16305R011 

%% Init 
% Dictionary
rng(1);
K=20;
p=100;
D=randn(p,K);
% unit normalization
for i=1:K;
    D(:,i)=D(:,i)/norm(D(:,i));
end
%% Creating Signal
% signal
N=100;
X=zeros(N,p);
for i=1:N
    support=randi([1 20],1,5);
    coeff=randi([0 10],1,5);    
    X(:,i)=coeff*D(:,support)';    
end

%% Creat Y and PHI
m=[10,20,30,40,50,70,90];
f=[0.001, 0.01, 0.02, 0.05, 0.1, 0.3];
[y,phi,phiTphi,stdev] = initDataSet(X,p,N,90,0.001);


%% Blind Sensing

[Dict,xCoeff]=ksvd1(y,phi,phiTphi,stdev,p,X);

%% average relative error
rerr=0;
predX=Dict*xCoeff;
fprintf('%f\n',avgRelativeError(X, predX));
%%

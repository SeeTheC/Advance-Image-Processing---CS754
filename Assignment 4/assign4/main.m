%% MyMainScript
%% Assignment3-2 
% Rollno: 163059009, 16305R011 

%% Init
m=[10,20,30,40,50,70,90];
f=[0.001, 0.01, 0.02, 0.05, 0.1, 0.3];

%% 1. Creating Dictionary
K=20;
p=100;
D=randn(p,K);
% unit normalization
for i=1:K;
    D(:,i)=D(:,i)/norm(D(:,i));
end
%% 1.1 Creating Signal
% signal
N=100;
X=zeros(N,p);
for i=1:N
    support=randi([1 20],1,5);
    coeff=randi([0 10],1,5);    
    X(:,i)=coeff*D(:,support)';    
end

%% 1.2 Finding Dict,xCoeff for every
avgError=zeros(size(f,2),size(m,2));
epsilon=1e-4;
for fi=1:size(f,2)
    for mi=1:size(m,2)
        fprintf('**f:%f  m:%f\n',f(fi),m(mi));
        %%  1.2.1 Create Y and PHI
        [y,phi,phiTphi,stdev] = initDataSet(X,p,N,m(mi),f(fi));
        %% 1.2.2 Blind Sensing        
        [Dict,xCoeff]=ksvd1(y,phi,phiTphi,stdev,p,X,epsilon);

        %% 1.2.3 average relative error
        rerr=0;
        predX=Dict*xCoeff;
        avr=avgRelativeError(X, predX);
        fprintf('%f\n',avr);
        avgError(fi,mi)=avr;
    end
end
%% 1.3 Ploting Graph
x=m; c = {'r','g','m','b','y','black'};
for i=1:size(f,2)
    y=avgError(i,:);
    plot(x,y,strcat('*--',c{i})),hold on      
end
xlabel('m');
ylabel('error');
legend('f:001','f:01','f:02','f:05', 'f:0.1','f:0.3');

%% 2.PART B

%% Reading dataset
clear all;
trainFP='../data/train-images.idx3-ubyte';
trainLabelFP='../data/train-labels.idx1-ubyte';
[trainDS,trainLabel]=loadMNISTImages(trainFP,trainLabelFP);

%% Taking 600 samples per digit

noImgPerDigit=600;
imgDim=[16,16];
trainSampleImg=zeros(imgDim(1)*imgDim(2),noImgPerDigit*10);
dpCounter=1;%datapoint

for i=1:10
    num=i-1;
    idx=find(trainLabel==num);       
    idx=idx(1:noImgPerDigit);
    for j=1:noImgPerDigit
         img=trainDS(:,:,idx(j));
         img1=imresize(img,imgDim(1)/28,'bilinear');
         vImg=reshape(img1,imgDim(1)*imgDim(2),1);
         trainSampleImg(:,dpCounter)=vImg;
         dpCounter=dpCounter+1;
    end
end
clear idx;
clear trainDS;
clear trainLabel;
%% Finding y and phi 
m=[10,20,30,40,50,70,90];
f=0.01;
X=trainSampleImg; N=noImgPerDigit*10; p=imgDim(1)*imgDim(2);
[y,phi,phiTphi,stdev] = initDataSet(X,p,N,90,0.01);
%% Blind C.S
epsilon=1e-1;
tic
[Dict,xCoeff]=ksvd1(y,phi,phiTphi,stdev,p,X,epsilon);
toc

figure('name','Dictionary')
for i=1:20
    subplot(4,5,i);
    img=reshape(Dict(:,i),16,16);
    imshow(img,[]);
end
save('D_90.mat','Dict');




%%
%% Compressive Video Acquisition using coded snapshoyt
%% Assignment1-5 
% Rollno: 163059009, 16305R011 

% adding path for MMREAD
addpath('../MMread');
%Save the current state of the random number generator
randState = rng;

%% Init
file='../input/cars.avi';
video=mmread(file,1:T,[],false,true);

%% 1. Part(a) Fetch T=3 frames
T=3; %no.of frames
frame=zeros(120,240,T);
for i=1:T    
    img=rgb2gray(frameTotal(i).cdata);    
    frame(:,:,i)=img(H-120+1:H,W-240+1:W);
end
H=120;W=240;

%% 2. Creating Random Code Matrix 

% Restore the Random state (help in debugging)
rng(randState);
% Creating Code HxWxT 
C=randi([0 1],H,W,T);

%% 2.1 Creating Coded Snapshot

E=zeros(H,W);%coded snapshot 
epsilon=2.0;% gaussian  standard deviation
noise=rand([H W])*epsilon;
for i=1:T
    E=E+frame(:,:,i).*C(:,:,i);
end
% adding noise;
E = E + noise; 

figure('name','Coded snapshot with noise');
imshow(E/max(E(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}Coded snapshot with noise T=3}');
axis tight,axis on;


%% 3. Part(c)

%% 4. Part(d): Reconstruction
tic
patchSize=8;ompEpsilon=6;
[outputImg]=reconstruct(E,T,C,patchSize,ompEpsilon);
toc
%% 4.1 Showing o/p
for i=1:T
    figure('name','Result T=3');
    
    % Original    
    subplot(1,2,1);
    imshow(frame(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{red} Orginal T=3: Frame %d}',i);
    title(label);   
    
    % Reconstruction       
    subplot(1,2,2);
    imshow(outputImg(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{magenta} Reconst. T=3: Frame %d}',i);
    title(label);   
    
    
end
%%


%% Compressive Video Acquisition using coded snapshoyt
%% Assignment1-5 
% Rollno: 163059009, 16305R011 

% adding path for MMREAD
addpath('../MMread');

%% Init
file='../input/cars.avi';

%Save the current state of the random number generator
randState = rng;

%% 1. part(a)
T=7; %no.of frames
vid1=mmread(file,1:T,[],false,true);
nFrames=vid1.nrFramesTotal; %If it is a possitive number then it should always be accurate
H=vid1.height;
W=vid1.width;
frameTotal=vid1.frames;
frame=zeros(120,240,T);
for i=1:T    
    img=rgb2gray(frameTotal(i).cdata);    
    frame(:,:,i)=img(H-120+1:H,W-240+1:W);
end
H=120;W=240;
%% 1.1 Showing 3 Frames

figure('name','frame1');
imshow(frame(:,:,1)/max(frame(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}frame1}');
axis tight,axis on;

figure('name','frame2');
imshow(frame(:,:,2)/max(frame(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}frame2}');
axis tight,axis on;

figure('name','frame3');
imshow(frame(:,:,3)/max(frame(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}frame3}');
axis tight,axis on;


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
%E = E + noise; 

figure('name','Coded snapshot with noise');
imshow(E/max(E(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}Coded snapshot with noise T=3}');
axis tight,axis on;


%% 3. part(c)
%% 4.
tic
patchSize=8;
[outputImg]=reconstruct(frame,E,T,C,patchSize,0.2);
toc
%% Showing o/p
img=outputImg(:,:,1);
figure('name','output');
%imshow(img,[min(img(:)) max(img(:))]);
imshow( ( img- min(img(:))) ./ (max(img(:))-min(img(:))));
impixelinfo;
title('\fontsize{10}{\color{magenta}Output}');
axis tight,axis on;

img=outputImg(:,:,2);
figure('name','output');
%imshow(img,[min(img(:)) max(img(:))]);
imshow( ( img- min(img(:))) ./ (max(img(:))-min(img(:))));

impixelinfo;
title('\fontsize{10}{\color{magenta}Output}');
axis tight,axis on;
%%
img=outputImg(:,:,7);
figure('name','output');
imshow(img,[min(img(:)) max(img(:))]);
%imshow( ( img- min(img(:))) ./ (max(img(:))-min(img(:))));
impixelinfo;
title('\fontsize{10}{\color{magenta}Output}');
axis tight,axis on;

%% part(d)

patchSize=8;
Evectors=makePatchs(E,patchSize); %returns all the patch in a vector form patchSize*totalPatch
dct=dctmtx(patchSize*patchSize*T); % si matrix nT*nT =8*8*T

totalPatches=H*W/(patchSize*patchSize);
theta=zeros(patchSize*patchSize*T,totalPatches);
c1=num2cell(makePatchs(C(:,:,1),patchSize));
c2=num2cell(makePatchs(C(:,:,2),patchSize));
c3=num2cell(makePatchs(C(:,:,3),patchSize));
for i=1:1:totalPatches
    q1=reshape(c1(:,i),8,8);
    q2=reshape(c2(:,i),8,8);
    q3=reshape(c3(:,i),8,8);
    phi=[blkdiag(q1{:}) blkdiag(q2{:}) blkdiag(q3{:})]; % n*nT 
    A=phi*dct; %n*nT
    [temp support]=omp(Evectors(:,i),A,epsilon);
    theta(:,i)=temp;
end
[finalImg]=convertPatchToImg(theta,patchSize,[H W T])
%y=reshape(E(1:patchSize,1:patchSize),patchSize*patchSize,1); %n
%block diagnol phi matrix (dimension n * nT)


% imshow(dct);
% A=phi*dct;
% theta=[theta' 0.0];
% theta=reshape(theta,8,8);
figure('name','test1');
imshow(finalImg(:,:,1)/max(theta(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}test1}');
axis tight,axis on;

figure('name','test2');
imshow(finalImg(:,:,2)/max(theta(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}test2}');
axis tight,axis on;

figure('name','test3');
imshow(finalImg(:,:,3)/max(theta(:)));
impixelinfo;
title('\fontsize{10}{\color{magenta}test3}');
axis tight,axis on;

%% Testing OMP code

A= [0,1,0,1,0,1;
    1,0,0,0,1,0;
    0,0,1,1,0,1];
X=[1;0;4;0;0;7];
Y=[7;1;11];
r=omp(Y,A,0.5)
%r=omp1(Y,A,0.5,Y,[],0);

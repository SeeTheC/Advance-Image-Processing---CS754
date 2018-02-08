%% Compressive Video Acquisition using coded snapshoyt
% Assignment1-5 
% Rollno: 163059009, 16305R011 

%% Init
% adding path for MMREAD
% addpath('../MMread');
file='../input/cars.avi';
video=mmread(file,1:10,[],false,true);
H=120;W=240;

%% 1. Part(a) Fetch T=3 frames
T=3; %no.of frames

frame=fetchFrames(video,T,H,W) ; 

%% 2. Creating Random Code Matrix 

C=generateCodeMtx(H,W,T);

%% 2.1 Creating Coded Snapshot

noiseStd=2.0;
E=generateCodedSnapshot(frame,C,noiseStd);

%% 2.2 Showing the "Coded snapshot"

figure('name','Coded snapshot with noise');
imshow(E/max(E(:)));
title('\fontsize{10}{\color{magenta}Coded snapshot with noise for T=3}');
axis tight,axis on;


%% 3. Part(c)

%% 4. Part(d & e): Reconstruction
% Part(d) theory

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
%% 5. Video Acquisition and Reconstuction for # of Frames 5

T=5; %no.of frames
frame=fetchFrames(video,T,H,W) ; 
C=generateCodeMtx(H,W,T);
noiseStd=2.0;

% Create Coded Snapshot
E=generateCodedSnapshot(frame,C,noiseStd);

figure('name','Coded snapshot with noise');
imshow(E/max(E(:)));
title('\fontsize{10}{\color{magenta}Coded snapshot with noise for T=5}');
axis tight,axis on;

% Reconstruction using C.S
tic
patchSize=8;ompEpsilon=6;
[outputImg]=reconstruct(E,T,C,patchSize,ompEpsilon);
toc

%  Showing o/p
for i=1:T
    figure('name','Result T=5');
    
    % Original    
    subplot(1,2,1);
    imshow(frame(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{red} Orginal T=5: Frame %d}',i);
    title(label);   
    
    % Reconstruction       
    subplot(1,2,2);
    imshow(outputImg(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{magenta} Reconst. T=5: Frame %d}',i);
    title(label);      
    
end

%% 6. Video Acquisition and Reconstuction for # of Frames 7

T=7; %no.of frames
frame=fetchFrames(video,T,H,W) ; 
C=generateCodeMtx(H,W,T);
noiseStd=2.0;

% Create Coded Snapshot
E=generateCodedSnapshot(frame,C,noiseStd);

figure('name','Coded snapshot with noise');
imshow(E/max(E(:)));
title('\fontsize{10}{\color{magenta}Coded snapshot with noise for T=7}');
axis tight,axis on;

% Reconstruction using C.S
tic
patchSize=8;ompEpsilon=6;
[outputImg]=reconstruct(E,T,C,patchSize,ompEpsilon);
toc

%  Showing o/p
for i=1:T
    figure('name','Result T=5');
    
    % Original    
    subplot(1,2,1);
    imshow(frame(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{red} Orginal T=7: Frame %d}',i);
    title(label);   
    
    % Reconstruction       
    subplot(1,2,2);
    imshow(outputImg(:,:,i),[]);
    label= sprintf('\\fontsize{10}{\\color{magenta} Reconst. T=7: Frame %d}',i);
    title(label);      
    
end


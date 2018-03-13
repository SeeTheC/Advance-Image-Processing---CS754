%% MyMainScript
%% Assignment3-2 
% Rollno: 163059009, 16305R011 

%% Init
clear all;
addpath(genpath('l1_ls_matlab/'));

file1='../data/t1_icbm_normal_1mm_pn0_rf20.rawb.png';
file2='../data/t1_icbm_normal_1mm_pn3_rf20.rawb.png';
img1=imread(file1);
img1=double(img1);
img2=imread(file2);
img2=double(img2);

figure('name','Original brain cross section image');
imshow(img1,[]);
title('\fontsize{10}{\color{red}Brain cross section image}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);

%% 0)  Finding Projection
totalAngles=18;
theta = randi([0 179],1,totalAngles);
[R,xp] = radon(img1,theta);

%% Part a)  RamLak filter
% We have implemented our OWN RAMLAK implemented
imgRamLak=RamLakFilter(R,theta);

figure('name','Reconstruction using RamLak Filter');
imshow(imgRamLak,[]);
title('\fontsize{10}{\color{magenta} Reconstruction using "Own" RamLak Filtered BP}');


%% Using irandon method of Matlab
I2 = iradon(R,theta,'linear','Ram-Lak');

figure('name','Reconstruction using RamLak Filter');
imshow(I2,[]);
title('\fontsize{10}{\color{magenta} Reconstruction using "iradon" RamLak Filtered BP}');


%% 2. Part b) Compressed Sensing
% E(x) = |y − Ax|^2 + λ|x|_1
% y= sum total of # of bins for each angle
m=size(R,1);
n=size(img1,1)*size(img1,2);
A=CSProjMtx(m,n,theta);
At=A';
%% 2.1 Sovling equation using L1_Ls 
vecR=reshape(R,m*numel(theta),1);
y=vecR;
lambda = 8;
[beta,status]=l1_ls(A,At,size(y,1),n,y,lambda);

dctcoeff=reshape(beta,size(img1,1),size(img1,2));
f=idct2(dctcoeff);
figure('name','Reconstruction using CS');
imshow(f,[]);
title('\fontsize{10}{\color{magenta}Reconstruction using CS}');

%% 3. Part c) Coupled CS
% E(x) = |y − Ax|^2 + λ|x|_1
% y= sum total of # of bins for each angle

totalAngles=18;
theta1 = randi([0 179],1,totalAngles);
theta2 = randi([0 179],1,totalAngles);
[R1,xp1] = radon(img1,theta1);
[R2,xp2] = radon(img2,theta2);

%% 3.1 Init Operator
projSize=size(R1,1);
n=size(img1,1)*size(img1,2);
coupleSize=2;
A=CoupledCSProjMtx(projSize,n,coupleSize,{theta1,theta2});
At=A';

%% 3.2 Solving
R=horzcat(R1,R2);
vecR=reshape(R,projSize*totalAngles*coupleSize,1);
y=vecR;
m=size(y,1);n=size(img1,1)*size(img1,2)*coupleSize;
lambda = 8;
[betas,status]=l1_ls(A,At,m,n,y,lambda);

%% 3.3 Showing Result
bcell=getBetaMtxFromVec(A,betas);
beta1=bcell{1};betaDiff=bcell{2};
beta2=betaDiff+beta1;

% Image 1
dctcoeff=reshape(beta1,size(img1,1),size(img1,2));
f=idct2(dctcoeff);
figure('name','Reconstruction using CS');
subplot(1,2,1),
imshow(f,[]),
title('\fontsize{10}{\color{magenta}Reconst using Coupled CS: Image 1}');

% Image 2
dctcoeff=reshape(beta2,size(img1,1),size(img1,2));
f=idct2(dctcoeff);
subplot(1,2,2),
imshow(f,[]),
title('\fontsize{10}{\color{magenta}Reconst using Coupled CS: Image 2}');

%% %Debug
%{
coff=dct2(img);
beta=reshape(coff,180*180,1);
vtR=A*beta;
tR=reshape(vtR,259,18);


I1 = iradon(R,theta,'linear','Ram-Lak');
figure('name','Reconstruction using RamLak Filter');
imshow(I1,[]);
title('\fontsize{10}{\color{magenta} R1}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);

I2 = iradon(tR,theta,'linear','Ram-Lak');
figure('name','Reconstruction using RamLak Filter');
imshow(I2,[]);
title('\fontsize{10}{\color{magenta} R2}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);

%}



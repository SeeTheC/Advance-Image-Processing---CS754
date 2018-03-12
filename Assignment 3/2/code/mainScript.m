%% MyMainScript
%% Assignment3-2 
% Rollno: 163059009, 16305R011 

%% Init
clear all;
addpath(genpath('l1_ls_matlab/'));

file='../data/t1_icbm_normal_1mm_pn0_rf20.rawb.png';
img=imread(file);
img=double(img);
[rowI,colI]=size(img);
%%img=im2double(img);


figure('name','Original brain cross section image');
imshow(img,[]);
title('\fontsize{10}{\color{red}Brain cross section image}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);


%%  Finding Projection
totalAngles=18;
%theta = randi([0 179],1,totalAngles);
theta=linspace(0,170,totalAngles);
[R,xp] = radon(img,theta);

%% Test
%{
I2 = iradon(R,theta,'linear','Ram-Lak');

figure('name','Reconstruction using RamLak Filter');
imshow(I2,[]);
title('\fontsize{10}{\color{magenta}Reconstruction using RamLak Filter}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1)

%}
%% Part a) RamLak filter
% RAMLAK implemented
imgRamLak=RamLakFilter(R,theta);

figure('name','Reconstruction using RamLak Filter');
imshow(imgRamLak,[]);
title('\fontsize{10}{\color{magenta}Reconstruction using RamLak Filter}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);

%% test
% [I,H]=iradon(R,theta);
% 
% figure('name','test');
% imshow(I,[]);
% title('\fontsize{10}{\color{red}test}');
% axis tight,axis on;
% o1 = get(gca, 'Position');
% colorbar(),set(gca, 'Position', o1);

%% part b)
% E(x) = |y − Ax|^2 + λ|x|_1
% y= sum total of # of bins for each angle
m=size(R,1);
n=size(img,1)*size(img,2);
A=APartb(m,n,theta);
At=A';
%%
vecR=reshape(R,m*numel(theta),1);
y=vecR;
lambda  = 0.01;
rel_tol = 0.01; 
[x,status]=l1_ls(A,At,size(y,1),n,y,lambda,rel_tol);


%%
rimg=reshape(x,size(img,1),size(img,2));
figure('name','Reconstruction using RamLak Filter');
imshow(rimg,[]);
title('\fontsize{10}{\color{magenta}Reconstruction using RamLak Filter}');
axis tight,axis on;
o1 = get(gca, 'Position');
colorbar(),set(gca, 'Position', o1);
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



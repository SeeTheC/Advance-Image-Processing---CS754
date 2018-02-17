% Returns the "coded image" for Image Acquisition using Compressed sensing
function [ output ] = generateCodedSnapshot(img,code,noiseStd)
    [h,w]=size(img);
    E=zeros(h/2,w);%coded snapshot 
    % noiseStd : gaussian  standard deviation
    noise=rand([h/2,w])*noiseStd;
    E=E+code(:,:)*img(:,:);
    % adding noise;
    E = E + noise; 
    output = E;
end
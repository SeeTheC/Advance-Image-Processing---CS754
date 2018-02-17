% Reconstruct the image
function [outFrame] = reconstructb(img,code,patchSize,lambda,noise,convergeVal,alphaAdd)
    % Reconstruct patch wise with overlapping patch
    % Init
    [row,col]=size(img);    
    vectorSize=patchSize^2;
    % 2D basis
    shi=kron(dctmtx(8),dctmtx(8));
    % figure;imshow(shi);
    
    %% Reconstruct 
    imgReconstruct=zeros(row,col);
    patchAddedCount=zeros(row,col);
    for r=1:row-patchSize+1
        %fprintf('r=%d\n',r);
        for c=1:col-patchSize+1
            %fprintf('c=%d\n',c);
            x1=r;x2=r+patchSize-1;
            y1=c;y2=c+patchSize-1;
            
            pE=img(x1:x2,y1:y2);
            pEVec=reshape(pE',vectorSize,1);
            %phi=randi([0 1],32,64);
            phi=code(r:r+(vectorSize/2)-1,c:c+vectorSize-1); % 32X64 vector
            noiseMat=noise(r:r+(patchSize/2)-1,c:c+patchSize-1); % 4X8 vector
            noiseVector=reshape(noiseMat,patchSize*patchSize/2,1);
            A=phi*shi;
            y=phi*pEVec+noiseVector;
            
            theta=ISTA(y,A,lambda,convergeVal,alphaAdd);
            xVec=shi*theta;               
            xMat=reshape(xVec(:),patchSize,patchSize)';
            imgReconstruct(x1:x2,y1:y2)=imgReconstruct(x1:x2,y1:y2)+xMat(:,:);
            patchAddedCount(x1:x2,y1:y2)=patchAddedCount(x1:x2,y1:y2)+1;
        end
    end
    
    % normalizing count
    imgReconstruct(:,:)=imgReconstruct(:,:)./patchAddedCount(:,:);
    outFrame=imgReconstruct;
end


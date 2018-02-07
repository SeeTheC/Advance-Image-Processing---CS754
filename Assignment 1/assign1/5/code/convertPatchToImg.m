function [img]=convertPatchToImg(patchImg,patchSize,dim)  
    % Init    
    row=dim(1);col=dim(2);T=dim(3);
    img=zeros(row,col,T);
    %patchAddedCount=zeros(row,col);
    pk=1;
    m=64;
    % Fetching patch from image and trasforming it into vector 
    for i=1:8:row;
        for j=1:8:col;
            [x1,y1,x2,y2]=getPatchCoordinate([i,j],patchSize);
            mat=reshape(patchImg(1:m,pk),patchSize,patchSize);
            img(x1:x2,y1:y2,1)=mat;
            mat=reshape(patchImg(m+1:2*m,pk),patchSize,patchSize);
            img(x1:x2,y1:y2,2)=mat;
            mat=reshape(patchImg((2*m+1):3*m,pk),patchSize,patchSize);
            img(x1:x2,y1:y2,3)=mat;
            %patchAddedCount(x1:x2,y1:y2)=patchAddedCount(x1:x2,y1:y2)+1;
            pk=pk+1;
        end
    end
    disp(img);
end

% Getting Patch Coordinate
function [x1,y1,x2,y2]=getPatchCoordinate(topLeftPoint,patchSize)
    x=topLeftPoint(1);y=topLeftPoint(2);           
    x1=x;y1=y;    
    x2=x+patchSize-1;y2=y+patchSize-1; 
end
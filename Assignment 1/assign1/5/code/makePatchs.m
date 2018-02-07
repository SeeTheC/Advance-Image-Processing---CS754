function [Evectors]=makePatchs(E,pSize)
    [rows,cols]=size(E);
    totalPatch=(rows*cols)/(pSize*pSize);
    Evectors=zeros(pSize*pSize,totalPatch);
    count=1;
    for i=1:pSize:rows
        for j=1:pSize:cols
            patchImg=E(i:i+pSize-1,j:j+pSize-1);
            Evectors(:,count)=reshape(patchImg,pSize*pSize,1);
            count=count+1;
        end
    end
end
% Reconstruct the image
function [outFrames] = reconstruct(frame,snapshot,noOfFrame,codes,patchSize,epsilon)

    
    % Init
    [row,col]=size(snapshot);    
    vectorSize=patchSize^2;
    
    % Reconstruct patch wise
    % overlapping patch

    %creating shi (PatchSize*PatchSize*NoOfFrame) X (PatchSize*PatchSizex*NoOfFrame)
    dct2d=get2dDCT(patchSize,patchSize);
    if noOfFrame==2
        shi=blkdiag(dct2d,dct2d);
        invdct2d=blkdiag(dct2d',dct2d');
    elseif noOfFrame==3
        shi=blkdiag(dct2d,dct2d,dct2d);
        invdct2d=blkdiag(dct2d',dct2d',dct2d');
    elseif noOfFrame==5
        shi=blkdiag(dct2d,dct2d,dct2d,dct2d,dct2d);
        invdct2d=blkdiag(dct2d',dct2d',dct2d',dct2d',dct2d');
    elseif noOfFrame==7
        shi=blkdiag(dct2d,dct2d,dct2d,dct2d,dct2d,dct2d,dct2d);    
        invdct2d=blkdiag(dct2d',dct2d',dct2d',dct2d',dct2d',dct2d',dct2d');
    end
    img=zeros(row,col,noOfFrame);
    patchAddedCount=zeros(row,col,noOfFrame);
    img1=frame(:,:,1);
    for r=1:row-patchSize+1
        fprintf('r=%d\n',r);
        for c=1:col-patchSize+1
            x1=r;x2=r+patchSize-1;
            y1=c;y2=c+patchSize-1;
            
            pE=snapshot(x1:x2,y1:y2);
            pEVec=reshape(pE',vectorSize,1);
            phi=getPhi(codes,r,c,patchSize);
            A=phi*shi;
            theta=omp(pEVec,A,epsilon);
            xVec=invdct2d*theta;            
            xMat=convert3dVectToMat(xVec,patchSize,noOfFrame);
            for t=1:noOfFrame
                img(x1:x2,y1:y2,t)=img(x1:x2,y1:y2,t)+xMat(:,:,t);
                patchAddedCount(x1:x2,y1:y2,t)=patchAddedCount(x1:x2,y1:y2,t)+1;
            end
        end
    end
    
    % normalizing count
     for t=1:noOfFrame
           img(:,:,t)=img(:,:,t)./patchAddedCount(:,:,t);
     end
     outFrames=img;
end

% Convert 3d Vector 3D Matrix
function [mat3d] = convert3dVectToMat(vec,patchSize,noOFFrame)
    patch=zeros(patchSize,patchSize,noOFFrame);
    n=patchSize*patchSize;
    for t=1:noOFFrame
        offset=(t-1)*n;
        patch(:,:,t)=reshape(vec(offset + 1: offset + n),patchSize,patchSize)';
    end
    mat3d=patch;
end

% Return patchedPhi
function [phi]=getPhi(codes,r,c,patchSize)
    noOfCode=size(codes,3);
    n=patchSize*patchSize;
    phi=[];
    for ci=1:noOfCode;
        codePatch=codes(r:r+patchSize-1,c:c+patchSize-1,ci);
        phi=horzcat(phi,diag(reshape(codePatch',1,n)));
    end    
end

function [dct2dMtx]=get2dDCT(M,N)
    %c=reshape(b*reshape(a',4,1),2,2)'
    d=M*N;
    dct2dMtx=zeros(d,d);
    r=1;
    for u=1:M
        if (u-1) == 0
            c1=sqrt(1/M);
        else
            c1=sqrt(2/M);
        end
        for v=1:N
            if (v-1) == 0
                c2=sqrt(1/N);
            else
                c2=sqrt(2/N);
            end        
            c=1;
            for m=1:M                           
                for n=1:N
                 val=c1*c2*cos( (pi*(2*(m-1)+1)*(u-1) )/(2*M) ) * cos( (pi*(2*(n-1)+1)*(v-1) )/(2*N) );
                 dct2dMtx(r,c)=val;
                 c=c+1;
                end
            end
            r=r+1;
        end
    end
end
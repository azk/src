function [ picVector ] = GETLBPVECTOR( faceImage,PIC_WIDTH,PIC_HEIGHT,numSubPics )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    faceImage = imresize(faceImage, [PIC_WIDTH PIC_HEIGHT]);
    
    picVector = zeros(numSubPics*numSubPics*256,1)';

    deltaX = uint32(PIC_WIDTH/numSubPics);
    deltaY = uint32(PIC_HEIGHT/numSubPics);
    counter = 0;
    for j=0:(numSubPics-1)
        for k=0:(numSubPics-1) 
            subPic = faceImage((1+j*deltaX):((j+1)*deltaX),(1+k*deltaY):((k+1)*deltaY));
            [~, tpl] = TPLBP(subPic);
            hst = imhist(tpl);
            picVector(1,(1+256*counter):256*(counter+1)) = hst';
            counter=counter+1;
        end
    end

end


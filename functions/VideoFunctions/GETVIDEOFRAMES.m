function [ frames ] = GETVIDEOFRAMES( video,frameInterval, numFrames,saveDir )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ischar(video) == 1
    videoObj = vision.VideoFileReader(video);
else     
    videoObj = video;
end

[~, vidName] = fileparts(videoObj.Filename);

if nargin < 3
    error('Too few arguments - have to be 3 or 4');
end

if nargin == 3
    saveImages = false;
else
    saveImages = true;
end


if numFrames > 0
    frames = cell(numFrames,1);
    for i=1:numFrames
        for j=1:frameInterval
            step(videoObj);
        end
        tempFrame = step(videoObj);
        frames{i} = double(floor(255*rgb2gray(tempFrame)));
        if saveImages
            filePath = strcat(saveDir,'/',vidName,'_',int2str(i),'.jpg');
            imwrite(tempFrame,filePath,'jpg');
        end
    end
else
    frames = cell(0,1);
    counter = 1;
    while ~isDone(videoObj)
        for j=1:frameInterval
            step(videoObj);
        end
        tempFrame = step(videoObj);
        frames{counter} = double(floor(255*rgb2gray(tempFrame)));
        if saveImages
            filePath = strcat(saveDir,'/',vidName,'_',int2str(counter),'.jpg');
            imwrite(tempFrame,filePath,'jpg');
        end
        counter = counter+1;
    end
end
    


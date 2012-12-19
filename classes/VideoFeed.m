classdef VideoFeed < handle
    %VIDEOFEED Represents a video feed
    %   Detailed explanation goes here
    
    properties
        FrameInterval;                           
    end
    
    properties (SetAccess = private)
        VideoIndex;
        FileName;
        VideoObject;
    end
    
    
    methods
        function videoFeed = VideoFeed(videoFile)
            if nargin ~= 1
                error('Wrong number of arguments!');
            end
            
            if ischar(videoFile)
                videoFeed.VideoObject = VideoReader(videoFile);
            else
                videoFeed.VideoObject = videoFile;
            end
            videoFeed.FileName = videoFile;
            videoFeed.VideoIndex = 1;
            videoFeed.FrameInterval = 1;
        end
     
        function [frames idxs] = getFrame(obj, numFrames)
            if nargin < 2
                frames = read(obj.VideoObject,obj.VideoIndex);
                idxs = obj.VideoIndex;
                newIdx = obj.VideoIndex + obj.FrameInterval;
                obj.VideoIndex = newIdx;               
            else
            
                frames = cell(numFrames,1);
                idxs = zeros(numFrames,1);
                for k=1:numFrames
                    frames{k} = read(obj.VideoObject,obj.VideoIndex);
                    idxs(k) = obj.VideoIndex;
                    newIdx = obj.VideoIndex + obj.FrameInterval;
                    obj.VideoIndex = newIdx;
                    %fprintf('Changed to %d\n',obj.VideoIndex);
                end
            end
        end
        
        function bool = framesLeft(obj)
            if obj.VideoIndex + obj.FrameInterval > ...
                    obj.VideoObject.NumberOfFrames
                bool = false;
            else
                bool=true;
            end
        end
        
        function frames = getFramesAt(obj,startIndex,endIndex)
            if nargin < 3
                frames = read(obj.VideoObject,startIndex);
            else
                frames = cell(endIndex - startIndex + 1,1);
                for i=startIndex:endIndex
                    frames{i-startIndex+1} = read(obj.VideoObject,i);
                end
            end
        end
    end
    
end


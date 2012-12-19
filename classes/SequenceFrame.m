classdef SequenceFrame < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        FrameImage;
        FaceRectangles;
    end
    
    methods (Access = public)
        function seqFrame = SequenceFrame(frame, rectangles)
            seqFrame.FrameImage = frame;
            seqFrame.FaceRectangles = rectangles;
        end
        
        function faces = getFaces(obj)
            faces = cell(size(obj.FaceRectangles,1),1);
            faceRectangle = obj.FaceRectangles;
            for l=1:size(obj.FaceRectangles,1)
                faces{l} = obj.getSubImage(faceRectangle(l,:));           
            end
        end
        
        function subImage = getSubImage(obj,rectangle)
            
            subImage = ...
                obj.FrameImage((rectangle(1,2)):...
                (rectangle(1,2))+...
                rectangle(1,4),...
                (rectangle(1,1)):...
                (rectangle(1,1))+...
                rectangle(1,3));
            %imagesc(subImage);
        end
        
        function sizes = size(obj)
            sizes = size(obj.FrameImage);
        end
            
        
    end
    
end


classdef Scene < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        FrameCounter;
        Frames;
        FaceSequences;
        
        FirstFrame;
        
        ClassifierRef;
        ConfStruct;
        
        FirstFrameIdx;
        LastFrameIdx;
        
        SequenceConfiguration;
    end
    
    methods (Access = public)
        function newScene = Scene(classifier,firstFrame)
            newScene.FrameCounter = 0;
            newScene.FirstFrameIdx = firstFrame;
            newScene.Frames = cell(20,1);
            
            newScene.FirstFrame = true;
            newScene.FaceSequences = [];
            newScene.ClassifierRef = classifier;
            newScene.ConfStruct = BUILDCONFIGURATION;
            newScene.SequenceConfiguration = BUILDSEQCONFIGURATION;
        end
        
        function endScene = addSeqFrame(obj,seqFrame)
            obj.FrameCounter = obj.FrameCounter + 1;           
            newFrameIdx = obj.FrameCounter;
            
            obj.Frames{newFrameIdx} = seqFrame;
            
            if obj.FirstFrame
                faceImages = seqFrame.getFaces;
                for i=1:size(faceImages,1)
                    faceSeq = FaceSequence(i,obj.ClassifierRef);
                    faceSeq.addFace(faceImages{i});
                    %imagesc(faceImages{i});
                    newSeqRow = cell(1,3);
                    newSeqRow{1,1} = faceSeq;
                    newSeqRow{1,2} = seqFrame.FaceRectangles(i,:);
                    newSeqRow{1,3} = seqFrame.FaceRectangles(i,:);
                    newSeqRow{1,4} = ...
                                obj.SequenceConfiguration.maxMissedFrames;
                    obj.FaceSequences = [obj.FaceSequences ; newSeqRow];
                end
                obj.FirstFrame = false;
                endScene = false;
            else %Not the first frame
                
                %iterate through face sequences and look for
                %faces in the magnified rectangles
                endScene = true;
                for k=1:size(obj.FaceSequences,1)
                    
                    framesLeft = obj.FaceSequences{k,4};
                    if framesLeft == 0 %Can't miss more frames
                        obj.FaceSequences{k,3} = -1;
                        continue;
                    end
                    
                    endScene = false;
                    
                    if framesLeft == ...
                            obj.SequenceConfiguration.maxMissedFrames
                        
                        subFrame = obj.getNeighborHood(...
                        [obj.FaceSequences{k,2}],size(seqFrame));
                        obj.FaceSequences{k,3} = subFrame;
                    else
                        subFrame = obj.FaceSequences{k,3};
                    end
                    
                    offsets = [subFrame(1) subFrame(2)];
                   
                    subImage = seqFrame.getSubImage(subFrame);

                    %imshow(subImage);
                    rectangle = FaceDetect2Mex(which(obj.ConfStruct.cascadeFile),...
                                subImage,...
                                3,... % Relaxed VJ conditions
                                obj.ConfStruct.VJscaleFactor);
                    
                    if rectangle == -1
                        fprintf('No face in subframe\n');
                        obj.FaceSequences{k,4} = framesLeft-1;
                        obj.FaceSequences{k,2} = -1;
                    else
                        fprintf('Got 1 right!!\n');
           
                        endScene = false;    
                        if size(rectangle,1) > 1
                            fprintf(strcat('Awkward...more',...
                                'than one face found in subframe\n'));
                        end
                        rectangle(1,1) = rectangle(1,1) + offsets(1);
                        rectangle(1,2) = rectangle(1,2) + offsets(2);
                        faceImage = seqFrame.getSubImage(rectangle(1,:));

                        obj.FaceSequences{k,1}.addFace(faceImage);
                        obj.FaceSequences{k,2} = rectangle;
                    end
                end                                                        
            end           
        end
        
        function displayCurrentFrame(obj)
            currFrame = obj.Frames{obj.FrameCounter};
            numSeqs = size(obj.FaceSequences,1);            
            figure('Units','normalized','Position',[0 0 1 1]);
            subplot(numSeqs,2,[1 2*numSeqs-1]);
            imshow(currFrame.FrameImage);
          %  truesize;
            hold on;
            for k=1:size(obj.FaceSequences,1)
                face = obj.FaceSequences{k,2};
                redFace = obj.FaceSequences{k,3};
                if redFace == -1
                    continue;
                end
                l=1;
                redBox = [redFace(l,1) redFace(l,2);...
                     redFace(l,1)+redFace(l,3) redFace(l,2);...
                     redFace(l,1)+redFace(l,3) redFace(l,2)+redFace(l,4);...
                     redFace(l,1)  redFace(l,2)+redFace(l,4);...
                     redFace(l,1) redFace(l,2)];
                plot (redBox(:,1), redBox(:,2), 'r');
                if face == -1
                    %obj.FaceSequences{k,3} = -1;
                    continue;
                end
                
                faceSeq = obj.FaceSequences{k,1};
                
                %faceBox = currFrame.getSubImage(faceRec);
                l=1;
                faceBox = [face(l,1) face(l,2);...
                     face(l,1)+face(l,3) face(l,2);...
                     face(l,1)+face(l,3) face(l,2)+face(l,4);...
                     face(l,1)  face(l,2)+face(l,4);...
                     face(l,1) face(l,2)];
                plot (faceBox(:,1), faceBox(:,2), 'g');
                text(face(1,1),face(1,2),...
                        num2str(...
                        faceSeq.FaceClassVector(faceSeq.LastFace)),...
                        'VerticalAlignment','top',...
                        'HorizontalAlignment','left',...
                        'FontSize',14,...
                        'Color','green');
                [prob class] = max(faceSeq.getAccumulatedProbs);
                text(face(1,1),face(1,2) + 20,...
                        strcat(num2str(class),' : ',...
                        num2str(prob)),...
                        'VerticalAlignment','top',...
                        'HorizontalAlignment','left',...
                        'FontSize',14,...
                        'Color','cyan');
                %faceSeq.displayProbabilities(k);
            end
            hold off;
            for i=1:numSeqs
                faceSeq = obj.FaceSequences{i,1};
                subplot(numSeqs,2,2*i);
                faceSeq.plotProbs;             
                               
            end
            
            %close;
            
        end
        
    end
    
    methods (Access = private)
        function enlargedRectangle = getNeighborHood(obj,rectangle,sizes)
            sizeFactor = obj.SequenceConfiguration.neighborhoodSize;
            
            newX = rectangle(1) - sizeFactor;
            if newX < 1
                newX = 1;
            end
            
            newXWidth = rectangle(3) + 2*sizeFactor;
            if newXWidth > (sizes(2) - newX)
                newXWidth = sizes(2) - newX;
            end
            
            newY = rectangle(2) - sizeFactor;
            if newY < 1
                newY = 1;
            end
            
            newYWidth = rectangle(4) + 2*sizeFactor;
            if newYWidth > sizes(1) - newY
                newYWidth = sizes(1) - newY;
            end           
            
            enlargedRectangle = [newX newY newXWidth newYWidth];
        end
        
    end
    
end


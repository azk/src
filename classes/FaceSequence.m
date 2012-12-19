classdef FaceSequence < handle
    %FaceSequence Represents a single frame sequence for a single face
    
    properties (GetAccess = private, SetAccess = private)
        
        
        CurrentIndex;
        
        
        ClassifierRef; % Reference to a classifier object
    end
    
    properties (SetAccess = private)
        uuid;
        FaceClassVector;
        FaceProbsMatrix
        LastFace;
        FacesFeatureMatrix;
        Faces;
    end
    
    properties (Dependent = true)
        NumberOfFrames
    end
    
    methods (Access = public)
        function faceSequence = FaceSequence(seqid,classifier,minSeqLength)
            faceSequence.uuid = seqid;
            faceSequence.ClassifierRef = classifier;
            if nargin < 3
                minSeqLength = 1; %Heuristic
            end
            
            faceSequence.Faces = cell(minSeqLength,1);
            faceSequence.FacesFeatureMatrix = zeros(minSeqLength,4096);
            faceSequence.FaceClassVector = zeros(minSeqLength,1);
            faceSequence.FaceProbsMatrix = [];
            faceSequence.CurrentIndex = 1;
        end
        
        function newFaceSeq = CopyAtInterval(obj,interval)          
            newFaceSeq = FaceSequence(1,[]);
            
            nextAddedIndex = 1;
            newFaceCount = 0;
            while nextAddedIndex <= obj.LastFace
                newFaceCount = newFaceCount + 1;
                newFaceSeq.Faces{newFaceCount} = ...
                    obj.Faces{nextAddedIndex};
                
                newFaceSeq.FacesFeatureMatrix(newFaceCount,:) = ...
                    obj.FacesFeatureMatrix(nextAddedIndex,:);
                
                newFaceSeq.FaceClassVector(newFaceCount,1) = ...
                    obj.FaceClassVector(nextAddedIndex);
                
                newFaceSeq.FaceProbsMatrix(newFaceCount,:) = ...
                    obj.FaceProbsMatrix(nextAddedIndex,:);                
                
                
                nextAddedIndex = nextAddedIndex + interval;
            end
            
            newFaceSeq.LastFace = newFaceCount;
        end
        
        function numFrame = NumberOfFrames.get(obj)
            numFrame = size(obj.Faces,1);
        end
        
        function newIndex = addFace(obj,newFace)
            newIndex = obj.CurrentIndex;
            obj.CurrentIndex = obj.CurrentIndex + 1;
            
            obj.Faces{newIndex} = newFace;
            imagesc(newFace);
            obj.FacesFeatureMatrix(newIndex,:) = ...
                                GETLBPVECTOR(obj.Faces{newIndex},...
                                            100,100,4);
            [obj.FaceClassVector(newIndex) ...
                obj.FaceProbsMatrix(newIndex,:)] = ...
                obj.getFaceClass(newIndex);
            
            obj.LastFace = newIndex;
            
        end
        
        function displayProbabilities(obj,seqIndex)
            figure;
            if size(obj.FaceProbsMatrix,1) > 1
                probProducts = cumprod(obj.FaceProbsMatrix);
            else
                probProducts = obj.FaceProbsMatrix;
            end
            bar(probProducts(end,:));
            hold on
            text(10,10,strcat('Sequence no. ',num2str(seqIndex),...
                '\nNumber of frames in sequence: ',...
                num2str(size(obj.FaceProbsMatrix,1))),...
            'VerticalAlignment','top',...
            'HorizontalAlignment','left',...
            'FontSize',20,...
            'Color','cyan');            
            hold off
            pause;
            close;
            
        end
        
       % function displayProbsGraph(obj)
        
        function last = getAccumulatedProbs(obj,normalize)
            if size(obj.FaceProbsMatrix,1) > 1
                probProducts = cumprod(obj.FaceProbsMatrix);
            else
                probProducts = obj.FaceProbsMatrix;
            end
            
            if nargin < 2
                normalize = false;
            end
            last = probProducts(end,:);
            if normalize
                tot = sum(last);
                last = last.\tot;
            end
            
        end
        
        function displayFaceSquare(obj)
            %numFaces = size(obj.Faces,2);
            numCols = 4;
            numRows = 4;%ceil(numFaces/numCols);
            figure;
            for i=1:size(obj.Faces,2)
                if i > 16
                    break;
                end
                subplot(numRows,numCols,i);
                imshow(obj.Faces{i});
            end
            
        end
        
        function plotProbs(obj)
            if size(obj.FaceProbsMatrix,1) > 1
                probProducts = cumprod(obj.FaceProbsMatrix);
            
                for i=1:size(probProducts,1)
                    probProducts(i,:) = ...
                        probProducts(i,:)./sum(probProducts(i,:));
                end

                plot(probProducts);
                legend('toggle');
            else

                bar(obj.FaceProbsMatrix);
            end
            
        end
        

    end
    
    methods (Access = private)
        
        function [faceClass probs] = getFaceClass(obj,frameIndex)
            faceVector = obj.FacesFeatureMatrix(frameIndex,:);
            [faceClass, ~, probs] = svmpredict(-1,...
                faceVector,...
                obj.ClassifierRef, '-b 1');
        end
        
    end
    
end


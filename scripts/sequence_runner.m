videoFeed = VideoFeed(videoObject);

confStruct = BUILDCONFIGURATION;
scenes = cell(5,1);

scenesCounter = 1;

pauseTime = 1;

sceneEnded = false;
thisFrame = [];

while videoFeed.framesLeft
    videoFeed.FrameInterval = 1;
    
    if sceneEnded
        sceneEnded = false;
    else
        [thisFrame frameIdx] = videoFeed.getFrame;
        thisFrame = rgb2gray(thisFrame);
    end
    faceRecs = FaceDetect2Mex(which(confStruct.cascadeFile),...
            thisFrame,...
            confStruct.VJminNeighbors,...
            confStruct.VJscaleFactor);
        
    if faceRecs ~= -1 %Got a face (at least one). Start a scene
        newScene = Scene(svmObject, frameIdx);
        scenes{scenesCounter} = newScene;
        scenesCounter = scenesCounter+1;
        
        seqFrame = SequenceFrame(thisFrame,faceRecs);
        newScene.addSeqFrame(seqFrame);
          newScene.displayCurrentFrame;
         
         hold on;
         text(10,10,strcat('Scene no. ',num2str(scenesCounter)),...
         'VerticalAlignment','top',...
         'HorizontalAlignment','left',...
         'FontSize',20,...
         'Color','cyan');
         
         pause;
         close;
        
        while videoFeed.framesLeft
                videoFeed.FrameInterval = 1;
                thisFrame = rgb2gray(videoFeed.getFrame);
                seqFrame = SequenceFrame(thisFrame,[]);
                sceneEnded = newScene.addSeqFrame(seqFrame);
                
                 if sceneEnded
                      imshow(thisFrame);                      pause;
                      close;
                        break;
                else
                    fprintf('Should be displaying sub frame...\n');
                     newScene.displayCurrentFrame;
                     hold on;
                     text(10,10,strcat('Scene no. ',num2str(scenesCounter)),...
                     'VerticalAlignment','top',...
                     'HorizontalAlignment','left',...
                     'FontSize',20,...
                     'Color','cyan');
                     
                     pause;%(pauseTime);
                     close;
                end
        %      end
        
        end
                
    else %No faces, just display frame and move on
          imshow(thisFrame);
         pause;
          close;
    end
    
end

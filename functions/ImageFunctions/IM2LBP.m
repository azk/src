function [ picVector ] = IM2LBP( image,confStruct )
%IM2LBP Converts an image to an LBP vector
  
    debug = confStruct.debug;
    useVJ = confStruct.useVJ;
    cascadeFile = confStruct.cascadeFile;
    
    skipLBP = confStruct.skipLBP;
    saveFaces = confStruct.saveFaces;
    faceCount = 0;
    
    dirName = strcat('/',confStruct.facesFolder,'/');
    if ischar(image)==1 %The image argument is a path to the file
        if debug == true 
            fprintf('Processing image - %s\n',image);
        end
        [picPath, picName, ~] = fileparts(image);
        picPath = strcat(picPath,dirName);
        image = imread(image);
        if ndims(image) == 3
            image = rgb2gray(image);
        end
    else
        picName = strcat('anon_',num2str(sum(image,1)));
        picPath = strcat('.',dirName);
    end
    
    if exist(picPath,'dir') == 0
        mkdir(picPath);
    end
    
    if useVJ == true
        if debug == true
            fprintf('Using VJ\n');
        end
        
        faceRectangle = FaceDetect2Mex(which(cascadeFile),...
            image,confStruct.VJminNeighbors,...
            confStruct.VJscaleFactor);
        
        if faceRectangle == -1
            fprintf('No faces detected in image %s\n',picName);
            picVector = [];
            return;
        end
        
        picVector = zeros(size(faceRectangle,1),4096);
        
        for l=1:size(faceRectangle,1)
            faceImage = image((faceRectangle(l,2)+1):...
                (faceRectangle(l,2)+1)+faceRectangle(l,4),...
                (faceRectangle(l,1)+1):(faceRectangle(l,1)+1)+...
                faceRectangle(l,3));                
    
            if debug == true
                imagesc(faceImage);
                pause;
            end
            
            if saveFaces == true
                faceCount = faceCount + 1;
                imwrite(faceImage,strcat(picPath,...
                    picName,'_',num2str(faceCount),'_face','.jpg'),'jpeg');
                
            end
            
            if skipLBP == false
                picVector(l,:) = GETLBPVECTOR(faceImage,...
                                        confStruct.picWidth,...
                                        confStruct.picHeight,...
                                        confStruct.numSubPics);
            else
                picVector = [];
            end
        end
        
    else %VJ = false
        
        if debug == true
            imagesc(image);
            pause;
        end
        
        if saveFaces == true
            imwrite(image,strcat(picPath,...
                picName,'_face_.jpg'),'jpeg');
        end        
        
        if skipLBP == false
            picVector = GETLBPVECTOR(image,...
                                    confStruct.picWidth,...
                                    confStruct.picHeight,...
                                    confStruct.numSubPics);
        else
            picVector = [];
        end
    end
    
end


conf = BUILDCONFIGURATION;
conf.useVJ = true;
conf.saveFaces = true;
conf.skipLBP = true;

directory = dir('./');

cd ../../../../../video_frames/s06e01_frames;

for i=1:size(directory,1)
    if  strcmp(directory(i).name,'.')==true ||...
        strcmp(directory(i).name,'..')==true
        continue;
    else
        [~, fileName fileExt] = fileparts(directory(i).name);
        
        conf.cascadeFile = strcat(fileName,fileExt);
        conf.facesFolder = strcat(fileName,'_faces');
        
        PICS2FEATURES('./',-1,conf);
    end
end
        
        
function [ featureMatrix labelColumn] = BUILDTRAININGSET( dirOfPicDirs, confStruct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
directory = dir(dirOfPicDirs);
[dirPath dirName ~] = fileparts(dirOfPicDirs);

featureMatrix = [];
labelColumn = [];

for i=1:size(directory,1)
    if (directory(i).isdir == false || ...
        strcmp(directory(i).name,'.')==true ||...
        strcmp(directory(i).name,'..')==true)
        continue;
    else
       fprintf('\n***Processing directory no. %d called %s***\n',i,directory(i).name);
       
       label = str2double(directory(i).name);
       if isnan(label)
           label = i;
           fprintf('Using label %d for directory %s\n',label,directory(i).name);
       end      
       
       [tempFeature tempColumn] = PICS2FEATURES(...
           strcat(dirPath,'/',dirName,'/',directory(i).name),...
           label ,confStruct); 
       fprintf('Got %d instances\n',size(tempFeature,1));
       featureMatrix = [featureMatrix;tempFeature];
       labelColumn = [labelColumn ; tempColumn];
    end
end

end


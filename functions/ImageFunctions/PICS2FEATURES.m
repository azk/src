function [ featureMatrix labelColumn ] = PICS2FEATURES( pictures, labelNum, confStruct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

picDir = dir(pictures);
[dirPath class ~] = fileparts(pictures);

featureMatrix = [];

for i=1:size(picDir,1)
    
    if picDir(i).isdir == 1
        continue;
    end
    
    imagePath = strcat(dirPath,'/',class,'/',picDir(i).name);
    picVector = IM2LBP(imagePath,confStruct);
    featureMatrix = [featureMatrix ; picVector];
end

labelColumn = zeros(size(featureMatrix,1),1);
for i=1:size(labelColumn,1)
    labelColumn(i,1) = labelNum;
end

end


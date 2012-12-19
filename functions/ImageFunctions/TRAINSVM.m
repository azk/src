function [ trainedSVM labelMap] = TRAINSVM( dirOfPicDirs, confStruct )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[featureMatrix labelColumn labelMap] = BUILDTRAININGSET(dirOfPicDirs,confStruct);
trainedSVM = svmtrain(labelColumn,featureMatrix, confStruct.svmOptions);

end
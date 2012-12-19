function [ classification ] = CLASSIFYIMAGE(svm, image ,confStruct)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
classification = [];
testVector = IM2LBP(image);

for i=1:size(testVector,1)
    
    temp = svmclassify(svm,testVector(i,:));
    classification = [classification ; temp];
end



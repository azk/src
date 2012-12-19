function [ cp ] = CROSSVALIDATE( labels, features, svmOptions )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
indices = crossvalind('Kfold',labels,10);
cp = classperf(labels);

if nargin < 3
    svmOptions = '';
end

for i=1:10
    fprintf('%s',svmOptions);
    test = (indices == i); trainS = ~test;
    tempsvm = train(labels(trainS,:),features(trainS,:),svmOptions);
    %tempsvm = svmtrain(labels(trainS,:),features(trainS,:),svmOptions);
    class = predict(labels(test,:),features(test,:),tempsvm);
    %class=svmpredict(labels(test,:),features(test,:),tempsvm);
    classperf(cp,class,test);
end

end


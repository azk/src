function [ argMap ] = PARSEVARARGS( optionStrings,defaultValues,varArguments)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

argMap = containers.Map(optionStrings,defaultValues);

if rem(length(varArguments),2) ~= 0
    fprintf('Wrong number of options, using default values\n');
    return;
end

for i=1:2:length(varArguments)
    argMap(varArguments{i}) = varArguments{i+1};
end

end


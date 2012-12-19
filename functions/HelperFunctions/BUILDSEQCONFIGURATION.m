function [ seqConf ] = BUILDSEQCONFIGURATION( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    optionStrings =   { 'maxMissedFrames'...
                        'neighborhoodSize'...
                        };
    
    defaultValues =  {  5 ...
                        50 ...
                        };

    seqConf = cell2struct(defaultValues,optionStrings,2);
    
    if rem(length(varargin),2) ~= 0
        fprintf('Wrong number of options, using default values\n');
        return;
    end
    
    for i=1:2:length(varargin)
        eval(['confStruct.' varargin{i} '=' varargin{i+1} ';']);
    end

end


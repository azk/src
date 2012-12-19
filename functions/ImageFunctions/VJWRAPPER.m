function [ rectangles ] = VJWRAPPER( func,cascadeFile,image,varargin  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    nargin = length(varargin);
    if nargin == 0
        rectangles = func(which(cascadeFile),image);
    else
        rectangles = func(which(cascadeFile),image,varargin);
    end
    
    
    
end


videoObj = VideoReader('30rock.avi');

conf = BUILDCONFIGURATION;
conf.useVJ = true;
conf.saveFaces = false;
% Read one frame at a time.
for k = 3:25:videoObj.NumberOfFrames
    frame = read(videoObj, k);
    DISPLAYCLASSIFY(frame,svm,conf);
    pause(0.5);
end
conf_vj = BUILDCONFIGURATION('useVJ','true',...
                             'saveFaces','true',...
                             'skipLBP', 'true');

conf_vj.facesFolder = strcat('faces_canny');
PICS2FEATURES('../video_frames/s06e01_frames',...
                    -1,conf_vj);
                   

                         

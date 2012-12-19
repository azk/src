function [ output_args ] = DISPLAYCLASSIFY( frame,svm,conf )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
figure(1);
imshow(frame);
truesize;
hold on;

face = VJWRAPPER(@FaceDetect,'haarcascade_frontalface_alt2.xml',mean(frame,3));
if face == -1
    return;
end

features = IM2LBP(frame,conf);

class = predict(zeros(size(features,1),1),sparse(features),svm);

fprintf('Got %d faces\n',size(face,1));
for l=1:size(face,1)
    faceRectangle = [face(l,1) face(l,2);...
                     face(l,1)+face(l,3) face(l,2);...
                     face(l,1)+face(l,3) face(l,2)+face(l,4);...
                     face(l,1)  face(l,2)+face(l,4);...
                     face(l,1) face(l,2)];
                 
    plot (faceRectangle(:,1), faceRectangle(:,2), 'g');
    text(face(l,1),face(l,2),num2str(class(l,:)),...
        	'VerticalAlignment','top',...
            'HorizontalAlignment','left',...
            'FontSize',14,...
            'Color','green');
end

hold off;
end


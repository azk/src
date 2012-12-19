% allSeqs = [];
% 
% for i=1:size(scenes,1)
%     for j=1:size(scenes{i}.FaceSequences,1)        
%         allSeqs = [allSeqs ; scenes{i}.FaceSequences{j,1}];
%     end
% end
% 
% for i=1:size(allSeqs,1)
%     allSeqs(i).displayFaceSquare;
%     pause;
%     close;
% end

seq_accuracy_matrix;
fr_seq_length  = zeros(size(framerate_vs_accuracy));
for i=1:size(framerate_vs_accuracy,1)
    for j=1:size(framerate_vs_accuracy,2)
        fr_seq_length(i,j) = framerate_vs_accuracy{i,j}(3);
    end
end

fr_probs  = zeros(size(framerate_vs_accuracy));
for i=1:size(framerate_vs_accuracy,1)
    for j=1:size(framerate_vs_accuracy,2)
        fr_probs(i,j) = framerate_vs_accuracy{i,j}(2);
    end
end

fr_class  = zeros(size(framerate_vs_accuracy));
for i=1:size(framerate_vs_accuracy,1)
    for j=1:size(framerate_vs_accuracy,2)
        fr_class(i,j) = framerate_vs_accuracy{i,j}(1);
    end
end

ground_truth_matrix = zeros(size(framerate_vs_accuracy));
for i=1:size(framerate_vs_accuracy,2)
    ground_truth_matrix(:,i) = faceSeqsGroundTruth;
end

accuracy_matrix = ground_truth_matrix == fr_class;

fr_accuracy = sum(accuracy_matrix,1)./size(accuracy_matrix,1);

seq_length_vector = fr_seq_length(:,1);

dumdum = ones(1,size(fr_seq_length,2));

one_frame_seq = cast((seq_length_vector == 1)*dumdum,'logical');
two_frame_seq = cast((seq_length_vector == 2)*dumdum,'logical');
multi_frame_seq = cast((seq_length_vector >= 3)*dumdum,'logical');

one_frame_probs = sum(fr_probs(one_frame_seq),2);
one_frame_probs = reshape(one_frame_probs,[],size(one_frame_seq,2));

one_frame_accuracy = sum(one_frame_probs)./size(one_frame_probs,1);

two_frame_probs = sum(fr_probs(two_frame_seq),2);
two_frame_probs = reshape(two_frame_probs,[],size(two_frame_seq,2));

two_frame_accuracy = sum(two_frame_probs)./size(two_frame_probs,1);

multi_frame_probs = sum(fr_probs(multi_frame_seq),2);
multi_frame_probs = reshape(multi_frame_probs,[],size(multi_frame_seq,2));

multi_frame_accuracy = sum(multi_frame_probs)./size(multi_frame_probs,1);

X = 1 : size(fr_seq_length,2);
plot(X,one_frame_accuracy,X,two_frame_accuracy,X,multi_frame_accuracy);
hold on
legend('One frame sequences', 'Two frame sequences', 'Multi frame sequences');
hold off


seq_class_accuracy = zeros(size(framerate_vs_accuracy));
just_classes = zeros(size(framerate_vs_accuracy));

for i=1:size(seq_class_accuracy,1)
    for j=1:size(seq_class_accuracy,2)
        just_classes(i,j) = framerate_vs_accuracy{i,j}(1);
    end
end

for i=1:size(seq_class_accuracy,2)
    seq_class_accuracy(:,i) = (just_classes(:,i) == short30_seqGroundTruth);
end
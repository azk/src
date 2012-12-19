framerate_vs_accuracy = cell(size(allSeqs,1),10);

for i=1:size(allSeqs,1)
    for j=1:10
        seqCopy = allSeqs(i).CopyAtInterval(j);
        seqMatrix = seqCopy.FaceProbsMatrix;
        if size(seqMatrix,1) == 1
            tot = 1;
        else
            cum = cumprod(seqMatrix);
            tot = sum(cum(end,:));
        end
        [prob class] = max(seqCopy.getAccumulatedProbs);
        framerate_vs_accuracy{i,j} = [class prob/tot seqCopy.LastFace];
    end
end
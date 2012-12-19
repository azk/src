allSeqs = [];

for i=1:size(scenes,1)
    for j=1:size(scenes{i}.FaceSequences,1)        
        allSeqs = [allSeqs ; scenes{i}.FaceSequences{j,1}];
    end
end

for i=1:size(allSeqs,1)
    allSeqs(i).displayFaceSquare;
    pause;
    close;
end
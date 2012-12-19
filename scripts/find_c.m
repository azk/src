ca2 = zeros(11,2);

for i=0:10
    cost = 2^i;
    costS = sprintf('-c %f -v 10',cost);
    cv = train(e02Labels,e02Features,costS);
    ca2(i+11,:) = [cost cv] ;
end
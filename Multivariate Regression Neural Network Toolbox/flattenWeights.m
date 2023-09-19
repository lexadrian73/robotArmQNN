function theta = flattenWeights(weights)
    numLayers = length(weights) + 1;
    theta = []; 

    for i = 2:numLayers
        W = weights{i - 1};
        theta = [theta; W(:)];
    end
end
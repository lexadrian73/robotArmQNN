function theta = reshapeTheta(weights)
numLayers = numel(weights) + 1;
theta = [];
for i = 2:numLayers
    W = weights{i - 1};
    theta = [theta; W(:)];
end
end
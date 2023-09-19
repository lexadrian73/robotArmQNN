function QNN_test_s()
% QNN_test - Prueba el modelo entrenado

    addpath('Multivariate Regression Neural Network Toolbox');
    addpath('QNN Toolbox');
    addpath('Utils');
    addpath('EV3');
    % Load net
    net = load('QNN_Trained_Model_r.mat');
    
    numEvaluations = 50;

    for i = 1:numEvaluations
        testQNN_robot_s(net.weights, net.transferFunctions, net.options, net.agent);
    end
end
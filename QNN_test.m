function QNN_test()
% QNN_test - Prueba el modelo entrenado

    addpath('Multivariate Regression Neural Network Toolbox');
    addpath('QNN Toolbox');
    addpath('Utils');
    addpath('EV3');
    % Load net
    net = load('QNN_Trained_Model_F.mat');
    
    numEvaluations = 50;
    obj            = connectRobot();
    defaultPosition(obj);
    pause(1.5);

    for i = 1:numEvaluations
        press = obj.TouchPressed(2);
        if press == 1
            break;
        else
            testQNN_robot(obj, net.weights, net.transferFunctions, net.options, net.agent);
        end
    end
end
function QNN_train_s()
    clc;
    close all;
    warning off all;
    
    % Creating an artificial neural network for Q-learning
    addpath('Multivariate Regression Neural Network Toolbox');
    addpath('QNN Toolbox');

    % Architecture of the artificial neural network
    numNeuronsLayers = [3, 27, 9];       % DEFINIR
    transferFunctions{1} = 'none';
    transferFunctions{2} = 'tanh';       % DEFINIR
    %transferFunctions{3} = 'tanh';      % DEFINIR
    transferFunctions{3} = 'purelin';
    options.reluThresh = 0;
    options.lambda = 0; % regularization term
    % SGD and online learning settings
    options.numEpochs = 10000;                    % DEFINIR
    
    % Momentum update
    options.learningRate = 0.1;                   % DEFINIR
    options.typeUpdate = 'momentum';
    options.momentum = 0.9;
    options.initialMomentum = 0.3;
    options.numEpochsToIncreaseMomentum = 25;     % DEFINIR
    
    % Window length for data smoothing
    options. W = 25;
    
    % Q-learning settings
    options.gamma   = 0.9; % Q-learning parameter  %DEFINIR
    options.epsilon = 1;   % Initial value of epsilon for the epsilon-greedy exploration %DEFINIR
    options.thao    = -2;

    % Buffer experience replay
    options.maxBufferSize    = 5000;
    options.replayBufferSize = 32;
    options.B = 100; % Initialize number of batches
    options.U = 10;  % Initialize number of updates per batch
    options.sizeBufferExperienceReplay = 5000; % DEFINIR
    
    % Agent
    agent.speedA       = 35;
    agent.speedB       = 35;
    agent.angleA       = 45;
    agent.angleB       = 40;
    agent.limit_angleA = [0, 150];  %Degrees
    agent.limit_angleB = [0, 210];  %Degrees
    
    tStart = tic;
    weights = trainQNN_s(numNeuronsLayers, transferFunctions, options, agent);
    elapsedTimeHours = toc(tStart)/3600;
    fprintf('\n Elapsed time for training: %3.3f h \n', elapsedTimeHours);
    save('QNN_Trained_Model.mat',...
         'weights', ...
         'numNeuronsLayers',...
         'transferFunctions',...
         'options',...
         'agent');
end
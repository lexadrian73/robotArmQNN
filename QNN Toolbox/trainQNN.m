function weights = trainQNN(numNeuronsLayers, transferFunctions, options, agent)
    % Connect robot
    obj = connectRobot();
    % Window length for data smoothing
    W = options.W;
    % Initial settings
    learningRate = options.learningRate;
    numEpochs    = options.numEpochs;
    % Random initialization of the weights
    theta = randInitializeWeights(numNeuronsLayers);
    %data = load('QNN_Trained_Model_r.mat');
    %theta = flattenWeights(data.weights);
    % Learning rate for training the ANN
    alpha = options.learningRate;
    % Epsilon
    epsilon0 = options.epsilon;
    epsilon  = epsilon0;
    
    if strcmp(options.typeUpdate, 'momentum') %  Momentum update
        % Setup for momentum update of the weights of the ANN
        momentum = options.initialMomentum;
        velocity = zeros( size(theta) );
        numEpochsToIncreaseMomentum = options.numEpochsToIncreaseMomentum;
    else
        error('Invalid selection for updating the weights \n');
    end
    
    % Gamma
    gamma = options.gamma;
    % Training the ANN
    cost = zeros(1, numEpochs);
    % Initializing the history of the average reward
    cumulativeEpochReward = 0;
    averageEpochReward    = zeros(1, numEpochs);
    % Distance
    distance_traveled  = zeros(1, numEpochs);
    % Maximum number of interactions allowed
    maxIterationsAllowed = 500;
    % Buffer experience replay
    maxBufferSize = options.maxBufferSize;
    bufferExperienceReplay = cell(maxBufferSize, 1);
    bufferIndex   = 1;
    % Expected values
    valuesA    = [0, 45, 90, 135];
    toleranceA = 10;
    valuesB    = [0, 40, 80, 120, 160, 200];
    toleranceB = 10;
    
    for epoch = 1:numEpochs
        defaultPosition(obj);
        pause(1.5);
        % State
        state = stateRobot(obj);

        % Interaction of robot with the enviroment
        agentOn = true; % Indicator of reaching a final state
        cumulativeGameReward = 0;
        cumulativeDistance   = 0;
        numIteration         = 0;
        
        dataX = zeros(maxIterationsAllowed, 3);
        dataY = zeros(maxIterationsAllowed, 9);
        while agentOn
            numIteration = numIteration + 1;
    
            % Reshaping the weights of the ANN
            weights = reshapeWeights(theta, numNeuronsLayers);
            X = state2vec(state);
            
            if rand > epsilon
                % Predicting the response of the ANN for the current state
                [~, A] = forwardPropagation(X, weights,...
                transferFunctions, options);
                Qval = A{end}(:, 2:end);
                possible_actions_array = possibleActions(state, agent);
                [maxQ, ~] = max(Qval(possible_actions_array));
                idx = find(Qval == maxQ);    
            else
                possible_actions_array = possibleActions(state, agent);
                idx = possible_actions_array(randi(length(possible_actions_array)));
            end

            % Taking the selected action
            action_value = idx;
            action(obj, action_value, agent);
            
            % Getting the new state
            new_state    = stateRobot(obj);
            new_state(2) = estimatedValue(new_state(2), valuesA, toleranceA);
            new_state(3) = estimatedValue(new_state(3), valuesB, toleranceB);

            % Getting the reward for the new state
            reward = rewardRobot(obj, state(1), new_state(1));
            if numIteration == maxIterationsAllowed
                reward = -10;
            end
    
            % Cumulative reward so far for the current episode
            cumulativeGameReward = cumulativeGameReward + reward;

            % Cumulative distance
            if (state(1) - new_state(1)) >= -2.0 && (state(1) - new_state(1)) <= 2.0
                cumulativeDistance = cumulativeDistance + 0;
            else
                cumulativeDistance = cumulativeDistance + (state(1) - new_state(1));
            end

            bufferExperienceReplay{bufferIndex} = {state2vec(state), action_value, reward, state2vec(new_state)};
            bufferIndex = bufferIndex + 1;
            if bufferIndex > maxBufferSize
                bufferIndex = 1;
            end

            % Q-Learning Algorithm
            % Getting the value of Q(s, a)
            [~, A]   = forwardPropagation(X, weights,...
                transferFunctions, options);
            old_Qval = A{end}(:, 2:end);
    
            % Getting the value of max_a'{Q(s', a')}
            [~, A]   = forwardPropagation(state2vec(new_state), weights,...
                transferFunctions, options);
            new_Qval = A{end}(:, 2:end);
            maxQval  = max(new_Qval);
            
            % Computation of the target
            if (reward ~= 10)
                % Target for a non-terminal state
                target = reward + gamma * maxQval;
            else
                % Target for a terminal state
                target = reward;
            end
    
            if numIteration == maxIterationsAllowed
                agentOn = false;
            elseif new_state(1) <= 6.0
                agentOn = false;
            end
    
            % Data for training the ANN
            dataX(numIteration, :) = X;
            dataY(numIteration, :) = old_Qval;
            dataY(numIteration, action_value) = target;
            
            % Updating the state
            state = new_state;
        end

        dataXN = dataX(1:numIteration, :);
        dataYN = dataY(1:numIteration, :);

        for b = 1:options.U
            batchSize    = 32;
            batch_size   = min(bufferIndex - 1, batchSize);
            batchIndices = randperm(bufferIndex - 1, batch_size);
            batch_       = bufferExperienceReplay(batchIndices);

            for i = 1:batch_size
                experience  = batch_{i};
                s_i   = experience{1};
                a_i   = experience{2};
                r_i   = experience{3};
                s_t_i = experience{4};
            
                [~, A] = forwardPropagation(s_i, weights, transferFunctions, options);
                Qval = A{end}(:, 2:end);
                
                [~, A_new] = forwardPropagation(s_t_i, weights, transferFunctions, options);
                Qval_new = A_new{end}(:, 2:end);
                maxQval_new = max(Qval_new);
                
                if r_i ~= 10
                    % Target for a non-terminal state
                    target = r_i + gamma * maxQval_new;
                else
                    % Taget for a terminal state
                    target = r_i;
                end
       
                dataXN(i, :)   = s_i;
                dataYN(i, :)   = Qval;
                dataYN(i, a_i) = target;
            end
             % Updating the weights
            [cost(epoch), gradient] = regressionNNCostFunction(dataXN, dataYN,...
                numNeuronsLayers,...
                theta,...
                transferFunctions,...
                options);
            % Updating the weights of the ANN
            if strcmp(options.typeUpdate, 'momentum') %  Momentum update
                % Increase momentum after momIncrease iterations
                if epoch == numEpochsToIncreaseMomentum
                    momentum = options.momentum;
                end
                velocity = momentum * velocity + alpha * gradient;
                theta = theta - velocity;
                % Annealing the learning rate
                alpha = learningRate * exp(-5 * epoch/numEpochs);
            else
                error('Invalid selection for updating the weights \n');
            end
        end

        % Cumulative reward of all the past episodes
        cumulativeEpochReward = cumulativeEpochReward + cumulativeGameReward;
        % History of the rewards for each episode
        averageEpochReward(epoch) = cumulativeEpochReward/epoch;
        % Distance
        distance_traveled(epoch)  = cumulativeDistance;
    
        fprintf('Epoch: %d of %d, cost = %3.2f,  distance = %.2f, epsilon = %1.2f, Qval = [%3.2f, %3.2f, %3.2f, %3.2f, %3.2f, %3.2f, %3.2f, %3.2f, %3.2f] \n',...
            epoch, numEpochs, cost(epoch), distance_traveled(epoch), epsilon, old_Qval(1), old_Qval(2), old_Qval(3), old_Qval(4), old_Qval(5), old_Qval(6), old_Qval(7), old_Qval(8), old_Qval(9));
        % Annealing the epsilon
        if epsilon > 0.10
            epsilon = epsilon0 * exp(options.thao * epoch/numEpochs);
        end
    end
    
    % Plotting the cost function of each epoch
    figure;
    plot(1:epoch, cost(1:epoch), 'r', 'Linewidth', 1);
    hold all;
    costSmoothed = smoothData(cost(1:epoch), W);
    plot(1:epoch, costSmoothed, 'b', 'Linewidth', 1);
    hold off;
    legend('Actual values', 'Smoothed values');
    xlabel('epoch');
    ylabel('cost');
    title('Training cost vs. epochs');
    grid on;
    drawnow;

    % Plotting the distance traveled of each epoch
    figure;
    plot(1:epoch, distance_traveled, 'b', 'Linewidth', 1);
    xlabel('epoch');
    ylabel('Distance Traveled');
    title('Distance Traveled vs epochs');
    grid on;
    drawnow;

    % Reshaping the weights
    weights = reshapeWeights(theta, numNeuronsLayers);
end
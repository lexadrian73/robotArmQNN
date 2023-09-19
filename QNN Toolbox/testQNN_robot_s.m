function testQNN_robot_s(weights, transferFunctions, options, agent)
% testQNN_robot_s - Función responsable de ejecutar el test del agente utilizando la net entrenada y la simulacion.
    
    gameOn      = true;
    maxNumSteps = 100;
    stepNum     = 0;

    valuesA    = [0, 45, 90, 135];
    toleranceA = 10;
    valuesB    = [0, 40, 80, 120, 160, 200];
    toleranceB = 10;

    s_      = 10.0 + (255 - 10) * rand();
    state   = [s_, 0.0, 0.0];
    while gameOn
        stepNum = stepNum + 1;
        
        [~, A] = forwardPropagation(state2vec(state), weights, transferFunctions, options);
        Qval   = A{end}(:, 2:end);
        %possible_actions_array = possible_actions(vec2state(state), agent);
        possible_actions_array = possibleActions(state, agent);
        pause(2)
        [maxQ, ~] = max(Qval(possible_actions_array));
        idx = find(Qval == maxQ);
        action_value = idx;


        % Getting the new state
        new_state    = action_env(action_value, state, agent);
        new_state(2) = estimatedValue(new_state(2), valuesA, toleranceA);
        new_state(3) = estimatedValue(new_state(3), valuesB, toleranceB);

        if new_state(1) <= 6.0
            break;
        end

        if stepNum >= maxNumSteps
            break;
        end

        fprintf("state %s, new_state %s, distance %.2f\n", num2str(state), num2str(new_state), state(1)-new_state(1));
        state = new_state;
    end
end
function possible_actions_array = possibleActions(state, agent)
    % possibleActions - Retorna las acciones posibles dados los valores
    % del state (motorA y motorB)
    
    current_angleA = state(2);
    current_angleB = state(3);
    angleA         = agent.angleA;
    angleB         = agent.angleB;
    limit_motorA   = agent.limit_angleA;
    limit_motorB   = agent.limit_angleB;
    
    actions = {'action', 'motorA', 'motorB';
                1, 'down', 'down';
                2, 'neutral', 'down';
                3, 'up', 'down';
                4, 'down', 'neutral';
                5, 'neutral', 'neutral';
                6, 'up', 'neutral';
                7, 'down', 'up';
                8, 'neutral', 'up';
                9, 'up', 'up'};
    
    
    condiciones_motorA = {};
    condiciones_motorB = {};
    
    %up motorA
    if ((current_angleA - angleA) >= limit_motorA(1))
        condicion_motorA   = 'up';
        condiciones_motorA = [condiciones_motorA; condicion_motorA];
    end
    
    %down motorA
    if ((current_angleA + angleA) <= limit_motorA(2))
        condicion_motorA   = 'down';
        condiciones_motorA = [condiciones_motorA; condicion_motorA];
    end
    
    %neutral motorA
    if (current_angleA >= limit_motorA(1) && current_angleA <= limit_motorA(2))
        condicion_motorA   = 'neutral';
        condiciones_motorA = [condiciones_motorA; condicion_motorA];
    end
    
    %up motorB
    if ((current_angleB - angleB) >= limit_motorB(1))
        condicion_motorB   = 'up';
        condiciones_motorB = [condiciones_motorB; condicion_motorB];
    end
    
    %down motorB
    if ((current_angleB + angleB) <= limit_motorB(2))
        condicion_motorB   = 'down';
        condiciones_motorB = [condiciones_motorB; condicion_motorB];
    end
    
    %neutral motorB
    if (current_angleB >= limit_motorB(1) && current_angleB <= limit_motorB(2))
        condicion_motorB   = 'neutral';
        condiciones_motorB = [condiciones_motorB; condicion_motorB];
    end
    
    possible_acts = find(ismember(actions(2:end, 2), condiciones_motorA) & ...
                         ismember(actions(2:end, 3), condiciones_motorB)) + 1;
    
    possible_actions_array = cell2mat(actions(possible_acts, 1));
    %disp(possible_actions_array);
end

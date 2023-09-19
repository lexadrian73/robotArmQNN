function new_state = action_env(action, state, agent)
% action - Ejecuta una determinada acción del robot
    
    angleA  = agent.angleA;
    angleB  = agent.angleB;
    angle_A = state(2);
    angle_B = state(3);
   
    switch action
        case 1
            % downA downB 
            %disp("Action 1");
            angle_A = state(2) + angleA;
            angle_B = state(3) + angleB;
    
        case 2
            % neutralA downB
            %disp("Action 2");
            angle_B = state(3) + angleB;
    
        case 3
            % upA downB
            %disp("Action 3");
            angle_A = state(2) - angleA;
            angle_B = state(3) + angleB;
        
        case 4
            % downA neutralB
            %disp("Action 4");
            angle_A = state(2) + angleA;
            
        case 5
            % neutralA neutralB
            %disp("Action 5");
        
        case 6
            % upA neutralB
            %disp("Action 6");
            angle_A = state(2) - angleA;
    
        case 7
            % downA upB
            %disp("Action 7");
            angle_A = state(2) + angleA;
            angle_B = state(3) - angleB;
            
        case 8
            % neutral up
            %disp("Action 8");
            angle_B = state(3) - angleB;
            
        case 9
            % up up
            %disp("Action 9");
            angle_A = state(2) - angleA;
            angle_B = state(3) - angleB;
            
        otherwise
            fprintf('Error: Acción no válida.\n');
    end
    sensor = ultrasonic_sensor_env(action, state);
    if state(2) ~= 0 && state(3) ~= 0
        if randi([1, 2]) == 1
            % Ruido
            min_value_sensor = -0.2;
            max_value_sensor =  0.2;
            ruido_sensor = (max_value_sensor - min_value_sensor) * rand() + min_value_sensor;
            min_value_angle = -3.0; 
            max_value_angle =  3.0;
            ruido_angleA = randi([min_value_angle, max_value_angle]);
            ruido_angleB = randi([min_value_angle, max_value_angle]);
            new_state = [sensor + ruido_sensor, angle_A +  ruido_angleA, angle_B + ruido_angleB];
        else
            new_state = [sensor, angle_A, angle_B];
        end
    else
        new_state = [sensor, angle_A, angle_B];
    end
end
function action(obj, action, agent)
% action - Ejecuta una determinada acción del robot

    angleA = agent.angleA;
    angleB = agent.angleB;
    speedA = agent.speedA;
    speedB = agent.speedB;

    switch action
        case 1
            % downA downB 
            disp("Action 1");
            obj.MoveMotorAngleRel('A', speedA, angleA, 'Brake');
            pause(1/3);
            obj.MoveMotorAngleRel('B', speedB, angleB, 'Brake');
            pause(1/3);
        case 2
            % neutralA downB
            disp("Action 2");
            obj.MoveMotorAngleRel('B', speedB, angleB, 'Brake');
            pause(1/3);
        case 3
            % upA downB
            disp("Action 3");
            obj.MoveMotorAngleRel('A', speedA, -angleA, 'Brake');
            pause(1/3);
            obj.MoveMotorAngleRel('B', speedB,  angleB, 'Brake');
            pause(1/3);
        case 4
            % downA neutralB
            disp("Action 4");
            obj.MoveMotorAngleRel('A', speedA, angleA, 'Brake');
            pause(1/3);
        case 5
            % neutralA neutralB
            disp("Action 5");
        case 6
            % upA neutralB
            disp("Action 6");
            obj.MoveMotorAngleRel('A', speedA, -angleA, 'Brake');
            pause(1/3);
        case 7
            % downA upB
            disp("Action 7");
            obj.MoveMotorAngleRel('A', speedA,  angleA, 'Brake');
            pause(1/3);
            obj.MoveMotorAngleRel('B', speedB, -angleB, 'Brake');
            pause(1/3);
        case 8
            % neutral up
            disp("Action 8");
            obj.MoveMotorAngleRel('B', speedB, -angleB, 'Brake');
            pause(1/3);
        case 9
            % up up
            disp("Action 9");
            obj.MoveMotorAngleRel('A', speedA, -angleA, 'Brake');
            pause(1/3);
            obj.MoveMotorAngleRel('B', speedB, -angleB, 'Brake');
            pause(1/3);
        otherwise
            fprintf('Error: Acción no válida.\n');
    end
    
end
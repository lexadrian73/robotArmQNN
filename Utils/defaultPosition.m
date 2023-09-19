function defaultPosition(obj)
    % defaultPosition - Establece la posición inicial de los ángulos del agente
    
    state_real = stateRobot(obj);
    speedA     = 20;
    speedB     = 20;
    
    obj.MoveMotorAngleRel('A', speedA, -state_real(2), 'Brake');
    pause(1.5);
    obj.MoveMotorAngleRel('B', speedB, -state_real(3), 'Brake');
    pause(1.5);
end


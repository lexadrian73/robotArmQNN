function state = stateRobot(obj)
    % state -Funcion para obtener la posicion actual del agente
    
    try
        sensor = double(obj.UltrasonicDist(1));
        motorA = double(obj.GetMotorAngle('A'));
        motorB = double(obj.GetMotorAngle('B'));
        state  = [sensor, motorA, motorB];
    catch
        state = [];
    end
end
function reward = rewardRobot(obj, prev_sensor, current_sensor)
% rewardRobot - Retorno la recompensa del agente.

    current_sensor_2 = obj.UltrasonicDist(1);
    m_current_sensor = mean([current_sensor, current_sensor_2]);
    if (m_current_sensor <= 6.0)
        reward = 10;
    elseif ((prev_sensor - current_sensor) >= 2.0)
        reward = 1;
    else
        reward = -1;
    end
end
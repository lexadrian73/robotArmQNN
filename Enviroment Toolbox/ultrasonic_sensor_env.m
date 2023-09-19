function sensor_new = ultrasonic_sensor_env(action, state)

    if action == 8 && state(2) == 135 && state(3) == 200
        sensor_new = state(1) - 2.5;
    elseif action == 7 && state(2) == 90 && state(3) == 200
        sensor_new = state(1) - 2;
    else
        sensor_new = state(1);
    end
end
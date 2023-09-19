function new_state = vec2state(state)
    % new_state - Transforma el estado a la representación original

    try
        sensor    = double(state(1)) * 100;
        motorA    = rad2deg(double(state(2)));
        motorB    = rad2deg(double(state(3)));
        new_state = [sensor, motorA, motorB];
    catch
        new_state = [0.0, 0.0, 0.0];
    end
end
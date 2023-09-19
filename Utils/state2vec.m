function new_state = state2vec(state)
    % new_state - Transforma el estado a otra representación

    try
        sensor    = double(state(1)) / 100;
        motorA    = deg2rad(double(state(2)));
        motorB    = deg2rad(double(state(3)));
        new_state = [sensor, motorA, motorB];
    catch
        new_state = [0.0, 0.0, 0.0];
    end
end
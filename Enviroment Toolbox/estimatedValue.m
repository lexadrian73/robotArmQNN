function estimated_value = estimatedValue(x, values, tolerance)
% estimated_value - Retorna el valor esperado de un valor(angle) dado una tolerancia

    estimated_value = []; 
    for i = 1:length(values)
        diff = abs(x - values(i));
        if diff <= tolerance
            estimated_value = values(i);
            break;
        end
    end
    
    if isempty(estimated_value)
        estimated_value = x;
    end
end
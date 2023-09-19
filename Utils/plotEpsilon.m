function plotEpsilon()
    % plotEpsilon - Gráfica de varias funciones de epsilon
    
    epsilon0 = 1.0;
    epsilon1 = epsilon0;
    epsilon2 = epsilon0;
    numEpochs = 10000;
    
    epsilon_values1 = zeros(1, numEpochs);
    epsilon_values2 = zeros(1, numEpochs);
    maxIterationsAllowed = 20;
    
    for epoch = 1:numEpochs
        numIteration = 0;
        while numIteration < maxIterationsAllowed
            numIteration = numIteration + 1;
        end
        
        %  Exponencial
        if epsilon1 > 0.10
            epsilon1 = epsilon0 * exp(-7 * epoch / numEpochs);
        end
        
        % Lineal obtenido de: https://medium.com/data-science-in-your-pocket/deep-q-networks-dqn-explained-with-examples-and-codes-in-reinforcement-learning-928b97efa792
        if mod(epoch, 2) == 0
            epsilon2 = epsilon2 * 0.999;
        end
        
        epsilon_values1(epoch) = epsilon1;
        epsilon_values2(epoch) = epsilon2;
    end
    
    plot(1:numEpochs, epsilon_values1, 'b', 1:numEpochs, epsilon_values2, 'r');
    xlabel('Epocas');
    ylabel('Epsilon');
    legend('Epsilon', 'Temperature');
    title('Gráfica de Epsilon');
end
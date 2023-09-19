function simulate_env()

    f = uifigure('Name', 'Robot Arm Simulation', 'Position', [100, 100, 800, 600]);
    ax = uiaxes(f, 'Position', [100, 100, 600, 400]);

    l_A = 10;
    l_B = 15;

    angulo_A = 0;
    angulo_B = 0;

    x_robot = 100;

    actions = [2, 2, 1, 1, 1, 8, 9, 2, 2, 4]; 
    for i = 1:length(actions)
        action = actions(i);

        if angulo_A == 135 && angulo_B == 160 && action == 3
            x_robot = x_robot + 2.5;
        end

        switch action
            case 1
                % downA downB 
                angulo_A = angulo_A + 45;
                angulo_B = angulo_B + 40;
        
            case 2
                % neutralA downB
                angulo_B = angulo_B + 40;
        
            case 3
                % upA downB
                angulo_A = angulo_A - 45;
                angulo_B = angulo_B + 40;

            otherwise
                fprintf('Error: Acción no válida.\n');
                return;
        end

        if x_robot < 3
            x_robot = 3;
        elseif x_robot > 255
            x_robot = 255;
        end

        angulo_A_rad = deg2rad(angulo_A);
        angulo_B_rad = deg2rad(angulo_B);

        x_A = x_robot + l_A * sin(angulo_A_rad);
        y_A = l_A * cos(angulo_A_rad);
        x_B = x_A + l_B * sin(angulo_B_rad);
        y_B = y_A + l_B * cos(angulo_B_rad);

        plot(ax, [x_robot, x_A, x_B], [0, y_A, y_B], 'b-o', 'LineWidth', 2);
        title(ax, sprintf('Acción %d', action));
        axis(ax, [0 255 -30 30]);
        drawnow;

        pause(1); 
    end
end

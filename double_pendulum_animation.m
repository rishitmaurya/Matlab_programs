function double_pendulum_animation()
    % Parameters for the double pendulum
    g = 9.81;  % acceleration due to gravity (m/s^2)
    L1 = 1;    % length of the first rod (m)
    L2 = 1;    % length of the second rod (m)
    m1 = 1;    % mass of the first pendulum (kg)
    m2 = 1;    % mass of the second pendulum (kg)
    
    % Initial conditions [theta1, omega1, theta2, omega2]
    % theta: angle from the vertical, omega: angular velocity
    theta1_0 = pi/2;    % Initial angle of first pendulum (rad)
    omega1_0 = 0;       % Initial angular velocity of first pendulum (rad/s)
    theta2_0 = pi/2;    % Initial angle of second pendulum (rad)
    omega2_0 = 0;       % Initial angular velocity of second pendulum (rad/s)
    
    % Time span for the simulation
    t_span = [0 10];
    
    % Initial state vector
    y0 = [theta1_0; omega1_0; theta2_0; omega2_0];
    
    % Solve the system of differential equations using ode45
    [t, y] = ode45(@(t, y) equations_of_motion(t, y, L1, L2, m1, m2, g), t_span, y0);
    
    % Extract the angles theta1 and theta2 from the solution
    theta1 = y(:, 1);
    theta2 = y(:, 3);
    
    % Calculate positions of the pendulums
    x1 = L1 * sin(theta1);
    y1 = -L1 * cos(theta1);
    x2 = x1 + L2 * sin(theta2);
    y2 = y1 - L2 * cos(theta2);
    
    % Animation of the double pendulum
    figure;
    for i = 1:length(t)
        plot([0, x1(i)], [0, y1(i)], 'r', 'LineWidth', 2); % First rod
        hold on;
        plot([x1(i), x2(i)], [y1(i), y2(i)], 'b', 'LineWidth', 2); % Second rod
        plot(x1(i), y1(i), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % First mass
        plot(x2(i), y2(i), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); % Second mass
        axis equal;
        axis([-2 2 -2 2]);
        grid on;
        title(['Time: ', num2str(t(i), '%.2f'), ' s']);
        xlabel('X Position (m)');
        ylabel('Y Position (m)');
        pause(0.01);
        hold off;
    end
end

% Function to compute the equations of motion for the double pendulum
function dydt = equations_of_motion(~, y, L1, L2, m1, m2, g)
    theta1 = y(1);
    omega1 = y(2);
    theta2 = y(3);
    omega2 = y(4);
    
    delta_theta = theta2 - theta1;
    
    denom1 = (m1 + m2)*L1 - m2*L1*cos(delta_theta)^2;
    denom2 = (L2/L1)*denom1;
    
    % Equations of motion for the angular accelerations
    domega1_dt = (m2*L1*omega1^2*sin(delta_theta)*cos(delta_theta) + ...
                  m2*g*sin(theta2)*cos(delta_theta) + ...
                  m2*L2*omega2^2*sin(delta_theta) - ...
                  (m1+m2)*g*sin(theta1)) / denom1;
              
    domega2_dt = (-m2*L2*omega2^2*sin(delta_theta)*cos(delta_theta) + ...
                  (m1+m2)*g*sin(theta1)*cos(delta_theta) - ...
                  (m1+m2)*L1*omega1^2*sin(delta_theta) - ...
                  (m1+m2)*g*sin(theta2)) / denom2;
    
    % Return the time derivatives of theta and omega
    dydt = [omega1; domega1_dt; omega2; domega2_dt];
end

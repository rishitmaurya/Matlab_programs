clc; clear; close all;

% Step 1: Create a 30x30 grid map
gridSize = 30;
map = zeros(gridSize);  % Empty map

% Step 2: Add Obstacles
map(15, 10:20) = 1;  % First horizontal wall
map(10, 15:25) = 1;  % Second horizontal wall
map(5:10, 20) = 1;    % Vertical wall

% Step 3: Define Start and Goal Locations
startLocation = [2, 2];      % Start Location (row, col)
goalLocation = [28, 28];     % Goal Location (row, col)

% Step 4: Find Path using Dijkstra's Algorithm
path = Dijkstra(map, startLocation, goalLocation);

% Step 5: Plot the Grid, Obstacles, and Path
figure;
hold on;
imagesc(~map);
colormap(gray);
grid on;
axis equal;
title('Dijkstra Path and Differential Drive Robot Simulation');

% Mark Start and Goal
plot(startLocation(2), startLocation(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(goalLocation(2), goalLocation(1), 'bo', 'MarkerSize', 10, 'LineWidth', 2);

% Plot the Path
if ~isempty(path)
    plot(path(:,2), path(:,1), 'r', 'LineWidth', 2);
else
    disp('No Path Found!');
    return;
end

% Step 6: Simulate Differential Drive Robot on Same Figure
robotPlot = plot(startLocation(2), startLocation(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
DifferentialDriveSimulation(path);

%% Dijkstra Algorithm Function
function path = Dijkstra(grid, startNode, goalNode)
    directions = [ 0  1;  1  0;  0 -1; -1  0;  1  1;  1 -1; -1  1; -1 -1];
    
    numRows = size(grid,1);
    numCols = size(grid,2);
    
    dist = inf(numRows, numCols);
    dist(startNode(1), startNode(2)) = 0;
    visited = false(numRows, numCols);
    cameFrom = zeros(numRows, numCols, 2);
    
    pq = [startNode, 0];
    
    while ~isempty(pq)
        [~, idx] = min(pq(:,3));
        current = pq(idx, 1:2);
        pq(idx, :) = [];
        
        if isequal(current, goalNode)
            path = reconstructPath(cameFrom, current);
            return;
        end
        
        visited(current(1), current(2)) = true;
        
        for i = 1:size(directions,1)
            neighbor = current + directions(i, :);
            
            if neighbor(1) > 0 && neighbor(1) <= numRows && ...
               neighbor(2) > 0 && neighbor(2) <= numCols && ...
               grid(neighbor(1), neighbor(2)) == 0 && ...
               ~visited(neighbor(1), neighbor(2))
                
                newDist = dist(current(1), current(2)) + 1;
                if newDist < dist(neighbor(1), neighbor(2))
                    dist(neighbor(1), neighbor(2)) = newDist;
                    cameFrom(neighbor(1), neighbor(2), :) = current;
                    pq = [pq; neighbor, newDist];
                end
            end
        end
    end
    path = [];
end

%% Path Reconstruction Function
function path = reconstructPath(cameFrom, current)
    path = current;
    while any(cameFrom(current(1), current(2), :))
        current = squeeze(cameFrom(current(1), current(2), :))';
        path = [current; path];
    end
end

%% Differential Drive Simulation Function
function DifferentialDriveSimulation(path)
    wheelBase = 2;
    robotLength = 3;
    robotWidth = 2;
    dt = 0.1;
    maxSpeed = 1.0;
    
    x = path(1,2);
    y = path(1,1);
    theta = 0;
    
    hold on;
    robotBody = drawRobot(x, y, theta, robotLength, robotWidth);
    goalThreshold = 0.5;
    
    i = 2;
    while i <= size(path,1)
        xTarget = path(i,2);
        yTarget = path(i,1);
        
        thetaDesired = atan2(yTarget - y, xTarget - x);
        thetaError = mod(thetaDesired - theta + pi, 2*pi) - pi;
        
        v = min(maxSpeed, sqrt((xTarget - x)^2 + (yTarget - y)^2) / dt);
        Kp = 2.0;
        omega = Kp * thetaError;
        
        vL = v - omega * wheelBase / 2;
        vR = v + omega * wheelBase / 2;
        
        theta = theta + omega * dt;
        x = x + v * cos(theta) * dt;
        y = y + v * sin(theta) * dt;
        
        updateRobot(robotBody, x, y, theta, robotLength, robotWidth);
        pause(0.1);
        
        if sqrt((xTarget - x)^2 + (yTarget - y)^2) < goalThreshold
            i = i + 1;
        end
    end
    
    plot(x, y, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
end

%% Function to Draw the Robot
function robotBody = drawRobot(x, y, theta, length, width)
    bodyX = [-length/2, length/2, length/2, -length/2];
    bodyY = [-width/2, -width/2, width/2, width/2];
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    transformedBody = R * [bodyX; bodyY];
    robotBody = patch(transformedBody(1,:) + x, transformedBody(2,:) + y, 'b');
end

%% Function to Update Robot's Position
function updateRobot(robotBody, x, y, theta, length, width)
    bodyX = [-length/2, length/2, length/2, -length/2];
    bodyY = [-width/2, -width/2, width/2, width/2];
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    transformedBody = R * [bodyX; bodyY];
    set(robotBody, 'XData', transformedBody(1,:) + x, 'YData', transformedBody(2,:) + y);
end

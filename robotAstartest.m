clc; clear; close all;

% Step 1: Create a Binary Occupancy Map (30x30 grid)
map = binaryOccupancyMap(30, 30, 1); % Map size: 30x30, Resolution: 1 cell per unit

% Step 2: Add Obstacles (Manually Placing Blocks)
% Set occupied locations (1 = obstacle, 0 = free space)
% setOccupancy(map, [10:20; repmat(15,1,11)]', 1);  % Horizontal wall
setOccupancy(map, [15:25; repmat(10,1,11)]', 1);  % Another horizontal wall
setOccupancy(map, [5:10; repmat(20,1,6)]', 1);    % Vertical wall

% % Step 1: Create a Binary Occupancy Map (30x30 grid)
% map = binaryOccupancyMap(30, 30, 1); % Map size: 30x30, Resolution: 1 cell per unit
% 
% % Step 2: Add New Obstacle Shapes and Orientations
% 
% % % L-Shaped Obstacle
% % L_Horizontal = [10:14; repmat(8,1,5)]'; % Horizontal part
% % L_Vertical = [repmat(14,1,5); 8:12]';   % Vertical part
% % setOccupancy(map, L_Horizontal, 1);
% % setOccupancy(map, L_Vertical, 1);
% 
% % Diagonal Barrier
% Diagonal = [20 21 22 23 24 25; 5 6 7 8 9 10]';
% setOccupancy(map, Diagonal, 1);
% 
% % % Cluster of Small Blocks
% % Cluster = [16 16 17 18 19; 24 25 24 25 24]';
% % setOccupancy(map, Cluster, 1);
% 
% % Random Obstacles
% Random_Obstacles = [5 10 15 20 25; 15 20 25 10 5]';
% setOccupancy(map, Random_Obstacles, 1);

% Step 3: Inflate Obstacles for Safety Margin
inflate(map, 2);  % Increase the inflation to ensure the robot does not pass too close

% Step 4: Define Start and Goal Locations
startLocation = [2, 2];      % Robot Start Location
goalLocation = [28, 28];     % Goal Location

% Step 5: Create an A* Path Planner
planner = plannerAStarGrid(map);

% Ensure a valid obstacle-free path
validPathFound = false;

while ~validPathFound
    path = plan(planner, startLocation, goalLocation); % Generate path
    
    % Check if any point in the path intersects with an obstacle
    isObstacleInPath = any(checkOccupancy(map, path));

    if ~isObstacleInPath
        validPathFound = true; % Path is valid, exit loop
    else
        disp('Path intersects with obstacles. Replanning...');
    end
end

disp('Valid path found!');

% Step 6: Create a Differential Drive Robot Model
robotRadius = 0.5;
robot = differentialDriveKinematics("TrackWidth", 1, "WheelRadius", 0.5);

% Step 7: Display the Map, Start, Goal, and Path
figure;
show(map);
hold on;
plot(startLocation(1), startLocation(2), 'go', 'MarkerSize', 10, 'LineWidth', 2); % Green - Start
plot(goalLocation(1), goalLocation(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);   % Red - Goal
plot(path(:,1), path(:,2), 'b', 'LineWidth', 2); % A* Path in Blue

% Step 8: Place the Robot at the Initial Location
initialPose = [startLocation(1), startLocation(2), 0]; % [x, y, theta]
robotBody = plotTransforms([initialPose(1:2), 0], eul2quat([0 0 initialPose(3)]), ...
    "MeshFilePath", "groundvehicle.stl", "Parent", gca, "View", "2D");

title('A* Path Planning for Differential Drive Robot');
hold off;

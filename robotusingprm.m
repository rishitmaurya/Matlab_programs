path = [2.00    1.00;
        1.25    1.75;
        5.25    8.25;
        7.25    8.75;
        11.75   10.75;
        12.00   10.00];

robotInitialLocation = path(1,:);
robotGoal = path(end,:);

initialOrientation = 0;

robotCurrentPose = [robotInitialLocation initialOrientation]';

robot = differentialDriveKinematics("TrackWidth", 1, "VehicleInputs", "VehicleSpeedHeadingRate");

figure
plot(path(:,1), path(:,2),'k--d')
xlim([0 13])
ylim([0 13])

controller = controllerPurePursuit;

controller.Waypoints = path;

controller.DesiredLinearVelocity = 1;

controller.MaxAngularVelocity = 5;

controller.LookaheadDistance = 0.3;

goalRadius = 0.1;
distanceToGoal = norm(robotInitialLocation - robotGoal);

% Initialize the simulation loop
sampleTime = 0.1;
vizRate = rateControl(1/sampleTime);

% Initialize the figure
figure

% Determine vehicle frame size to most closely represent vehicle with plotTransforms
frameSize = robot.TrackWidth/0.8;

while( distanceToGoal > goalRadius )
    
    % Compute the controller outputs, i.e., the inputs to the robot
    [v, omega] = controller(robotCurrentPose);
    
    % Get the robot's velocity using controller inputs
    vel = derivative(robot, robotCurrentPose, [v omega]);
    
    % Update the current pose
    robotCurrentPose = robotCurrentPose + vel*sampleTime; 
    
    % Re-compute the distance to the goal
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal(:));
    
    % Update the plot
    hold off
    
    % Plot path each instance so that it stays persistent while robot mesh
    % moves
    plot(path(:,1), path(:,2),"k--d")
    hold all
    
    % Plot the path of the robot as a set of transforms
    plotTrVec = [robotCurrentPose(1:2); 0];
    plotRot = axang2quat([0 0 1 robotCurrentPose(3)]);
    plotTransforms(plotTrVec', plotRot, "MeshFilePath", "groundvehicle.stl", "Parent", gca, "View","2D", "FrameSize", frameSize);
    light;
    xlim([0 13])
    ylim([0 13])
    
    waitfor(vizRate);
end

% clc; clear; close all;

% Step 1: Create a Binary Occupancy Map (30x30 grid)
map = binaryOccupancyMap(30, 30, 1); % Map size: 30x30, Resolution: 1 cell per unit

% Step 2: Add Obstacles (Manually Placing Blocks)
% Set occupied locations (1 = obstacle, 0 = free space)
% setOccupancy(map, [10:20; repmat(15,1,11)]', 1);  % Horizontal wall















































setOccupancy(map, [15:25; repmat(10,1,11)]', 1);  % Another horizontal wall
% setOccupancy(map, [5:10; repmat(20,1,6)]', 1);    % Vertical wall

% Step 3: Inflate Obstacles to Make Navigation Harder
inflate(map, 1); % Expands obstacles to prevent close collision

% Step 4: Display the Map with Obstacles
figure;
show(map);
title('Binary Occupancy Map with Obstacles');

% Step 5: Set Up PRM Path Planner
prm = robotics.PRM(map);
prm.NumNodes = 100;         % Number of random nodes
prm.ConnectionDistance = 10; % Max distance to connect nodes

% Step 6: Define Start & Goal Locations
startLocation = [2, 2];  % Start point
goalLocation = [28, 28]; % Goal point

% Step 7: Compute and Display the Path
path = findpath(prm, startLocation, goalLocation);

% Display PRM with Path
figure;
show(prm);
hold on;
plot(path(:,1), path(:,2), 'r', 'LineWidth', 2);
scatter(startLocation(1), startLocation(2), 100, 'go', 'filled'); % Start point
scatter(goalLocation(1), goalLocation(2), 100, 'ro', 'filled');   % Goal point
title('PRM Path Planning on Occupancy Map');





release(controller);
controller.Waypoints = path;

robotInitialLocation = path(1,:);
robotGoal = path(end,:);

initialOrientation = 0;

robotCurrentPose = [robotInitialLocation initialOrientation]';

distanceToGoal = norm(robotInitialLocation - robotGoal);

goalRadius = 0.1;

reset(vizRate);

% Initialize the figure
figure

while( distanceToGoal > goalRadius )
    
    % Compute the controller outputs, i.e., the inputs to the robot
    [v, omega] = controller(robotCurrentPose);
    
    % Get the robot's velocity using controller inputs
    vel = derivative(robot, robotCurrentPose, [v omega]);
    
    % Update the current pose
    robotCurrentPose = robotCurrentPose + vel*sampleTime; 
    
    % Re-compute the distance to the goal
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal(:));
    
    % Update the plot
    hold off
    show(map);
    hold all

    % Plot path each instance so that it stays persistent while robot mesh
    % moves
    plot(path(:,1), path(:,2),"k--d")
    
    % Plot the path of the robot as a set of transforms
    plotTrVec = [robotCurrentPose(1:2); 0];
    plotRot = axang2quat([0 0 1 robotCurrentPose(3)]);
    plotTransforms(plotTrVec', plotRot, 'MeshFilePath', 'groundvehicle.stl', 'Parent', gca, "View","2D", "FrameSize", frameSize);
    light;
    xlim([0 30])
    ylim([0 30])
    
    waitfor(vizRate);
end


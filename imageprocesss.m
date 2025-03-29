% MATLAB program to project 3D cube vertices onto a 2D screen using basic lens formulas
% with camera position and adjusted cube position.

% Clear workspace and command window
clear; clc; close all;

% Define the vertices of the cube in 3D space (centered at origin initially)
cubeVertices = [
    -0.5 -0.5 0.5;  % Vertex 1
     0.5 -0.5 0.5;  % Vertex 2
     0.5  0.5 0.5;  % Vertex 3
    -0.5  0.5 0.5;  % Vertex 4
    -0.5 -0.5 1.5;  % Vertex 5
     0.5 -0.5 1.5;  % Vertex 6
     0.5  0.5 1.5;  % Vertex 7
    -0.5  0.5 1.5   % Vertex 8
];

% Translate the cube to a new position
% Move the cube 2 units up along the y-axis and 3 units forward along the z-axis
cubeTranslation = [0, 2, 3]; % [x, y, z]
cubeVertices = cubeVertices + cubeTranslation;

% Define the pinhole camera position
cameraPosition = [0, 0, 0]; % Camera at origin

% Pinhole camera parameters
focalLength = 2; % Distance of the pinhole from the image plane (units)

% Initialize matrix for projected points
projectedVertices = zeros(size(cubeVertices, 1), 2);

% Apply the lens formula for each vertex
for i = 1:size(cubeVertices, 1)
    % Relative position of the vertex with respect to the camera
    x_rel = cubeVertices(i, 1) - cameraPosition(1);
    y_rel = cubeVertices(i, 2) - cameraPosition(2);
    z_rel = cubeVertices(i, 3) - cameraPosition(3);
    
    % Ensure z_rel > 0 to avoid projection issues
    if z_rel > 0
        x_proj = focalLength * (x_rel / z_rel); % Projected x-coordinate
        y_proj = focalLength * (y_rel / z_rel); % Projected y-coordinate
        projectedVertices(i, :) = [x_proj, y_proj];
    else
        % If z_rel <= 0, projection is undefined (behind the camera)
        projectedVertices(i, :) = [NaN, NaN];
    end
end

% Plot the 3D cube in its translated position
figure;

% First subplot for 3D visualization
subplot(1, 2, 1); 
hold on;
grid on;
title('3D Cube in World Coordinates');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
view(3);

% Plot cube vertices in 3D
plot3(cubeVertices(:, 1), cubeVertices(:, 2), cubeVertices(:, 3), 'ro', 'MarkerSize', 8, 'LineWidth', 2);

% Connect the cube vertices with lines in 3D (forming cube edges)
% Define the cube edges based on the vertex indices
edges = [
    1 2; 2 3; 3 4; 4 1;  % Bottom face
    5 6; 6 7; 7 8; 8 5;  % Top face
    1 5; 2 6; 3 7; 4 8   % Vertical edges
];

% Plot the edges of the cube in 3D
for i = 1:size(edges, 1)
    plot3([cubeVertices(edges(i, 1), 1), cubeVertices(edges(i, 2), 1)], ...
          [cubeVertices(edges(i, 1), 2), cubeVertices(edges(i, 2), 2)], ...
          [cubeVertices(edges(i, 1), 3), cubeVertices(edges(i, 2), 3)], 'k-', 'LineWidth', 1);
end

% Highlight camera position
plot3(cameraPosition(1), cameraPosition(2), cameraPosition(3), 'b^', 'MarkerSize', 10, 'LineWidth', 2);
text(cameraPosition(1), cameraPosition(2), cameraPosition(3), ' Camera', 'VerticalAlignment', 'bottom');
hold off;

% Second subplot for 2D projection visualization
subplot(1, 2, 2); 
hold on;
axis equal;
grid on;
title('Projection of Cube Vertices onto 2D Screen');
xlabel('X (image plane)');
ylabel('Y (image plane)');

% Plot the projected vertices as red circles
plot(projectedVertices(:, 1), projectedVertices(:, 2), 'ro', 'MarkerSize', 8, 'LineWidth', 2);

% Connect the projected vertices with lines in 2D (forming projected cube edges)
for i = 1:size(edges, 1)
    plot([projectedVertices(edges(i, 1), 1), projectedVertices(edges(i, 2), 1)], ...
         [projectedVertices(edges(i, 1), 2), projectedVertices(edges(i, 2), 2)], 'k-', 'LineWidth', 1);
end

hold off;

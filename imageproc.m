% Create a figure
figure;
hold on;
grid on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D House and 2D Image Formed by Lens with Projection Lines');

% Define vertices of the house
base = [0, 0, 0; 5, 0, 0; 5, 5, 0; 0, 5, 0]; % Base (floor)
walls = [base; base(:,1:2), base(:,3) + 4];  % Walls (4 units high)
roof_peak = [2.5, 2.5, 6];                  % Roof peak

% Define faces
faces = [
    1, 2, 6, 5; % Front wall
    2, 3, 7, 6; % Right wall
    3, 4, 8, 7; % Back wall
    4, 1, 5, 8; % Left wall
    5, 6, 7, 8; % Top flat roof
];
roof_faces = [5, 6, 9; 6, 7, 9; 7, 8, 9; 8, 5, 9]; % Roof triangles

% Plot base (floor)
fill3(base(:,1), base(:,2), base(:,3), 'k', 'FaceAlpha', 0.5);

% Plot walls
for i = 1:size(faces, 1)
    patch('Vertices', walls, 'Faces', faces(i,:), 'FaceColor', 'blue', 'EdgeColor', 'k');
end

% Plot roof
roof_vertices = [walls; roof_peak];
for i = 1:size(roof_faces, 1)
    patch('Vertices', roof_vertices, 'Faces', roof_faces(i,:), 'FaceColor', 'red', 'EdgeColor', 'k');
end

% Add a door
door = [1.5, 0, 0; 3.5, 0, 0; 3.5, 0, 2; 1.5, 0, 2];
fill3(door(:,1), door(:,2), door(:,3), [0.6, 0.3, 0.1]);

% Add windows
window = [0.5, 3, 1; 1.5, 3, 1; 1.5, 3, 2; 0.5, 3, 2];
fill3(window(:,1), window(:,2), window(:,3), [0, 1, 1]);

% Add a lens (transparent rectangle) in front of the house
lens = [0, -4, 0; 5, -4, 0; 5, -4, 6; 0, -4, 6];
fill3(lens(:,1), lens(:,2), lens(:,3), [0, 0.7, 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% Simulate image formation on a plane (2D projection through lens)
projection_plane_y = -8; % Projection plane position
magnification = 0.8;     % Magnification factor

% Project vertices of house components
project_vertex = @(v) [v(:,1), projection_plane_y * ones(size(v,1),1), v(:,3)] * magnification;

projected_base = project_vertex(base);
projected_walls = project_vertex(walls);
projected_roof = project_vertex(roof_vertices);
projected_door = project_vertex(door);
projected_window = project_vertex(window);

% Plot the projected house (2D image)
fill3(projected_base(:,1), projected_base(:,2), projected_base(:,3), 'k', 'FaceAlpha', 0.5); % Projected base
for i = 1:size(faces, 1)
    patch('Vertices', projected_walls, 'Faces', faces(i,:), 'FaceColor', 'blue', 'EdgeColor', 'none');
end
for i = 1:size(roof_faces, 1)
    patch('Vertices', projected_roof, 'Faces', roof_faces(i,:), 'FaceColor', 'red', 'EdgeColor', 'none');
end
fill3(projected_door(:,1), projected_door(:,2), projected_door(:,3), [0.6, 0.3, 0.1]); % Projected door
fill3(projected_window(:,1), projected_window(:,2), projected_window(:,3), [0, 1, 1]); % Projected window

% Add projection lines from 3D house to 2D image
% Draw lines for base vertices
for i = 1:size(base, 1)
    line([base(i,1), projected_base(i,1)], ...
         [base(i,2), projected_base(i,2)], ...
         [base(i,3), projected_base(i,3)], 'Color', 'k', 'LineStyle', '--');
end

% Draw lines for roof vertices
for i = 1:size(roof_vertices, 1)
    line([roof_vertices(i,1), projected_roof(i,1)], ...
         [roof_vertices(i,2), projected_roof(i,2)], ...
         [roof_vertices(i,3), projected_roof(i,3)], 'Color', 'k', 'LineStyle', '--');
end

% Draw lines for door vertices
for i = 1:size(door, 1)
    line([door(i,1), projected_door(i,1)], ...
         [door(i,2), projected_door(i,2)], ...
         [door(i,3), projected_door(i,3)], 'Color', 'k', 'LineStyle', '--');
end

% Draw lines for window vertices
for i = 1:size(window, 1)
    line([window(i,1), projected_window(i,1)], ...
         [window(i,2), projected_window(i,2)], ...
         [window(i,3), projected_window(i,3)], 'Color', 'k', 'LineStyle', '--');
end

% Visualization settings
view(3); % Set 3D view
axis([-5, 10, -12, 7, -1, 8]); % Adjust axis limits
legend({'House', 'Lens', 'Projected Image'}, 'Location', 'northwest');

clc; clear; close all;

% Step 1: Load Binary Image (User provides an already binarized image)
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Binary Image Files'});
if filename == 0
    disp('No image selected. Exiting...');
    return;
end

% Read the binary image
binary_img = imread(fullfile(pathname, filename));

% Ensure binary image (0s and 1s)
binary_img = binary_img > 0;  

[M, N] = size(binary_img);
labeled_img = zeros(M, N); % Store object labels
current_label = 1; % Start labeling from 1

% Define 4-connected neighborhood offsets
neighbor_offsets = [-1,  0;  % Up
                     1,  0;  % Down
                     0, -1;  % Left
                     0,  1]; % Right

% Step 2: Connected Component Labeling (Flood Fill - Stack-based BFS)
for i = 1:M
    for j = 1:N
        if binary_img(i, j) == 1 && labeled_img(i, j) == 0 % Found an unvisited object pixel
            % Start flood fill
            stack = [i, j]; % Stack for flood fill
            while ~isempty(stack)
                % Extract the last element
                x = stack(end, 1);
                y = stack(end, 2);
                stack(end, :) = []; % Remove from stack

                % Ensure we are within bounds and have an unvisited object pixel
                if labeled_img(x, y) == 0
                    labeled_img(x, y) = current_label; % Label the object
                    
                    % Push all 4-connected neighbors onto the stack
                    for k = 1:4
                        new_x = x + neighbor_offsets(k, 1);
                        new_y = y + neighbor_offsets(k, 2);
                        if new_x > 0 && new_x <= M && new_y > 0 && new_y <= N && binary_img(new_x, new_y) == 1 && labeled_img(new_x, new_y) == 0
                            stack = [stack; new_x, new_y]; % Add to stack
                        end
                    end
                end
            end
            current_label = current_label + 1; % Move to next label
        end
    end
end

% Step 3: Count the Number of Objects
num_objects = current_label - 1;

% Step 4: Display Results
figure;
subplot(1,2,1), imshow(binary_img), title('Binary Image');
subplot(1,2,2), imagesc(labeled_img), title(['Segmented Objects: ', num2str(num_objects)]);
colormap(jet); colorbar;

disp(['Number of objects detected: ', num2str(num_objects)]);

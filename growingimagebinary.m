
clc; 
clear; 
close all;

% Load binary image (User can uncomment the next line to load an actual image)
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, 'Select a Binary Image');

% Check if the user selected a file
if isequal(filename, 0)
    disp('No file selected. Exiting...');
    return;
end

% Step 2: Read the selected image
imagePath = fullfile(pathname, filename);
binary_image = imread(imagePath);

% % Define a larger sample binary image manually
% binary_image = [
%     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0;
%     0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0;
%     0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0;
%     0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0;
%     0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0;
%     0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
% ];

% Define number of growth iterations
num_iterations = 50;

% Display original image
figure;
subplot(1, 2, 1);
imshow(binary_image, 'InitialMagnification', 'fit');
title('Original Image');

% Get image size
[rows, cols] = size(binary_image);

% Perform iterative modification (growing image)
for iter = 1:num_iterations
    new_image = binary_image;  % Copy of original image
    
    % Iterate over each pixel (skip borders to avoid indexing issues)
    for i = 2:rows-1
        for j = 2:cols-1
            % If current pixel is 0, check if it has any 1 in the neighborhood
            if binary_image(i, j) == 0
                % Check 8-neighborhood manually
                if binary_image(i-1, j) == 1 || binary_image(i+1, j) == 1 || ...
                   binary_image(i, j-1) == 1 || binary_image(i, j+1) == 1 || ...
                   binary_image(i-1, j-1) == 1 || binary_image(i-1, j+1) == 1 || ...
                   binary_image(i+1, j-1) == 1 || binary_image(i+1, j+1) == 1
                    new_image(i, j) = 1;  % Expand the white region
                end
            end
        end
    end
    
    % Update the binary image for the next iteration
    binary_image = new_image;
end

% Display final grown image after all iterations
subplot(1, 2, 2);
imshow(binary_image, 'InitialMagnification', 'fit');
title(['Final Image (After ' num2str(num_iterations) ' Iterations)']);


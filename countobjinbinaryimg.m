clc; % Clear the command window
clear; % Clear all variables from the workspace
close all; % Close all open figure windows

% Load binary image (User can uncomment the next line to load an actual image)
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, 'Select a Binary Image');

% Check if the user selected a file
if isequal(filename, 0)
    disp('No file selected. Exiting...');
    return; % Exit the script if no file is selected
end

% Construct the full file path
imagePath = fullfile(pathname, filename);

% Read the selected binary image
binary_image = imread(imagePath);

% Compute the Euclidean distance transform of the inverted binary image
D = bwdist(~binary_image);

% Invert the distance map to identify local minima
D = -D;

% Suppress small minima to prevent over-segmentation
D = imhmin(D, 2);

% Apply the watershed transform for segmentation
L = watershed(D);

% Ensure the background remains zero after watershed
L(~binary_image) = 0;

% Convert the labeled regions to a binary image
L = imbinarize(L);

% Remove small objects with an area less than 500 pixels
L = bwareaopen(L, 500);

% Assign random colors to different segmented regions
RGB = label2rgb(L, 'jet', 'k', 'shuffle');

% Display the segmented image with random colors
imshow(RGB);

% Identify connected components in the binary image
CC = bwconncomp(L);

% Compute the centroid of each connected component
S = regionprops(CC, 'Centroid');

% Display the number of detected cells in the title
title("Number of Cells: " + num2str(numel(S)));

% Hold the current figure for plotting centroids
hold on;

% Loop through each detected object and plot its centroid
for k = 1:numel(S)
    centroid = S(k).Centroid; % Get the centroid coordinates
    plot(centroid(1), centroid(2), 'r+', 'MarkerSize', 10, 'LineWidth', 2); % Mark the centroid with a red cross
end

% Release the hold on the current figure
hold off;

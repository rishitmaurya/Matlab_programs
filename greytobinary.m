% Step 1: Select an image file
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files (*.jpg, *.png, *.bmp, *.tif)'}, 'Select a Grayscale Image');

% Check if the user selected a file
if isequal(filename, 0)
    disp('No file selected. Exiting...');
    return;
end

% Step 2: Read the selected image
imagePath = fullfile(pathname, filename);
grayImage = imread(imagePath);

% Convert to grayscale if the image is RGB
if size(grayImage, 3) == 3
    grayImage = rgb2gray(grayImage);
end

% Step 3: Apply a custom threshold to create a binary image
threshold = 100;  % You can adjust this threshold as needed
binaryImage = grayImage > threshold;

savePath = fullfile(pathname, 'binaryimage.png');
imwrite(binaryImage, savePath);
disp(['Modified image saved to: ', savePath]);

% Get image dimensions
[rows, cols] = size(binaryImage);

% Initialize area and moment sums
area = 0;
sum_x = 0;
sum_y = 0;

% Initialize second moment variables
Mxx = 0;
Myy = 0;
Mxy = 0;

% Compute area, centroid sums, and second moments
for i = 1:rows
    for j = 1:cols
        if binaryImage(i, j) == 1  % Object pixel
            area = area + 1;   % Count object pixels
            sum_x = sum_x + j; % Sum x-coordinates
            sum_y = sum_y + i; % Sum y-coordinates
        end
    end
end

% Compute centroid coordinates
centroid_x = sum_x / area;
centroid_y = sum_y / area;

% Compute second moments relative to centroid
for i = 1:rows
    for j = 1:cols
        if binaryImage(i, j) == 1  % Object pixel
            x_rel = j - centroid_x;  % Distance from centroid (x)
            y_rel = i - centroid_y;  % Distance from centroid (y)
            
            Mxx = Mxx + y_rel^2;
            Myy = Myy + x_rel^2;
            Mxy = Mxy + x_rel * y_rel;
        end
    end
end

% Compute orientation angle θ using:
theta = 0.5 * atan2(2 * Mxy, Mxx - Myy);
theta_degrees = rad2deg(theta);  % Convert to degrees

% Compute eigenvalues of second moment matrix
trace = Mxx + Myy;
determinant = (Mxx * Myy) - (Mxy^2);
lambda1 = (trace + sqrt(trace^2 - 4*determinant)) / 2; % Larger moment
lambda2 = (trace - sqrt(trace^2 - 4*determinant)) / 2; % Smaller moment

% Compute roundedness as the ratio of the smallest to largest second moment
roundedness = lambda2 / lambda1;

% Display results in command window
fprintf('Computed Area: %d\n', area);
fprintf('Centroid (x̄, ȳ): (%.2f, %.2f)\n', centroid_x, centroid_y);
fprintf('Orientation Angle (θ): %.2f degrees\n', theta_degrees);
fprintf('Roundedness: %.4f\n', roundedness);

% Show the binary image with centroid marked
imshow(binaryImage);
title('Binary Image with Centroid and Orientation');
hold on;
plot(centroid_x, centroid_y, 'r+', 'MarkerSize', 10, 'LineWidth', 2);

% Display the area and orientation as text on the image
text(10, 20, sprintf('Area: %d', area), 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold');
text(10, 60, sprintf('Orientation: %.2f°', theta_degrees), 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold');
text(10, 100, sprintf('Centroid: (%.2f, %.2f)', centroid_x, centroid_y), 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold');
text(10, 140, sprintf('Roundedness: %.4f', roundedness), 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold');

% Compute the slope of the orientation line
slope = tan(theta);

% Format the equation of the principal axis
equation_text = sprintf('y = %.2f(x - %.2f) + %.2f', slope, centroid_x, centroid_y);

% Display the equation on the image
text(10, 180, equation_text, 'Color', 'white', 'FontSize', 12, 'FontWeight', 'bold');

% Plot orientation line
length_line = 190; % Length of orientation line
x1 = centroid_x - length_line * cos(theta);
y1 = centroid_y - length_line * sin(theta);
x2 = centroid_x + length_line * cos(theta);
y2 = centroid_y + length_line * sin(theta);
plot([x1, x2], [y1, y2], 'g-', 'LineWidth', 2);

hold off;

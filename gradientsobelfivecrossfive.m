% MATLAB Program to compute gradient magnitude and orientation using Sobel 5x5 filter (without built-in functions)

% Select an image from the user
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'});
if isequal(file,0)
    disp('User canceled the operation.');
    return;
end
imgPath = fullfile(path, file);
img = imread(imgPath);

% Convert to grayscale manually if needed
if size(img, 3) == 3
    grayImg = 0.2989 * img(:,:,1) + 0.5870 * img(:,:,2) + 0.1140 * img(:,:,3);
else
    grayImg = img;
end

grayImg = double(grayImg);

% Define Sobel 5x5 operator manually
Gx_kernel = [-2 -1 0 1 2; -3 -2 0 2 3; -4 -3 0 3 4; -3 -2 0 2 3; -2 -1 0 1 2];
Gy_kernel = [-2 -3 -4 -3 -2; -1 -2 -3 -2 -1; 0 0 0 0 0; 1 2 3 2 1; 2 3 4 3 2];

% Get image dimensions
[row, col] = size(grayImg);
Gx = zeros(row, col);
Gy = zeros(row, col);

% Apply Sobel 5x5 filter manually (without imfilter)
for i = 3:row-2
    for j = 3:col-2
        Gx(i, j) = sum(sum(Gx_kernel .* grayImg(i-2:i+2, j-2:j+2)));
        Gy(i, j) = sum(sum(Gy_kernel .* grayImg(i-2:i+2, j-2:j+2)));
    end
end

% Compute gradient magnitude
magnitude = sqrt(Gx.^2 + Gy.^2);

% Compute gradient orientation (in degrees)
orientation = atan2d(Gy, Gx);

% Normalize for display
magnitude = magnitude / max(magnitude(:));
orientation = (orientation - min(orientation(:))) / (max(orientation(:)) - min(orientation(:))); 

% Display results
figure;
subplot(1,3,1); imshow(uint8(grayImg)); title('Grayscale Image');
subplot(1,3,2); imshow(magnitude); title('Gradient Magnitude');
subplot(1,3,3); imshow(orientation); title('Gradient Orientation');

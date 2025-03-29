% MATLAB Program for Canny Edge Detection (Without Built-in Functions)

clc; clear; close all;

% Select an image from the user
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'});
if isequal(file,0)
    disp('User canceled the operation.');
    return;
end
imgPath = fullfile(path, file);
img = imread(imgPath);

% Convert to grayscale manually (if not already grayscale)
if size(img, 3) == 3
    grayImg = 0.2989 * img(:,:,1) + 0.5870 * img(:,:,2) + 0.1140 * img(:,:,3);
else
    grayImg = img;
end

grayImg = double(grayImg);

% Step 1: Apply Gaussian Smoothing
sigma = 1.4;  % Standard deviation for Gaussian filter
filterSize = 5;
[X, Y] = meshgrid(-floor(filterSize/2):floor(filterSize/2), -floor(filterSize/2):floor(filterSize/2));
GaussianFilter = exp(-(X.^2 + Y.^2) / (2 * sigma^2));
GaussianFilter = GaussianFilter / sum(GaussianFilter(:));

% Convolve with Gaussian filter manually
[row, col] = size(grayImg);
smoothedImg = zeros(row, col);
padSize = floor(filterSize / 2);
paddedImg = padarray(grayImg, [padSize padSize], 'replicate');

for i = 1:row
    for j = 1:col
        smoothedImg(i, j) = sum(sum(GaussianFilter .* paddedImg(i:i+filterSize-1, j:j+filterSize-1)));
    end
end

% Step 2: Compute Image Gradient using Sobel Operator
Gx_kernel = [-1 0 1; -2 0 2; -1 0 1];  % Sobel filter for X-direction
Gy_kernel = [-1 -2 -1; 0 0 0; 1 2 1];  % Sobel filter for Y-direction

Gx = zeros(row, col);
Gy = zeros(row, col);

% Apply Sobel filter manually
for i = 2:row-1
    for j = 2:col-1
        Gx(i, j) = sum(sum(Gx_kernel .* smoothedImg(i-1:i+1, j-1:j+1)));
        Gy(i, j) = sum(sum(Gy_kernel .* smoothedImg(i-1:i+1, j-1:j+1)));
    end
end

% Step 3: Find Gradient Magnitude at each Pixel
magnitude = sqrt(Gx.^2 + Gy.^2);

% Step 4: Find Gradient Orientation at each Pixel
orientation = atan2d(Gy, Gx);

% Step 5: Compute Laplacian along the Gradient Direction
laplacianImg = zeros(row, col);
laplacianKernel = [0 1 0; 1 -4 1; 0 1 0];  % 3x3 Laplacian Kernel

for i = 2:row-1
    for j = 2:col-1
        laplacianImg(i, j) = sum(sum(laplacianKernel .* magnitude(i-1:i+1, j-1:j+1)));
    end
end

% Step 6: Find Zero Crossings in Laplacian to find edge location
zeroCrossingImg = zeros(row, col);

for i = 2:row-1
    for j = 2:col-1
        if laplacianImg(i,j) == 0
            zeroCrossingImg(i,j) = 1;
        else
            negCount = sum(sum(laplacianImg(i-1:i+1, j-1:j+1) < 0));
            posCount = sum(sum(laplacianImg(i-1:i+1, j-1:j+1) > 0));
            
            if (negCount > 0) && (posCount > 0)
                zeroCrossingImg(i,j) = 1;  % Edge detected at zero-crossing
            end
        end
    end
end

% Display results
figure;
subplot(2,3,1); imshow(uint8(grayImg)); title('Grayscale Image');
subplot(2,3,2); imshow(uint8(smoothedImg)); title('Gaussian Smoothed Image');
subplot(2,3,3); imshow(magnitude, []); title('Gradient Magnitude');
subplot(2,3,4); imshow(orientation, []); title('Gradient Orientation');
subplot(2,3,5); imshow(laplacianImg, []); title('Laplacian Response');
subplot(2,3,6); imshow(zeroCrossingImg, []); title('Final Edge Detection');


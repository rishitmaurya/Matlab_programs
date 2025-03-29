clc; clear; close all;

% Select an image file from user
[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif','Image Files'});
if filename == 0
    disp('No image selected. Exiting...');
    return;
end

% Read the image and convert to grayscale if necessary
img = imread(fullfile(pathname, filename));
if size(img, 3) == 3
    img = rgb2gray(img);
end

img = double(img); % Convert to double for calculations
[M, N] = size(img);

% Compute the Fourier Transform manually
F = fft2(img);
F_shifted = fftshift(F); % Centering the Fourier spectrum

% Define a low-pass filter (circular mask)
D0 = 50; % Cutoff frequency (adjustable)
[X, Y] = meshgrid(1:N, 1:M);
center_x = ceil(N/2);
center_y = ceil(M/2);
D = sqrt((X - center_x).^2 + (Y - center_y).^2);

% Create low-pass filter mask
H = double(D <= D0);

% Apply the filter
F_filtered = F_shifted .* H;

% Compute the inverse Fourier Transform manually
F_inv_shifted = ifftshift(F_filtered); % Shift back
img_filtered = abs(ifft2(F_inv_shifted)); % Compute inverse FFT

% Normalize the image for proper display
img_filtered = uint8(img_filtered * 255 / max(img_filtered(:)));

% Save the modified image
savePath = fullfile(pathname, 'rishit_lowscale.jpeg');
imwrite(img_filtered, savePath);
disp(['Modified image saved to: ', savePath]);

% Display results
figure;
subplot(1, 3, 1), imshow(uint8(img)), title('Original Image');
subplot(1, 3, 2), imshow(log(1 + abs(F_shifted)), []), title('Fourier Transform');
subplot(1, 3, 3), imshow(img_filtered), title('Low-Pass Filtered Image');

disp('Low-pass filtering applied successfully.');

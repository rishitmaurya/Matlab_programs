clc; clear; close all;

% Step 1: Select an Image from the User
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Image Files'});
if filename == 0
    disp('No image selected. Exiting...');
    return;
end

% Step 2: Read and Convert the Image to Grayscale
img = imread(fullfile(pathname, filename));
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img); % Convert to double for calculations
[M, N] = size(img);

% Step 3: Compute the Fourier Transform and Shift Zero Frequency to Center
F = fft2(img);
F_shifted = fftshift(F);

% Step 4: Create a Gaussian Low-Pass Filter in Frequency Domain
D0 = 50; % Cutoff frequency (adjustable)
[X, Y] = meshgrid(1:N, 1:M);
center_x = ceil(N/2);
center_y = ceil(M/2);
D = sqrt((X - center_x).^2 + (Y - center_y).^2);

% Gaussian function: H = e^(-D^2 / (2*D0^2))
H = exp(-(D.^2) / (2 * D0^2));

% Step 5: Apply the Gaussian Filter in Frequency Domain
F_filtered = F_shifted .* H;

% Step 6: Compute the Inverse Fourier Transform
F_inv_shifted = ifftshift(F_filtered);
img_filtered = abs(ifft2(F_inv_shifted));

% Step 7: Normalize the Image for Display
img_filtered = uint8(img_filtered * 255 / max(img_filtered(:)));

% Step 8: Display the Results
figure;
subplot(1, 3, 1), imshow(uint8(img)), title('Original Image');
subplot(1, 3, 2), imshow(log(1 + abs(F_shifted)), []), title('Fourier Transform');
subplot(1, 3, 3), imshow(img_filtered), title('Gaussian Smoothed Image');

disp('Gaussian smoothing applied successfully.');

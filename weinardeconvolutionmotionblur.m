clc; clear; close all;

% Step 1: Load a Motion Blurred Image
[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif', 'Image Files'});
if filename == 0
    disp('No image selected. Exiting...');
    return;
end

% Read and convert image to grayscale
blurred_img = imread(fullfile(pathname, filename));
if size(blurred_img, 3) == 3
    blurred_img = rgb2gray(blurred_img);
end
blurred_img = double(blurred_img); % Convert to double
[M, N] = size(blurred_img);

% Step 2: Generate Motion Blur Kernel (PSF - Point Spread Function)
L = 20;  % Motion length (adjust for stronger/weaker blur)
theta = 30; % Motion direction in degrees

% Create the Motion Blur Kernel (Manually Constructed in Frequency Domain)
[X, Y] = meshgrid(1:N, 1:M);
center_x = ceil(N/2);
center_y = ceil(M/2);
D = (L * (cosd(theta) * (X - center_x) + sind(theta) * (Y - center_y))) / N;

% Manually Compute sinc(D) = sin(pi * D) / (pi * D)
sinc_D = ones(size(D)); % Initialize to 1 (for D = 0)
nonzero_indices = (D ~= 0);
sinc_D(nonzero_indices) = sin(pi * D(nonzero_indices)) ./ (pi * D(nonzero_indices));

% Create the blur kernel
H = sinc_D .^ 2;  % Squaring to approximate motion blur PSF

% Step 3: Compute Fourier Transform of the Blurred Image
F_blurred = fft2(blurred_img);
H_shifted = fftshift(H); % Shift PSF to center

% Step 4: Define NSR (Noise-to-Signal Ratio)
NSR = 0.01; % Experiment with values (lower = more sharpening, higher = noise suppression)

% Step 5: Wiener Deconvolution (Applying the Filter)
% W = (1 / H) * (|H|^2 / (|H|^2 + NSR))
H_abs_sq = abs(H_shifted).^2;
Wiener_Filter = (1 ./ H_shifted) .* (H_abs_sq ./ (H_abs_sq + NSR));

% Apply the Wiener filter in the frequency domain
F_recovered = F_blurred .* Wiener_Filter;

% Step 6: Compute Inverse Fourier Transform to obtain the restored image
recovered_img = real(ifft2(F_recovered));

% Step 7: Normalize and Convert to uint8 for Display
recovered_img = recovered_img - min(recovered_img(:)); % Shift to non-negative values
recovered_img = recovered_img / max(recovered_img(:)) * 255; % Scale to 0-255
recovered_img = uint8(recovered_img);

% Step 8: Display the Results
figure;
subplot(1, 3, 1), imshow(uint8(blurred_img)), title('Motion Blurred Image');
% subplot(1, 3, 2), imshow(log(1 + abs(fftshift(F_blurred))), []), title('Fourier Transform of Blurred Image');
subplot(1, 3, 3), imshow(recovered_img), title('Restored Image (Wiener Deconvolution)');

disp('Wiener deconvolution applied successfully.');

clc;
clear;
close all;

% Read grayscale image from user
[file, path] = uigetfile({'*.jpg;*.png;*.bmp','Image Files'}, 'Select a Grayscale Image');
if isequal(file,0)
    disp('No file selected.');
    return;
end
img = imread(fullfile(path, file));

% Convert to grayscale if not already
if size(img, 3) == 3
    img = 0.2989 * img(:,:,1) + 0.5870 * img(:,:,2) + 0.1140 * img(:,:,3);
end

img = double(img); % Convert to double for calculations

% Define motion blur kernel (PSF - Point Spread Function)
kernel_size = 15; % Length of motion blur
angle = 30; % Angle of motion blur in degrees

% Generate motion blur filter manually
kernel = zeros(kernel_size, kernel_size);
center = ceil(kernel_size / 2);
for i = 1:kernel_size
    x = round(center + (i - center) * cosd(angle));
    y = round(center + (i - center) * sind(angle));
    if x > 0 && x <= kernel_size && y > 0 && y <= kernel_size
        kernel(y, x) = 1;
    end
end
kernel = kernel / sum(kernel(:)); % Normalize kernel

% Apply convolution without built-in functions
[p, q] = size(img);
[kh, kw] = size(kernel);
pad_h = floor(kh / 2);
pad_w = floor(kw / 2);
padded_img = zeros(p + 2 * pad_h, q + 2 * pad_w);
padded_img(pad_h + 1:end - pad_h, pad_w + 1:end - pad_w) = img;
blurred_img = zeros(p, q);

for i = 1:p
    for j = 1:q
        sub_matrix = padded_img(i:i + kh - 1, j:j + kw - 1);
        blurred_img(i, j) = sum(sum(sub_matrix .* kernel));
    end
end

% Convert back to uint8 and save the image
blurred_img = uint8(blurred_img);
output_filename = fullfile(path, 'blurred_image.png');
imwrite(blurred_img, output_filename);

disp(['Blurred image saved as: ', output_filename]);

% Display original and blurred images
figure;
subplot(1,2,1); imshow(uint8(img)); title('Original Image');
subplot(1,2,2); imshow(blurred_img); title('Motion Blurred Image');

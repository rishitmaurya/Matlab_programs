% Hybrid Image Creation in MATLAB

% Read Low-Pass and High-Pass Images
low_pass_img = im2double(imread('rishit_lowscale.jpeg')); % Replace with user input
high_pass_img = im2double(imread('somesh_highscale.jpeg')); % Replace with user input

% Ensure images are grayscale and of same size
if size(low_pass_img,3) == 3
    low_pass_img = rgb2gray(low_pass_img);
end
if size(high_pass_img,3) == 3
    high_pass_img = rgb2gray(high_pass_img);
end
if size(low_pass_img) ~= size(high_pass_img)
    error('Images must be of the same size');
end

% Create Hybrid Image by Averaging
hybrid_image = (low_pass_img + high_pass_img) / 2;

% Display the Images
figure;
subplot(1,3,1); imshow(low_pass_img); title('Low-Pass Image');
subplot(1,3,2); imshow(high_pass_img); title('High-Pass Image');
subplot(1,3,3); imshow(hybrid_image); title('Hybrid Image');

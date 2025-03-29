% MATLAB program to apply median filtering on a grayscale image

% Read the grayscale image from the user
[file, path] = uigetfile({'*.jpg;*.png;*.bmp','Image Files (*.jpg, *.png, *.bmp)'});
if isequal(file,0)
    disp('User selected Cancel');
    return;
end
img = imread(fullfile(path, file));

% Convert to grayscale if the image is not already grayscale
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Display original image
figure;
subplot(1,2,1);
imshow(img);
title('Original Image');

% Apply median filtering with a 10x10 mask
filtered_img = medfilt2(img, [3 3]);

% Display filtered image
subplot(1,2,2);
imshow(filtered_img);
title('Median Filtered Image (10x10)');

% Read a grayscale image from the user
[file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
if isequal(file, 0)
    disp('User selected Cancel');
    return;
end
img = imread(fullfile(path, file));

% Convert to grayscale if not already
dimensions = size(img);
if numel(dimensions) == 3
    img = rgb2gray(img);
end

% Add salt and pepper noise to the image
noisy_img = imnoise(img, 'salt & pepper', 0.02);

% Save the noisy image
imwrite(noisy_img, 'saltpeppergreyscaleimage.png');

% Display the original and noisy images
figure;
subplot(1,2,1), imshow(img), title('Original Grayscale Image');
subplot(1,2,2), imshow(noisy_img), title('Noisy Image (Salt & Pepper)');



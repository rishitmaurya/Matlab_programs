% MATLAB Code to Convert Image to Grayscale

% Prompt user to select an image
[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
if isequal(filename, 0)
    disp('User canceled image selection.');
else
    % Read the image
    img = imread(fullfile(pathname, filename));

    % Display the original image
    figure;
    subplot(1, 2, 1);
    imshow(img);
    title('Original Image');

    % Convert to grayscale
    grayImg = rgb2gray(img);

    % Display the grayscale image
    subplot(1, 2, 2);
    imshow(grayImg);
    title('Grayscale Image');

    % Save the grayscale image
    imwrite(grayImg, 'grayscale_image.png');
    disp('Grayscale image saved as grayscale_image.png');
end

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

% Define the impulse (delta) filter
impulse_filter = [0 0 0; 0 1 0; 0 0 0];

% Apply the convolution operation
filtered_img = imfilter(img, impulse_filter, 'conv');

% Display the original and filtered images
figure;
subplot(1,2,1), imshow(img), title('Original Grayscale Image');
subplot(1,2,2), imshow(filtered_img), title('Filtered Image (Impulse Filter)');

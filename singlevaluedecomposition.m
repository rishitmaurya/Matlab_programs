% Single Value Decomposition without using built-in svd function
clc;
clear;
close all;

% Select an image from the user
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files'}, 'Select a Grayscale Image');
if isequal(file, 0)
    disp('User canceled image selection');
    return;
end

% Read and convert image to grayscale
imagePath = fullfile(path, file);
img = imread(imagePath);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if RGB
end
img = double(img);

% Get dimensions
[m, n] = size(img);

% Step 1: Compute A * A'
AAT = img * img';

% Step 2: Compute eigenvalues and eigenvectors of A * A'
[eigVec_U, eigVal_U] = eig(AAT);

% Sort eigenvalues and eigenvectors
[eigVal_U, sortIdx] = sort(diag(eigVal_U), 'descend');
eigVec_U = eigVec_U(:, sortIdx);

% Step 3: Calculate singular values
singularValues = sqrt(eigVal_U);

% Step 4: Compute V from A' * A
ATA = img' * img;
[eigVec_V, eigVal_V] = eig(ATA);

% Sort eigenvalues and eigenvectors
[eigVal_V, sortIdx] = sort(diag(eigVal_V), 'descend');
eigVec_V = eigVec_V(:, sortIdx);

% Step 5: Construct Sigma matrix (Handle rectangular images)
Sigma = zeros(m, n); % m x n matrix

% Adjust assignment for rectangular images
for i = 1:min(m, n)
    Sigma(i, i) = singularValues(i);
end

% Step 6: Compute U and V matrices
U = eigVec_U;
V = eigVec_V;

% Step 7: Reconstruct the image
reconstructedImg = U * Sigma * V';

% Display Original and Reconstructed Images
figure;
subplot(1, 2, 1);
imshow(uint8(img));
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(reconstructedImg));
title('Reconstructed Image using SVD');

disp('SVD Decomposition Complete');

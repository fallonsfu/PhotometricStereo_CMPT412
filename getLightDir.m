function [sx, sy, sz] = getLightDir(filename)
% Compute the light direction from an image of calibration sphere 
% iluminated by single light source

image = imread(strcat('real_images/', filename));
img = (double(image(:,:,1)) + double(image(:,:,2)) + double(image(:,:,3))) / (3*255);

centerX = 319;
centerY = 181;
radius = 138;

[focusY, focusX] = find(img == max(max(img)));
ptX = mean(focusX);
ptY = size(image, 1) - mean(focusY);

x = ptX - centerX;
y = ptY - centerY;
d = sqrt(x^2 + y^2);
z = -sqrt(radius^2 - d^2);

sx = x / radius;
sy = y / radius;
sz = z / radius;

end


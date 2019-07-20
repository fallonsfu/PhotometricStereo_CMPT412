[sx1, sy1, sz1] = getLightDir('sphere-lamp1.tif');
[sx2, sy2, sz2] = getLightDir('sphere-lamp2.tif');
[sx3, sy3, sz3] = getLightDir('sphere-lamp3.tif');

[A, B] = meshgrid(-2.2:0.01:2.2);
p = ((10.^A.*sy2-sy1).*(10.^B.*sz3-sz2)-(10.^B.*sy3-sy2).*(10.^A.*sz2-sz1))...
    ./((10.^A.*sy2-sy1).*(10.^B.*sx3-sx2)+(10.^B.*sy3-sy2).*(sx1-10.^A.*sx2));
q = (sx1.*p - 10.^A.*sx2.*p + 10.^A.*sz2 - sz1) ./ (10.^A.*sy2 - sy1);

[file1,] = uigetfile('*.tif');
[file2,] = uigetfile('*.tif');
[file3,] = uigetfile('*.tif');

image1 = imread(strcat('real_images/',file1));
image2 = imread(strcat('real_images/',file2));
image3 = imread(strcat('real_images/',file3));

img1 = (double(image1(:,:,1)) + double(image1(:,:,2)) + double(image1(:,:,3))) / (3*255);
img2 = (double(image2(:,:,1)) + double(image2(:,:,2)) + double(image2(:,:,3))) / (3*255);
img3 = (double(image3(:,:,1)) + double(image3(:,:,2)) + double(image3(:,:,3))) / (3*255);

w = size(img1, 2);
h = size(img1, 1);

img1(img1<0.1) = 0;
img2(img2<0.1) = 0;
img3(img3<0.1) = 0;

E1_E2 = log10(img1 ./ img2);
E2_E3 = log10(img2 ./ img3);

for i = 1:h
    for j = 1:w
        a = round(E1_E2(i, j), 1);
        b = round(E2_E3(i, j), 1);
        x = b * 100 + 221;
        y = a * 100 + 221;
        if a <= 2.2 & a >= -2.2 & b <= 2.2 & b >= -2.2        
            g(h-i+1, j, :) = [p(x, y), q(x,y)];
            n(h-i+1, j, :) = [p(x, y), q(x,y), -1] / sqrt(p(x, y)^2 + q(x,y)^2 + 1);
        else
            g(h-i+1, j, :) = [0, 0];
            n(h-i+1, j, :) = [0, 0, 0];
        end
    end
end

step = 10;
[x, y] = meshgrid(1:step:w, 1:step:h);
quiver(x, y, n(1:step:h, 1:step:w, 1), n(1:step:h, 1:step:w, 2));




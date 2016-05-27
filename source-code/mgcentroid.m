function [com,qom] = mgcentroid(im)
% function [com,qom] = mgcentroid(im)
% mgcentroid computes the controid of an image. If the input image contains
% rgb,three components,then it changes to gray image
% syntax:[com,qom] = mgcentroid(im)

% input: 
% im: input image

% output:
% com: centroid of the image
% qom: quantity of the image

% eg:[com,qom] = mgcentroid(im)

[m,n,c] = size(im);
if c == 3
    im = rgb2gray(im);
end
x = 1:n;
y = 1:m;
qom = sum(im(:));
mx = mean(im);
my = mean(im,2);
comx = x*mx'/sum(mx);
comy = y*my/sum(my);
com = [comx,comy];


function [bbox,aom] = findboundingbox(f)
% bbox = findboundingbox(f) 
% find the bounding box and area of motion of the image f
if size(f,3) == 3
    f = rgb2gray(f);
end
level = multithresh(f);
bw = f > level;
bw = medfilt2(bw,[3,3]);
stats = regionprops('table',bw,'BoundingBox','Area');
aom = sum(stats.Area);
stats = stats.BoundingBox;
bbox = min(stats);
[row,col] = find(bw>0);
bbox(3) = max(col) - min(col);
bbox(4) = max(row) - min(row);
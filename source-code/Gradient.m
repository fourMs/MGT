function [dx, dy, dt] = Gradient(imNew,imPrev)
% function [dx,dy,dt] = Gradient(imNew,imPrev)
% Compute the dx,dy,dt gradient of two video frames
% syntax:[dx,dy,dt] = Gradient(imNew,imPrev)
% input:
% imNew: the second video frame
% imPrev: the first video frame

% output:
% dx: the horizontal gradient
% dy: the vertical gradient
% dt: the temporal gradient

% also see:Gradient
dg =  [1     0    -1];
gg = [0.2163,   0.5674,   0.2163];
% method 1
% dx    = conv2(gg,dg,imNew,'same'); 
% dy    = conv2(dg,gg,imNew,'same'); 
% dt    = 2*(imNew - imPrev);       
%  method 2
%  dx  =   conv2(gg,dg,imNew + imPrev,'same'); 
%  dy  =   conv2(dg,gg,imNew + imPrev,'same'); 
%  dt  = 2*conv2(gg,gg,imNew - imPrev,'same'); 
% method  3

f = imNew + imPrev;
dx = f(:,[  2:end end ]  ) - f(:,[1 1:(end-1) ]  ) ;
dx = conv2(double(dx),double(gg'),'same');
dy = f(  [  2:end end ],:) - f(  [1 1:(end-1) ],:);
dy = conv2(double(dy),double(gg) ,'same');
dt = 2*conv2(gg,gg,double(imNew) - double(imPrev),'same'); 

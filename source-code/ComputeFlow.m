function [U, V] = ComputeFlow(dx,dy,dt)
% function [U,V] = ComputeFlow(dx,dy,dt)
% Compute the horizontal and vertical component of the optical flow field using the Horn-Schunck method
% syntax:[U,V] = ComputeFlow(dx,dy,dt)

% input:
% dx: the horizontal gradient
% dy: the vertical gradient
% dt: the temporal gradient
% output:
% U: the horizontal component of the optical flow field
% V: the vertical component of the optical flow field

% also see:Gradient

persistent gg TikConst;
%%initialization:
if isempty(gg)
    gg  = single(gaussgen(2));
    TikConst  = single(40);   
end

 %compute moments
 m200= conv2(gg,gg, dx.^2 ,'same') + TikConst;
 m020= conv2(gg,gg, dy.^2 ,'same') + TikConst;
 m110= conv2(gg,gg, dx.*dy,'same');
 m101= conv2(gg,gg, dx.*dt,'same');
 m011= conv2(gg,gg, dy.*dt,'same');

%compute flow
U =(-m101.*m020 + m011.*m110)./(m020.*m200 - m110.^2);
V =( m101.*m110 - m011.*m200)./(m020.*m200 - m110.^2);



    

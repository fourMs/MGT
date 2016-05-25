function flow = mgopticalflow(fr2,fr1)
% function flow = mgopticalflow(fr2,fr1)
% mgopticalflow estimates the motion using the Horn-Schunck method
% syntax:flow = mgopticalflow(fr2,fr1)

% input:
% fr2: second input image
% fr1: first input image

% output:
% flow: optical flow field containing two components,horizontal and
% vertical direction

% also see:opticalFlowLK, estimateFlow
[dx,dy,dt] = Gradient(fr2,fr1);
[U,V] = ComputeFlow(dx,dy,dt);
flow = opticalFlow(U,V);
% qom = sum(sum(flow.Magnitude));
% [m,n] = size(flow.Magnitude);
% x = 1:n;
% y = 1:m;
% meanx = mean(flow.Magnitude);
% comx = x*meanx'/sum(meanx);
% meany = mean(flow.Magnitude,2);
% comy = y*meany/sum(meany);
% com = [comx,comy];




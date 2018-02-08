function mg = mgmotionplot(f,varargin)
%MGMOTIONPLOT - Plot various motion features from MGT structure
% mgmotionplot plots quantity of motion and centroid of
% motion, width of motion, and height of a musical
% gestures data structure. This requires that mgmotion has already been
% run on a video file. 
%
% syntax:
% mg=mgmotion(fn)
% mgmotionplot(mg)
%
% input:
% mg: a musical gestures data structure containing analysed video data
%
% output:
% an image file with plots 


% Find total number of pixels for normalization
f.video.npix=f.video.obj.Width*f.video.obj.Height;


% Calculate time vecctor for plotting in seconds
f.video.timeseries=1:f.video.nframe;
f.video.timeseries=f.video.timeseries/f.video.obj.FrameRate;


% Create figure

figure('position',[200 600 1800 400]);
subplot(1,3,1);
%plot(f.video.com(:,1),f.video.com(:,2),'b.');
plot(f.video.com(:,1)/f.video.obj.Width,f.video.com(:,2)/f.video.obj.Height,'b.');
title('Centroid of motion');
%axis([0 f.video.obj.Width 0 f.video.obj.Height])
axis([0 1 0 1])
ylabel('Pixels normalized');
xlabel('Pixels normalized');
%axis equal;
subplot(1,3,[2:3]);
%plot(ts, f.video.qom);
plot(f.video.timeseries, f.video.qom/f.video.npix);
title('Quantity of motion');
%axis([0 f.video.obj.Width 0 f.video.obj.Height])
xlabel('time (s)');
ylabel('Pixels normalized');

% export figures to EPS files
set(gcf, 'PaperPositionMode', 'auto')   % Use screen size for exported file
[~,pr,~] = fileparts(f.video.obj.Name);
newfile = strcat(pr,'_com_qom');
print('-depsc', newfile);
%print('-depsc', '-tiff ', newfile);
%print('-dpdf', newfile);
close;

    
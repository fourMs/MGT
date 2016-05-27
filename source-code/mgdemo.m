% this example shows you how to use musical gestures tool box to read data
% into matlab workspace and do preprocess the video recording.
% and compute the motion gram

% read video file open a dialog and select the video file, in this case,
% pianist.mp4 was selected
mg = mgread('Video');
%
% %%%%% extract a temporal segment of a video e.g. 10sec to 30 sec.
mgseg = mgvideoreader(mg,'Extract',10,15);

%%%%% reduce the size of the video frame to half
mgsamp = mgvideosample(mgseg,[2,2],'pianistsamp.avi');

%%%%% crop the interest of region of the video frame
mgcrop = mgvideocrop(mgsamp);

%%%%% adjust contrast in the video
% mgad = mgvideoadjust(mgcrop,[0.2,0.8],[0.1,0.9]);

%%%%% compute the motion gram and quantity of motion, centroid of motion
% mgmo = mgmotion('cropvideo.avi','Diff');
mgmo = mgmotion(mgcrop,'Diff');
% or using optical flow method to estimate motion
% mgop = mgmotion(mgcrop,'OpticalFlow');
%%
%%%%% map timely the segment to audio and motion capture data, in this
%%%%% case,the related files are pianist.wav, pianst.tsv.
mgmo = mgmap(mgmo,'Both','pianist.wav','pianist.tsv');


%%%%% compute the periodicity of movement of the qom
[per,ac,eac,lag] = mgautocor(mgmo,'video',3);
figure,subplot(211),plot(lag,ac)
title('period')
xlabel('seconds')
ylabel('magnitude')
subplot(212),plot(lag,eac)
title('enhanced period')
xlabel('seconds')
ylabel('magnitude')

%%%%% compute the periodicity of movement of the motion capture data
[per,ac,eac,lag] = mgautocor(mgmo,'mocap',3);
figure,subplot(211),plot(lag,ac)
title('period')
xlabel('seconds')
ylabel('magnitude')
subplot(212),plot(lag,eac)
title('enhanced period')
xlabel('seconds')
ylabel('magnitude')

%%




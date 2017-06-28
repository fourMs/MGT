%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Generate a motion video and motiongrams (both directions)
% with the file endings _motion.avi and _mgx.tiff/_mgy.tiff
mgmotion('pianist.mp4');

% Generate an optical flow video
% with the file ending _flow.avi
mgmotion('pianist.mp4','OpticalFlow');

% Generate a motion history video
% with the ending _history.avi
mgmotionhistory('pianist.mp4');

% Generate a motion average image
% with the ending _average.tiff
mgmotionaverage('pianist.mp4');

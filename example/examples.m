%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn='dance.avi';

% Generate a motion video and motiongrams (both directions)
% with the file endings _motion.avi and _mgx.tiff/_mgy.tiff
mgmotion(fn);

% Generate an optical flow video
% with the file ending _flow.avi
mgmotion(fn,'OpticalFlow');

% Generate a motion history video
% with the ending _history.avi
mgmotionhistory(fn);

% Generate a motion average image
% with the ending _average.tiff
mgmotionaverage(fn);

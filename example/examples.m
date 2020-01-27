%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn='dance.aVi';


% Generate an optical flow video
% with the file ending _flow.avi
mgmotion(fn,'OpticalFlow');

% Generate a motion history video
% with the ending _history.avi
mgmotionhistory(fn);

% Generate a motion average image
% with the ending _average.tiff
mgmotionaverage(fn);

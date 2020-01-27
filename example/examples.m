%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn='dance.aVi';


return;

% Generate an optical flow video
% with the file ending _flow.avi
mgmotion(fn,'OpticalFlow','color','convert','Interval', 5);

% Generate a motion history video
% with the ending _history.avi
mgmotionhistory(fn);

% Generate a motion average image
% with the ending _average.tiff
mgmotionaverage(fn);


%to load all video files from an entire directory
%mgmotion_loadMultiple(".\toolbox\MGT-matlab\example\example_data",'Diff','color','convert','Interval', 5);


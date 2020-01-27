%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn='dance.aVi';


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
mgmotionhistory_loadMultiple(".\toolbox\MGT-matlab\example\example_data",'nFrame', 20, 'color','Interval', 2);
%mgmotionaverage_loadMultiple(".\toolbox\MGT-matlab\example\example_data",'color','Interval', 5);



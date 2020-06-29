%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some examples on usage of the Musical Gestures Toolbox for Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



fn='dance.avi';

mg = musicalgesture(fn);


% Generate mg motion video
mg.motion();

% Generate an optical flow video
% with the file ending _flow.avi
mg.flow('color','invert','Interval',5);


% Generate a motion history video
% with the ending _history.avi
mg.history();


% Generate a motion average image
% with the ending _average.tiff
mg.average();


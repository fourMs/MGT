function  mg = mgread(fn)
% function mg = mgread(fn)
% Reads any one of three types of data file,mocap,video,audio data file and
% returns a musical gestures data structure.When user chooses any of them,a
% file open dialog opens and provides user to choose corresponding input
% file.When option folder is given,user can choose any combinations of
% them.
% syntax: mg = mgread('Video')
% mg = mgread('Mocap')
% mg = mgread('Audio')
% mg = mgread('Folder')
% output: mg,a musical gestures data structure

if isempty(fn)
    mg = {{}};
    disp('please input a file type,eg,Mocap,Audio,Video');
end
if strcmp(fn,'Mocap')
    disp('Please select a motion capture data file .c3d,.tsv');
    mg = mginitstruct('Mocap');
    mg.mocap = mcread;
elseif strcmp(fn,'Audio')
    mg = mginitstruct('Audio');
    disp('please select a audio file .wav,.mp3');
    [file,path] = uigetfile({'*.mp3;*.wav'},'select a audio file');
    mg.audio.mir = miraudio([path,file]);
elseif strcmp(fn,'Video')
    mg = mginitstruct('Video');
    disp('please select a video file .mp4,.m4v,.mpg,.mov,.avi');
    [file,path] = uigetfile({'*.mp4;*.avi';'m4v';'mpg';'mov'},'select a video file');
    if file
        mg = mgvideoreader([path,file]);
    else 
        return;
    end
elseif strcmp(fn,'Folder')
%     mg = mginitstruct;
    [filename, pathname, filterindex] = uigetfile( ...
    {'*.*',  'All Files (*.*)'; '*.mat','MAT-files (*.mat)';   ...
     '*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
    }, ...
    'Pick a file', ...
     'MultiSelect', 'on');
    l = length(filename);
    for i = 1:l
        [~,~,ex] = fileparts(filename{i});
        if ismember(ex,{'.tsv';'.c3d';'.mat';'.wii'})
            mg.mocap = mcread([pathname,filename{i}]);
        elseif ismember(ex,{'.mp3';'.wav'})
            mg.audio.mir = miraudio([pathname,filename{i}]);
        elseif ismember(ex,{'.mp4';'.avi';'.mov';'.m4v';'.mpg'})
            tmp = mgvideoreader([pathname,filename{i}]);
            mg.video = tmp.video;
        else
            error('unknown file format');
        end           
    end
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today'));
end
end
    
    

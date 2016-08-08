function mg = mgread(varargin)
% function mg = mgread(varargin)
% reads any types of data stream, mocap,video,audio
% returns a musical gestures data structure.
%
% syntax: 
% mg = mgread(videofile)
% mg = mgread(videofile,audiofile)
% mg = mgread(audiofile)
% mg = mgread(videofile,audiofile,mocapfile)

if isempty(varargin)
    mg = {{}};
    return;
end
l = length(varargin);
for i = 1:l
    [~,~,ex] = fileparts(varargin{i});
    if ismember(ex,{'.tsv';'.c3d';'.mat';'.wii'})
         mg.mocap = mcread(varargin{i});
    elseif ismember(ex,{'.mp3';'.wav'})
         mg.audio.mir = miraudio(varargin{i});
    elseif ismember(ex,{'.mp4';'.avi';'.mov';'.m4v';'.mpg'})
         tmp = mgvideoreader(varargin{i});
         mg.video = tmp.video;
    else
         error('unknown file format');
    end           
end
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));
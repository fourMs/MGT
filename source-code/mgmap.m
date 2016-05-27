function mg = mgmap(varargin)
% function mg = mgcrop(varargin)
% mgmap extract the same segment of audio, mocap data
% according to video, if the filename of audio is not given, then mgmap trys to 
% read audio data from video.

% syntax: mg = mgmap(mg,'Audio');
% mg = mgmap(mg,'Audio',filename);
% mg = mgmap(mg,'Mocap',filename);
% mg = mgmap(mg,'Both',filename1,filename2);
% mg = mgmap(mg,'Both');

% input:
% mg: musical gestures data sturcture containing the video data and
% parameters
% 'Audio','Mocap','Both': indicate the mapping type
% filename1,filename2: names of audio file and mocap file

% output:
% mg: musical gestures data sturcture containing mapped data

mg = varargin{1};
filename = mg.video.obj.Name;
starttime = mg.video.orig_starttime;
endtime = mg.video.orig_endtime;
if strcmp(varargin{2},'Audio')
    if nargin > 2
        filename = varargin{3};
        mg.audio.mir = miraudio(filename,'Extract',starttime,endtime);
    else
        mg.audio.mir = miraudio(filename,'Extract',starttime,endtime);
    end
elseif length(varargin)>2 && strcmp(varargin{2},'Mocap')
    mg.mocap = mcread(varargin{3});
    mg.mocap = mctrim(mg.mocap,starttime,endtime);
elseif length(varargin)> 2 && strcmp(varargin{2},'Both')
    if nargin >3
        filename = varargin{3};
        mg.audio.mir = miraudio(filename,'Extract',starttime,endtime);
        mg.mocap = mcread(varargin{4});
        mg.mocap = mctrim(mg.mocap,starttime,endtime);
    else 
        mg.audio.mir = miraudio(filename,'Extract',starttime,endtime);
        mg.mocap = mcread(varargin{3});
        mg.mocap = mctrim(mg.mocap,starttime,endtime);
    end
elseif length(varargin) == 2 && strcmp(varargin{2},'Both')
    mg.audio.mir = miraudio(mg.audio.mir,'Extract',starttime,endtime);
    mg.mocap = mctrim(mg.mocap,starttime,endtime);
end




    
    
    
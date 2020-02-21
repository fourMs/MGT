function mg = mgvideoreader(varargin)
% function mg = mgvideoreader(varargin)
% mgvideoreader reads specified video file with or without extracting video
% and returns a data structure containing the video parameters and data. It
% could extract segment from existing musical gestures data structure.
% syntax: mg = mgvideoreader(filename)
%
% input: 
% filename: the name of video file
% extract: indicates  that mgvideoreader reads a segment from the video
% starttime: start of extracted segment 
% endtime: end of extracted segment
% mg: a musical gestures data structure
%
% output:
% mg,a musical gestures data structure containing the extracted segment of
% the video, for example: 
% s = mgvideoreader(filename,'Extract',timestart)
% s = mgvideoreader(mg);
% s = mgvideoreader(mg,'Extract',timestart)
% s = mgvideoreader(mg,'Extract',timestart,timeend)

if isempty(varargin)
    return;
end
l = length(varargin);
if ischar(varargin{1})
    fn = varargin{1};
    obj = VideoReader(fn);
    if l == 1
        s.video.starttime = 0;
        s.video.endtime = obj.Duration;
        s.video.obj = obj;
    elseif l == 3 && strcmpi(varargin{2},'Extract')
        s.video.starttime = varargin{3};
        s.video.endtime = obj.Duration;
        s.video.obj = obj;
    elseif l == 4 && strcmpi(varargin{2},'Extract')
        s.video.starttime = varargin{3};
        s.video.endtime = varargin{4};
        s.video.obj = obj;
    end
elseif isstruct(varargin{1})
    if l == 1
        return;
    elseif l == 3 && strcmpi(varargin{2},'Extract')
        s = varargin{1};
        s.video.starttime = varargin{3};
    elseif l == 4 && strcmpi(varargin{2},'Extract')
        s = varargin{1};
        s.video.starttime = varargin{3};
        s.video.endtime = varargin{4};
    end
end
s.video.orig_starttime = s.video.starttime;
s.video.orig_endtime = s.video.endtime;
mg = s;
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));

    
        
        
       
        
        

            
            
        

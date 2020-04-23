function mg = mgvideocat(varargin)
% function mg = mgvideocat(varargin)
% mgvideocat concatenates two videos into one
% finally writes the concatenated video in the disk and returns a musical
% gestures data structure
% syntax: mg = mgvideocat(file1,file2);
% mg = mgvideocat(mg1,mg2);

% input:
% file1,file2:the file name of video
% mg1,mg2:musical gestures data structure contains two video parameter

% output:
% mg:a musical gestures data structure contains concatenated video

if isempty(varargin)
    return;
end
l = length(varargin);
if l == 3
    filename = varargin{3};
elseif l  == 2
    filename = 'catvideo.avi';
end
if ischar(varargin{1}) && ischar(varargin{2})
    fn1 = varargin{1};
    fn2 = varargin{2};
    [~,~,ex1] = fileparts(fn1);
    [~,~,ex2] = fileparts(fn2);
    if ismember(ex1,{'.mp4';'.avi';'mpg';'mov';'m4v'}) && ismember(ex2,{'.mp4';'.avi';'mpg';'mov';'m4v'})
        tmp1 = mgvideoreader(fn1);
        tmp2 = mgvideoreader(fn2);
    else
        error('unknown video format,please check the video format');
    end
    v = VideoWriter(filename);
    open(v);
    disp('****concatenating two videos****');
    while tmp1.video.obj.CurrentTime < tmp1.video.endtime
        tm = readFrame(tmp1.video.obj);
        writeVideo(v,tm)
    end
    while tmp2.video.obj.CurrentTime < tmp2.video.endtime
        tm = readFrame(tmp2.video.obj);
        writeVideo(v,tm);
    end
    close(v);
    mg = mgvideoreader(filename);
elseif isstruct(varargin{1}) && isstruct(varargin{2}) && isfield(varargin{1},'video') && isfield(varargin{2},'video')
    mg1 = varargin{1};
    mg2 = varargin{2};
    mg1.video.obj.CurrentTime = 0;
    mg2.video.obj.CurrentTime = 0;
    v = VideoWriter(filename);
    open(v);
    disp('****concatenating two videos****');
    while mg1.video.obj.CurrentTime < mg1.video.endtime
        tmp = readFrame(mg1.video.obj);
        writeVideo(v,tmp);
    end
    while mg2.video.obj.CurrentTime < mg2.video.endtime
        tmp = readFrame(mg2.video.obj);
        writeVideo(v,tmp);
    end
    close(v);
    s = mgvideoreader(filename);    
    mg.video.obj = s.video.obj;
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today')); 
    
end

        


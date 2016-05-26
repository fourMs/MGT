function mg = mgvideoadjust(varargin)
% function mg = mgvideoadjust(varargin)
% adjust the contrast of the video, for RGB image,three channels must be
% given
% finally,wirtes adjusted video in the disk and returns a musical gestures
% data structure
% syntax: mg = mgvideoadjust(file);
% mg = mgvideoadjust(mg);
% mg = mgvideoadjust(file,[low_in1 low_in2 low_in3;high_in1 high_in2 high_in3],
% [low_out1 low_out2 low_out3;high_out1 high_out2 high_out3])
% mg = mgvideoadjust(mg,[low_in;high_in],[low_out;high_out])

% input:
% mg:musical gestures data structure
% file:the file name of video
% [low_in;high_in],[low_out;high_out]:mapping value in video frame to new
% values such that the values between [low_in;high_in] map to values
% between [low_out;high_out]

% output:
% mg:a musical gestures data structure contains the adjusted video

if isempty(varargin)
    return;
end
l = length(varargin);
if l == 3
    mapin = varargin{2};
    mapout = varargin{3};
elseif l == 4
    mapin = varargin{2};
    mapout = varargin{3};
    gamma = varargin{4};
end
if ischar(varargin{1})
    fn = varargin{1};
    [~,~,ex] = fileparts(fn);
    if ismember(ex,{'.mp4';'.avi';'mpg';'mov';'m4v'})
        mg = mgvideoreader(fn);
    else
        error('unknown video format,please check the video format');
    end
    v = VideoWriter('adjustvideo.avi');
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration;
    disp('****adjusting video contrast****');
    while mg.video.obj.CurrentTime < mg.video.endtime
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
        if l == 1
            tmp = rgb2gray(tmp);
            tmp = imadjust(tmp);
        elseif l == 3
            if size(mapin,2) == 1
                tmp = rgb2gray(tmp);
                tmp = imadjust(tmp,mapin,mapout);
            elseif size(mapin,2) == 3
                tmp = imadjust(tmp,mapin,mapout);
            end
        elseif l == 4
            if size(mapin,2) == 1
                tmp = rgb2gray(tmp);
                tmp = imadjust(tmp,mapin,mapout,gamma);
            elseif size(mapin,2) == 3
                tmp = imadjust(tmp,mapin,mapout,gamma);
            end
        end
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v);
    mg = mgvideoreader('adjustvideo.avi');
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today'));
elseif isstruct(varargin{1}) && isfield(varargin{1},'video')
    mg = varargin{1};
    mg.video.obj.CurrentTime = 0;
    v = VideoWriter('adjustvideo.avi');    
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration;
    disp('****adjusting video contrast****');
    while mg.video.obj.CurrentTime < mg.video.endtime
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
        if l == 1
            tmp = rgb2gray(tmp);
            tmp = imadjust(tmp);
        elseif l == 3
            if size(mapin,2) == 1
                tmp = rgb2gray(tmp);
                tmp = imadjust(tmp,mapin,mapout);
            elseif size(mapin,2) == 3
                tmp = imadjust(tmp,mapin,mapout);
            end
        elseif l == 4
            if size(mapin,2) == 1
                tmp = rgb2gray(tmp);
                tmp = imadjust(tmp,mapin,mapout,gamma);
            elseif size(mapin,2) == 3
                tmp = imadjust(tmp,mapin,mapout,gamma); 
            end
        end
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v);
    tmp = mgvideoreader('adjustvideo.avi');
    mg.video.obj = tmp.video.obj;
    mg.video.starttime = 0;
    mg.video.endtime = tmp.video.obj.Duration;
end
        
        
    

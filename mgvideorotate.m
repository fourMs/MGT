function mg = mgvideorotate(varargin)
% function mg = mgvideocrop(varargin)
% mgvideorotate rotates the video by angle degrees in a counterclockwise
% around its center point. To rotate the image clockwise, specify a
% negative value for angle.
% finally write the rotated video into a video file
% syntax: mg = mgvideorotate(file,angle)
% mg = mgvideorotate(file,angle,method)
% mg = mgvideorotate(mg,angle)
% mg = mgvideorotate(mg,angle,method,bbox,filename)

% input:
% mg: musical gestures structure
% angle:positive value means rotation in a counterclockwise direction,
% negative value means rotation in a clockwise direction
% method:specify the interpolation method, options:'nearest','bilinear','bicubic'
% bbox:bounding box, options:'loose','crop';
% filename: the name of rotated video, required format .avi;

% output:
% mg: a musical gestures data structure contains rotated video

if isempty(varargin)
    return;
end
l = length(varargin);
if l == 2
    angle = varargin{2};
    filename = 'rotatevideo.avi';
elseif l == 3
    angle = varargin{2};
    method = varargin{3};
    filename = 'rotatevideo.avi';
elseif l == 4
    angle = varargin{2};
    method = varargin{3};
    bbox = varargin{4};
    filename = 'rotatevideo.avi';
elseif l == 5
    angle = varargin{2};
    method = varargin{3};
    bbox = varargin{4};
    filename = varargin{5};
end
if ischar(varargin{1})
    fn = varargin{1};
    [~,~,ex] = fileparts(fn);
    if ismember(ex,{'.mp4';'.avi';'mpg';'mov';'m4v'})
        mg = mgvideoreader(fn);
    else 
        error('unknown video format,please check the video format');
    end
    v = VideoWriter(filename);
    open(v);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration;
    disp('****rotating video****');
    while mg.video.obj.CurrentTime < mg.video.endtime
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
        if l == 2
            tmp = imrotate(tmp,angle);
        elseif l == 3
            tmp = imrotate(tmp,angle,method);
        elseif l == 4
            tmp = imrotate(tmp,angle,method,bbox);
        end
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v);
    mg = mgvideoreader(filename);
elseif isstruct(varargin{1}) && isfield(varargin{1},'video')
    mg = varargin{1};
    mg.video.obj.CurrentTime = 0;
    v = VideoWriter(filename);
    open(v);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration;
    disp('****rotating video****');
    while mg.video.obj.CurrentTime < mg.video.endtime
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
        if l == 2
            tmp = imrotate(tmp,angle);
        elseif l == 3
            tmp = imrotate(tmp,angle,method);
        elseif l == 4
            tmp = imrotate(tmp,angle,method,bbox);
        end
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v);
    tmp = mgvideoreader(filename);
    mg.video.obj = tmp.video.obj;
    mg.video.obj = tmp.video.obj;
    mg.video.starttime = 0;
    mg.video.endtime = tmp.video.obj.Duration;
end

        
        
    
    
        
    





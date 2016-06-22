function mg = mgvideocrop(varargin)
% function mg = mgvideocrop(varargin)
% mgvideocrop crops the region of video frame given by user
% it provides user to draw a region area which the user wants to crop
% then crops the same region in the every video frame
% finally write the croped region into a video file
%
% syntax: mg = mgvideocrop(mg,pos,newfilename);
% mg = mgvideocrop(file,pos,newfilename)
% mg = mgvideocrop(file,newfilename)
%
% input:
% mg: musical gestures structure contains the video information
% pos:position matrix, first row vector indicates the index of columns,second row
% indicates the index of rows
% file: the video file name needs to be croped
% filename: the name of croped video, required foramt .avi
%
% example:
% mg = mgvideocrop(videofile,[20 50;20 50],'newvideo.avi');
% mg = mgvideocrop(videofile);
%
% output:
% mg:musical gestures structure contains the croped video

if isempty(varargin)
    return;
end
l = length(varargin);
if ischar(varargin{1})
    fn = varargin{1};
    [~,pr,ex] = fileparts(fn);
    if ismember(ex,{'.mp4';'.avi';'.mpg';'.mov';'.m4v'})
        mg = mgvideoreader(fn);
    else
        error('unknown video format,please check the video format');
    end
    tmp = readFrame(mg.video.obj);
    if l == 1
%         [bw,c,r] = roipoly(tmp);
        disp('Select a region in the first video frame, then right click crop image...');
        [tmp,pos] = imcrop(tmp);
        filename = strcat(pr,'cropvideo.avi');
    elseif l == 2
        if ischar(varargin{2})
            filename = varargin{2};
            disp('Select a region in the first video frame, then right click crop image...');
            [tmp,pos] = imcrop(tmp);
        else
            pos = varargin{2};
%         bw = roipoly(tmp,pos(1,:),pos(2,:));
            tmp = imcrop(tmp,pos);
            filename = strcat(pr,'cropvideo.avi');
        end
    elseif l == 3
        pos = varargin{2};
        tmp = imcrop(tmp,pos);
        filename = varargin{3};
    end
%     w1 = max(pos,2);
%     w2 = min(pos,2);
%     w = w1-w2;
    v = VideoWriter(filename);
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    writeVideo(v,tmp);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration-1;
    disp('cropping video...');
    while mg.video.obj.CurrentTime < mg.video.obj.Duration
        progmeter(i,numf);
        tmp = readFrame(mg.video.obj);
%         tmp = uint8(bw).*tmp;
        tmp = imcrop(tmp,pos);
        writeVideo(v,tmp);
        i = i + 1;
    end
    close(v);
    fprintf('\n');
    disp(['the cropped video is created with name ',filename]);
    mg = mgvideoreader(filename);
elseif isstruct(varargin{1}) && isfield(varargin{1},'video')
    mg = varargin{1};
    mg.video.obj.currentTime = 0;
    [~,pr,~] = fileparts(mg.video.obj.Name);
    tmp = readFrame(mg.video.obj);
    if l == 1
        disp('Select a region in the first video frame, then right click crop image...');
        [tmp,pos] = imcrop(tmp);
        filename = strcat(pr,'cropvideo.avi');
    elseif l == 2
        if ischar(varargin{2})
            filename = varargin{2};
            disp('Select a region in the first video frame, then right click crop image...');
            [tmp,pos] = imcrop(tmp);
        else
            pos = varargin{2};
            tmp = imcrop(tmp,pos);
            filename = strcat(pr,'cropvideo.avi');
        end
    elseif l == 3
        pos = varargin{2};
        tmp = imcrop(tmp,pos);
        filename = varargin{3};
    end
%     w1 = max(pos,2);
%     w2 = min(pos,2);
%     w = w1-w2;
    v = VideoWriter(filename);
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    writeVideo(v,tmp);
    i = 1;
    numf = mg.video.obj.FrameRate*mg.video.obj.Duration-1;
    disp('****cropping video****');
    while mg.video.obj.CurrentTime < mg.video.obj.Duration
        progmeter(i,numf);
        tm = readFrame(mg.video.obj);
        tm = imcrop(tm,pos);
        writeVideo(v,tm);
        i = i + 1;
    end
    close(v);
    fprintf('\n');
    disp(['the cropped video is created with name ',filename]);
    s = mgvideoreader(filename);
    mg.video.obj = s.video.obj;
    mg.video.starttime = 0;
    mg.video.endtime = s.video.obj.Duration;
end






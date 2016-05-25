function mg = mgvideofilter(varargin)

% mg = mgvideofilter(varargin) 
% mgvideofilter filter the video with 'Temporal' ,'Spatial', 'Both'
% options.
% with 'Temporal' option, perform temporal filter
% with 'Spatial' option, perform spatial filter by mediean, or average filter; 
% syntax: mg = mgvideofilter(filename,type,med,h);
% mg = mgvideofilter(mg,type,med,h);

% input: 
% filename: video file
% mg: input mg containing the video data;
% type: 'Spatial','Temporal';
% med: when 'Spatial',it has two options, 'Mediean', 'Average'; when 'Temporal'
% output: 
% mg: filtered video
if isempty(varargin)
    return;
end
l = length(varargin);
if l == 1
    type = 'Spatial';
    med = 'Mediean';
    value = [3 3];
elseif l >=4
    type = varargin{2};
    med = varargin{3};
    value = varargin{4};
end
if ischar(varargin{1})
    file = varargin{1};
    [~,~,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'mpg';'mov';'m4v'})
        mg = mgvideoreader(file);
    else 
        error('unknown video format,please the video format');
    end
elseif isstruct(varargin{1}) && isfield(varargin{1},'video')
    mg = varargin{1};
end
numf = floor(mg.video.obj.FrameRate*mg.video.obj.Duration);
if strcmp(type,'Spatial')
    if strcmp(med,'Mediean')
        v = VideoWriter('videofiltered.avi');
        v.FrameRate = mg.video.obj.FrameRate;
        open(v);
        i = 1;
        while mg.video.obj.CurrentTime < mg.video.endtime
            progmeter(i,numf);
            tmp = readFrame(mg.video.obj);
            tmp(:,:,1) = medfilt2(tmp(:,:,1),value);
            tmp(:,:,2) = medfilt2(tmp(:,:,2),value);
            tmp(:,:,3) = medfilt2(tmp(:,:,3),value);
            writeVideo(v,tmp);
            i = i + 1;
        end
        close(v);
        s = mgvideoreader('videofiltered.avi');
        mg.video.obj = s.video.obj;
    elseif strcmp(med,'Average')
        v = VideoWriter('videofiltered.avi');
        v.FrameRate = mg.video.obj.FrameRate;
        open(v);
        i = 1;
        value = fspecial('average',value);
        while mg.video.obj.CurrentTime < mg.video.endtime
            progmeter(i,numf);
            tmp = readFrame(mg.video.obj);
            tmp = imfilter(tmp,value,'replicate');
            writeVideo(v,tmp);
            i = i + 1;
        end
        close(v);
        s = mgvideoreader('videofiltered.avi');
        mg.video.obj = s.video.obj;
        
    end
end
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));
    
        
        



    
        
    




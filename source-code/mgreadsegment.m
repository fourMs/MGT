function mg = mgreadsegment(varargin)
% function out = mgreadsegment(varargin)
% mgreadsegment extracts a temporal segment from the media file,or musical gestures data structure. 
% It extracts a segment of different file.
% syntax:out = mgreadsegment(filename of video);
% out = mgreadsegment(filename of mocap);
% out = mgreadsegment(filename of audio);
% out = mgreadsegment(filename of video,timestart,timeend);
% out = mgreadsegment(mg,timestart,timeend);
% input:
% filename: specified filename,audio,video,or mocap file
% timestart: start of the segment
% timeend: end of the segment
% mg: a musical gestures data structure
% output:
% mg: a muscial gestures data structure containing the specified segment
% eg. out = mgreadsegment(filename of audio,2,4)
% out = mgreadsegment(filename of video,2,4)
% out = mgreadsegment(mg,2,4)
% also see: mgvideoread
if isempty(varargin)
    mg = {{}};
    return
end
l = length(varargin);
if ischar(varargin{1})
if l == 1
    filename = varargin{1};
    [~,pr,ex] = fileparts(filename);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
        tmp = mgvideoreader(filename);
        mg.video = tmp.video;
    elseif ismember(ex,{'.mp3';'wav'})
        mg.audio.mir = miraudio(filename);
    elseif ismember(ex,{'.tsv';'.c3d';'.mat';'.wii'})
        mg.mocap = mcread(filename);
    else
        error('unknown file format');
    end
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today'));
elseif l == 3
    filename = varargin{1};
    starttime = varargin{2};
    endtime = varargin{3};
    if starttime>endtime
        tmp = endtime;
        endtime = starttime;
        starttime = tmp;
    end
    [~,pr,ex] = fileparts(filename);
    if ismember(ex,{'.mp4';'.avi';'.mpg';'.mov';'.m4v'})
        s = mgvideoreader(filename,'Extract',starttime,endtime);
        s.video.obj.CurrentTime = s.video.starttime;
        newname = strcat(pr,'segement.avi');
        v = VideoWriter(newname);
        v.FrameRate = s.video.obj.FrameRate;
        open(v);
        indf = 1;
        numfr = s.video.obj.FrameRate*(endtime-starttime);
        disp('****reading temporal segment****');
        while s.video.obj.CurrentTime < s.video.endtime;
            progmeter(indf,numfr);
            tmp = readFrame(s.video.obj);
            if isfield(s.video,'samplefactor') && s.video.samplefactor > 1 && isinteger(s.video.samplefactor)
                tmp = rgb2gray(tmp);
                tmp = tmp(1:s.vdieo.samplefactor:end,1:s.video.samplefactor:end);
            end
            writeVideo(v,tmp);
            indf = indf + 1;
        end
        close(v); 
        fprintf('\n');
        disp(['the trimmed video is created with name ',newname]);
        s = mgvideoreader(newname);
        mg.video = s.video;
        mg.video.orig_starttime = starttime;
        mg.video.orig_endtime = endtime;
        
    elseif ismember(ex,{'.mp3';'.wav'})
        mg.audio.mir =  miraudio(filename,'Extract',starttime,endtime);
        
    elseif ismember(ex,{'.tsv';'.c3d';'.mat';'.wii'})
        mg.mocap = mcread(filename);
        mg.mocap = mctrim(mg.mocap,starttime,endtime);
    end
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today'));
end
elseif isstruct(varargin{1})
    mg = varargin{1};
    if l == 1
        return;
    elseif l == 3
        starttime = varargin{2};
        endtime = varargin{3};
        if isfield(mg,'audio')
            mg.audio.mir = miraudio(mg.audio.mir,'Extract',starttime,endtime);
        end
        if isfield(mg,'mocap')
            mg.mocap = mctrim(mg.mocap,starttime,endtime);
        end
        if isfield(mg,'video')
            mg.video.obj.CurrentTime = starttime;
            [~,pr,~] = fileparts(mg.video.obj.Name);
            newname = strcat(pr,'_segment.avi');
            v = VideoWriter(newname);
            v.FrameRate = mg.video.obj.FrameRate;
            open(v);
            indf = 1;
            numfr = mg.video.obj.FrameRate*(endtime-starttime);
            disp('****reading temporal segment****');
            while mg.video.obj.CurrentTime < endtime;
                progmeter(indf,numfr);
                tmp = readFrame(mg.video.obj);
                if isfield(mg.video,'samplefactor') && mg.video.samplefactor > 1
                    tmp = rgb2gray(tmp);
                    tmp = tmp(1:mg.video.samplefactor:end,1:mg.video.samplefactor:end);
                end
                writeVideo(v,tmp);
                indf = indf + 1;
            end
            close(v); 
            fprintf('\n');
            disp(['the trimmed video is created with name ',newname]);
            tmp = mgvideoreader(newname);
            mg.video.obj = tmp.video.obj;
            mg.video.starttime = 0;
            mg.video.endtime = tmp.video.obj.Duration;
        end
    end
end

    

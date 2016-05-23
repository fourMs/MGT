function mgmotionhistory(nframe,varargin)
% function  mgmotionhistory(nframe,varargin)
% mgmotionhistory computes the motion history image given the number of
% frames and specified temporal segment of a video, showing the motion
% history image over time;

% syntax: mgmotionhistory(nframe,varargin);
% mgmotionhistory(nframe,videofile,starttime,endtime);
% mgmotionhistory(nframe,videofile,starttime);
% mgmotionhistory(nframe,videofile);

% input:
% nframe: the number of frames used to compute motion history image;
% starttime: specify the start time in a video;
% endtime: specify the end time in a video;
% videofile: input video file

% example:
% mgmotionhistory(5,'dancer.mov',5,10); computing the motion history image
% from 5sec to 10sec, using 5 frames to calculate it.
if isempty(varargin)
    mg = {{}};
end
l = length(varargin);
if ischar(varargin{1})
    if l == 1
        file = varargin{1};
        starttime = 0;
        mg = mgvideoreader(file);
        endtime = mg.video.endtime;
    elseif l == 2
        file = varargin{1};
        starttime = varargin{2};
        mg = mgvideoreader(file,'Extract',starttime);
        endtime = mg.video.endtime;
    elseif l == 3
        file = varargin{1};
        starttime = varargin{2};
        endtime = varargin{3};
        mg = mgvideoreader(file,'Extract',starttime,endtime);
    elseif l == 4
        file = varargin{1};
        starttime = varargin{2};
        endtime = varargin{3};
        mg = mgvideoreader(file,'Extract',starttime,endtime);
    end
    mg.video.starttime = starttime;
    mg.video.endtime = endtime;
end
numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
mg.video.obj.CurrentTime = starttime;
for i = 1:numf - nframe+1
    fr = rgb2gray(readFrame(mg.video.obj));
    fr2 = rgb2gray(readFrame(mg.video.obj));
    history = imsubtract(fr2,fr);
    for j = i+2:i+nframe-1
        nextf = rgb2gray(readFrame(mg.video.obj));
        temp = imsubtract(nextf,fr2);
        fr2 = nextf;
        history = imadd(temp,history);
    end
    figure(1),imshow(imadd(history,nextf));
%     figure(1),imshow(history);
end
    

    
        
    

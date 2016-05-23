function mgmotionhistory(nframe,varargin)
% function mg = mgmotionhistory(nframe,varargin)
% mgmotionhistory computes the motion history image
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
    

    
        
    
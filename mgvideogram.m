function mg = mgvideogram(varargin)
% function mg = mgvideogram(varargin)
% mgvideogram computes the videogram of a specified temporal segment of a
% video;
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
        mg = mgvideoreader(file);
        endtime = mg.video.endtime;
    elseif l == 3
        file = varargin{1};
        mg = mgvideoreader(file);
        starttime = varargin{2};
        endtime = varargin{3};
    end
end
ind = 1;
numf = mg.video.obj.FrameRate*(endtime-starttime);
mg.video.obj.CurrentTime = starttime;
mg.video.videogram.gramx = [];
mg.video.videogram.gramy = [];
while mg.video.obj.CurrentTime < endtime
    progmeter(ind,numf);
    fr = readFrame(mg.video.obj);
    gramx = mean(fr);
    gramy = mean(fr,2);
    mg.video.videogram.gramy = [mg.video.videogram.gramy;gramx];
    mg.video.videogram.gramx = [mg.video.videogram.gramx,gramy];
    ind = ind + 1;
end
figure,imshow(uint8(mg.video.videogram.gramy));
figure,imshow(uint8(mg.video.videogram.gramx));  
    

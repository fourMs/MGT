function ave = mgmotionaverage(varargin)
% function mgmotionaverage(varargin)
% create an image by calculating the average of the video frames
% if you want to compute average image on the color scale, make sure the
% input is a mg structure which contains the video information, for
% example, created by function mgread. Then set the mode like
% mg.video.mode.color = 'on';
%
% syntax:
% mgmotionaverage(videofile,starttime,endtime);
% mgmotionaverage(mg,starttime,endtime);
% mgmotionaverage(mg);
% mgmotionaverage(videofile);
%
% input:
% videofile or mg: input video file or data structure which contains video
% information
% starttime: specified startting time for averaging video
% endtime: specified end time for avereaging video
%
% output:
% ave: average image.
%
% todo:
% fix color output

l = length(varargin);
if isempty(varargin)
    return;
end
f = varargin{1};
if ischar(f)
    try
        mg = mgvideoreader(f);
    catch
        error('wrong input file, please check the format...');
    end
    if l == 1
        starttime = mg.video.starttime;
        endtime = mg.video.endtime;
    elseif l == 2
        starttime = varargin{2};
        endtime = mg.video.endtime;
    elseif l == 3
        starttime = varargin{2};
        endtime = varargin{3};
    end
    ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
    i = 0;
    mg.video.obj.CurrentTime = starttime;
    while mg.video.obj.CurrentTime < endtime
        fr = rgb2gray(readFrame(mg.video.obj));
        ave = double(ave) + double(fr);
        i = i + 1;
    end
elseif isstruct(f) && isfield(f,'video')
    mg = f;
    if l == 1
        starttime = mg.video.starttime;
        endtime = mg.video.endtime;
    elseif l == 2
        starttime = varargin{2};
        endtime = mg.video.endtime;
    elseif l == 3
        starttime = varargin{2};
        endtime = varargin{3};
    end
    mg.video.obj.CurrentTime = starttime;
    i = 0;

    if isfield(mg.video,'mode') && strcmpi(mg.video.mode.color,'on')
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width,3);
        while mg.video.obj.CurrentTime < endtime
            fr = readFrame(mg.video.obj);
            ave = double(ave) + double(fr);
            i = i + 1;
        end
    else
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
        while mg.video.obj.CurrentTime < endtime
            fr = rgb2gray(readFrame(mg.video.obj));
            ave = double(ave) + double(fr);
            i = i + 1;
        end
    end
end

% Normalizing values to [0,1]
%ave2 = uint8(ave/i); % old approach didnt work well
ave2=(ave-min(ave(:))) ./ max(ave(:)-min(ave(:)));

%figure, imshow(ave2);

% Write to file
[~,pr,~] = fileparts(mg.video.obj.Name);
tmpfile=strcat(pr,'_average.tiff');
imwrite(ave2, tmpfile);

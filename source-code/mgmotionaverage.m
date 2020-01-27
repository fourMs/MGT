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
% mgmotionaverage(videofile, ... , 'color', ...); 
% mgmotionaverage(mg, ... , 'color', ...);
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

cmd = [];

if(ischar(f))
    disp('input is a file');
    mg = mgvideoreader(f);
    cmd.inputType = 'file';
elseif isstruct(f) && isfield(f,'video')
    disp('input is mg struct');
    mg = f;
    cmd.inputType = 'struct';
else
    error('wrong input file, please check the format...');
end


%cmd.method = 'Diff';
cmd.starttime = mg.video.starttime;
cmd.endtime = mg.video.endtime;
%cmd.filterflag = 0;
%cmd.filtertype = [];
%cmd.thresh = 0.1;
cmd.color = 'off';
%cmd.convert = 'off';
cmd.frameInterval = 1;



for argi = 1:l
    if( ischar(varargin{argi}))   
        if(argi == 1 ) %the file name is always the first element in the varargin 
            if(argi + 1 <= l && isnumeric(varargin{argi + 1}))
                disp('starttime specified in argument');
                cmd.starttime = varargin{argi+1};
                if(argi + 2 <= l &&isnumeric(varargin{argi + 2})) 
                    disp('stoptime specified in argument');
                    cmd.endtime = varargin{argi+2};
                end
            end

        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            cmd.color = 'on'
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                cmd.frameInterval = varargin{argi+1};
            end
        end
    end
end

frameInterval = cmd.frameInterval;

if ischar(f)
    try
        mg = mgvideoreader(f);
    catch
        error('wrong input file, please check the format...');
    end
    
    starttime = cmd.starttime;
    endtime = cmd.endtime;
    
%     if l == 1
%         starttime = mg.video.starttime;
%         endtime = mg.video.endtime;
%     elseif l == 2
%         starttime = varargin{2};
%         endtime = mg.video.endtime;
%     elseif l == 3
%         starttime = varargin{2};
%         endtime = varargin{3};
%     end
    ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
    i = 1;
    mg.video.obj.CurrentTime = starttime;
    
    
%     while mg.video.obj.CurrentTime < endtime
%         fr = rgb2gray(readFrame(mg.video.obj));
%         ave = double(ave) + double(fr);
%         i = i + 1;
%     end
    
    if (strcmpi(cmd.color, 'on')) || (isfield(mg.video,'mode') && strcmpi(mg.video.mode.color,'on'))
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width,3);
        numfr = mg.video.obj.FrameRate*(endtime-starttime);
        
        for indf = 1:frameInterval:numfr
            fr = readFrame(mg.video.obj);
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
        end
        
%         while mg.video.obj.CurrentTime < endtime
%             fr = readFrame(mg.video.obj);
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
    else
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
        numfr = mg.video.obj.FrameRate*(endtime-starttime);
        
        for indf = 1:frameInterval:numfr
            fr = rgb2gray(readFrame(mg.video.obj));
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
        end
%         while mg.video.obj.CurrentTime < endtime
%             fr = rgb2gray(readFrame(mg.video.obj));
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
    end
    
    
elseif isstruct(f) && isfield(f,'video')
    mg = f;
    
    starttime = cmd.starttime;
    endtime = cmd.endtime;
    
    
%     if l == 1
%         starttime = mg.video.starttime;
%         endtime = mg.video.endtime;
%     elseif l == 2
%         starttime = varargin{2};
%         endtime = mg.video.endtime;
%     elseif l == 3
%         starttime = varargin{2};
%         endtime = varargin{3};
%     end

    mg.video.obj.CurrentTime = starttime;
    i = 1;

    if (strcmpi(cmd.color, 'on')) || (isfield(mg.video,'mode') && strcmpi(mg.video.mode.color,'on'))
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width,3);
        numfr = mg.video.obj.FrameRate*(endtime-starttime);
        
        for indf = 1:numfr
            fr = readFrame(mg.video.obj);
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
        end
        
%         while mg.video.obj.CurrentTime < endtime
%             fr = readFrame(mg.video.obj);
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
    else
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
        numfr = mg.video.obj.FrameRate*(endtime-starttime);
        
        for indf = 1:numfr
            fr = rgb2gray(readFrame(mg.video.obj));
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
        end
%         while mg.video.obj.CurrentTime < endtime
%             fr = rgb2gray(readFrame(mg.video.obj));
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
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

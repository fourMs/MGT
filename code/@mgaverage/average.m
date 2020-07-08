function [outputArg1,outputArg2] = average(obj,varargin)
% function mgmotionaverage(varargin)
% Create an average image by calculating the average of the video frames.
%
% syntax:
% mgmotionaverage(videofile,starttime,endtime);
% mgmotionaverage(mg,starttime,endtime);
% mgmotionaverage(mg);
% mgmotionaverage(videofile);
%
% mgmotionaverage(videofile, ... , 'color', ...);
% mgmotionaverage(mg, ... , 'color', ...);
% mgmotionaverage(videofile, ... , 'normalize', ...);
%
% input:
% videofile or mg: input video file or data structure which contains video
% information
% starttime: specified startting time for averaging video
% endtime: specified end time for averaging video
%
% output:
% ave: average image.

disp("hello");


arg = [];

%default parameters
arg.color = 'off';
arg.invert = 'off';
arg.frameInterval = 1;
arg.normalize = 'on'
arg.startTime = [];
arg.stopTime = [];
arg.fileCount = length(obj.video);


if(arg.fileCount <= 1)
    arg.startTime = obj.startTime;
    arg.stopTime = obj.stopTime;
end


for argi = 1:nargin-1
    
    if( ischar(varargin{argi}))
        if (strcmpi(varargin{argi},'startTime'))
            if(arg.fileCount <= 1)
                
                if(argi + 1 <= nargin-1)
                    disp('start time specified');
                    arg.startTime = varargin{argi+1};
                end
                
            end
        elseif (strcmpi(varargin{argi},'stopTime'))
            if(arg.fileCount <= 1)
                if(argi + 1 <= nargin-1)
                    disp('stop time specified');
                    arg.stopTime = varargin{argi+1};
                end
            end
        elseif (strcmpi(varargin{argi},'normalize'))
            disp('normalization option is specified in argument');
            
            if(argi + 1 <= nargin-1)
                if (strcmpi(varargin{argi+1},'off'))
                    arg.normalize = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    arg.normalize = 'on'
                end
            else
                arg.normalize = 'on'
            end
            
        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            arg.color = 'on'
            
            
            if(argi + 1 <= nargin-1)
                if (strcmpi(varargin{argi+1},'off'))
                    arg.color = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    arg.color = 'on'
                end
            else
                arg.color = 'on'
            end
            
            
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= nargin &&  isnumeric(varargin{argi + 1}))
                arg.frameInterval = varargin{argi+1};
            end
        end
        
    end
end



if(arg.fileCount <= 1)
    
    
    obj.video.CurrentTime = arg.startTime;
    
    
    if (strcmpi(arg.color, 'on'))
        ave = zeros(obj.video.Height,obj.video.Width,3);
        numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime);
        progmeter(0);
        
        for indf = 1:arg.frameInterval:numfr
            progmeter(obj.video.CurrentTime,arg.stopTime);
            fr = readFrame(obj.video);
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = arg.startTime+ (1/obj.video.FrameRate)*indf;
        end
        
    else
        ave = zeros(obj.video.Height,obj.video.Width);
        numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime);
        progmeter(0);
        
        for indf = 1:arg.frameInterval:numfr
            progmeter(obj.video.CurrentTime,arg.stopTime);
            fr = rgb2gray(readFrame(obj.video));
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = arg.startTime + (1/obj.video.FrameRate)*indf;
        end
        
    end
    
    if (strcmpi(arg.normalize,'on'))
        %ave2 = uint8(ave/i); % old approach didnt work well
        aveNormalized=(ave-min(ave(:))) ./ max(ave(:)-min(ave(:)));
        aveOut = aveNormalized;
    else
        aveOut = ave;
    end
    
    % Write to file
    [~,pr,~] = fileparts(obj.video.Name);
    tmpfile=strcat(pr,'_average.tiff');
    disp(' ');
    disp('file created under name :');
    disp(tmpfile);
    imwrite(aveOut, tmpfile);

    
    
else
    
    for fileIndex = 1:arg.fileCount
        
        
        if (strcmpi(arg.color, 'on'))
            ave = zeros(obj.video{fileIndex}.Height,obj.video{fileIndex}.Width,3);
            numfr = obj.video{fileIndex}.FrameRate*(obj.stopTime{fileIndex}-obj.startTime{fileIndex});
            progmeter(0);
            
            for indf = 1:arg.frameInterval:numfr
                progmeter(obj.video{fileIndex}.CurrentTime,obj.stopTime{fileIndex});
                fr = readFrame(obj.video{fileIndex});
                ave = double(ave) + double(fr);
                mg.video.obj.CurrentTime = obj.startTime{fileIndex} + (1/obj.video{fileIndex}.FrameRate)*indf;
            end
            
        else
            ave = zeros(obj.video{fileIndex}.Height,obj.video{fileIndex}.Width);
            numfr = obj.video{fileIndex}.FrameRate*(obj.stopTime{fileIndex}-obj.startTime{fileIndex});
            progmeter(0);
            
            for indf = 1:arg.frameInterval:numfr
                progmeter(obj.video{fileIndex}.CurrentTime,obj.stopTime{fileIndex});
                fr = rgb2gray(readFrame(obj.video{fileIndex}));
                ave = double(ave) + double(fr);
                mg.video.obj.CurrentTime = obj.startTime{fileIndex} + (1/obj.video{fileIndex}.FrameRate)*indf;
            end
            
        end
        
        
        if (strcmpi(arg.normalize,'on'))
            %ave2 = uint8(ave/i); % old approach didnt work well
            aveNormalized=(ave-min(ave(:))) ./ max(ave(:)-min(ave(:)));
            aveOut = aveNormalized;
        else
            aveOut = ave;
        end
        
        % Write to file
        [~,pr,~] = fileparts(obj.video{fileIndex}.Name);
        tmpfile=strcat(pr,'_average.tiff');
        disp(' ');
        disp('file created under name :');
        disp(tmpfile);
        imwrite(aveOut, tmpfile);
        
        
        
    end
    
end




end


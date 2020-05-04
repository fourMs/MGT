function [retval,videoOut] = history(obj, varargin)
%HISTORY Summary of this function goes here
%   Detailed explanation goes here


arg = [];
arg.nFrame = 20; %default fame number = 20;
arg.color = 'off';
arg.frameInterval = 1;
arg.fileCount = length(obj.video);
arg.startTime = [];
arg.stopTime = [];
arg.fileCount = length(obj.video);



if(arg.fileCount <= 1)
    arg.startTime = obj.startTime;
    arg.stopTime = obj.stopTime;
end


for argi = 1:nargin-1
    
    if( ischar(varargin{argi}))
        if (strcmpi(varargin{argi},'nFrame'))
            disp('nframe specified');
            arg.nFrame = varargin{argi+1};
        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            arg.color = 'on'
        elseif (strcmpi(varargin{argi},'Gray'))
            disp('color mode on is specified in argument');
            arg.color = 'off'
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= nargin &&  isnumeric(varargin{argi + 1}))
                arg.frameInterval = varargin{argi+1};
            end
        end
    end
end




if(arg.fileCount <= 1)
    
    [~,pr,ex] = fileparts(obj.video.Name);
    newfile = strcat(pr,'_history.avi');
    v = VideoWriter(newfile);
    v.FrameRate = obj.video.FrameRate;
    open(v);
    
    obj.video.CurrentTime = arg.startTime;
    
    
    if(strcmpi(arg.color, 'on'))
        temparray = zeros(obj.video.Height,obj.video.Width,3,arg.nFrame-1,'uint8');
        prevFrame = readFrame(obj.video);
        numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime)-arg.nFrame;
        progmeter(0);
        for indf = 1:arg.frameInterval:numfr-1
            progmeter(indf,numfr)
            temparray = temparray(:,:,:,[2:end 1]);
            currentFrame = readFrame(obj.video);
            temp = imsubtract(currentFrame,prevFrame);
            prevFrame = currentFrame;
            temparray(:,:,:,end) = temp;
            history = uint8(sum(temparray,4));
            writeVideo(v,imadd(history,currentFrame));
            obj.video.CurrentTime = arg.startTime + (1/obj.video.FrameRate)*indf;
            
        end
        
    else
        temparray = zeros(obj.video.Height,obj.video.Width,arg.nFrame-1,'uint8');
        prevFrame = rgb2gray(readFrame(obj.video));
        numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime)-arg.nFrame;
        progmeter(0);
        for indf = 1:arg.frameInterval:numfr-1
            progmeter(indf,numfr)
            temparray = temparray(:,:,[2:end 1]);
            currentFrame = rgb2gray(readFrame(obj.video));
            temp = imsubtract(currentFrame,prevFrame);
            prevFrame = currentFrame;
            temparray(:,:,end) = temp;
            history = uint8(sum(temparray,3));
            writeVideo(v,imadd(history,currentFrame));
            obj.video.CurrentTime = arg.startTime + (1/obj.video.FrameRate)*indf;
            
        end
    end
    
    
    close(v);
    %videoOut = VideoReader(newfile);
    retval = 0;
    
    
    
else
    
    
    for i=1:arg.fileCount
        [~,pr,ex] = fileparts(obj.video{i}.Name);
        newfile = strcat(pr,'_history.avi');
        v = VideoWriter(newfile);
        v.FrameRate = obj.video{i}.FrameRate;
        open(v);
        
        obj.video{i}.CurrentTime = 0;
        arg.startTime = 0;
        arg.stopTime = obj.video{i}.Duration;
        
        if(strcmpi(arg.color, 'on'))
            temparray = zeros(obj.video{i}.Height,obj.video{i}.Width,3,arg.nFrame-1,'uint8');
            prevFrame = readFrame(obj.video{i});
            numfr = obj.video{i}.FrameRate*(arg.stopTime-arg.startTime)-arg.nFrame;
            progmeter(0);
            for indf = 1:arg.frameInterval:numfr-1
                progmeter(indf,numfr)
                temparray = temparray(:,:,:,[2:end 1]);
                currentFrame = readFrame(obj.video{i});
                temp = imsubtract(currentFrame,prevFrame);
                prevFrame = currentFrame;
                temparray(:,:,:,end) = temp;
                history = uint8(sum(temparray,4));
                writeVideo(v,imadd(history,currentFrame));
                obj.video{i}.CurrentTime = arg.startTime + (1/obj.video{i}.FrameRate)*indf;
                
            end
        else
            
            temparray = zeros(obj.video{i}.Height,obj.video{i}.Width,arg.nFrame-1,'uint8');
            prevFrame = rgb2gray(readFrame(obj.video{i}));
            numfr = obj.video{i}.FrameRate*(arg.stopTime-arg.startTime)-arg.nFrame;
            progmeter(0);
            for indf = 1:arg.frameInterval:numfr-1
                progmeter(indf,numfr)
                temparray = temparray(:,:,[2:end 1]);
                currentFrame = rgb2gray(readFrame(obj.video{i}));
                temp = imsubtract(currentFrame,prevFrame);
                prevFrame = currentFrame;
                temparray(:,:,end) = temp;
                history = uint8(sum(temparray,3));
                writeVideo(v,imadd(history,currentFrame));
                obj.video{i}.CurrentTime = arg.startTime + (1/obj.video{i}.FrameRate)*indf;
                
            end
        end
        
    end
    
end






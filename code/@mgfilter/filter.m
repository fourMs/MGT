function [retval,videoOut] = filter(obj,varargin)
%FILTER Summary of this function goes here


disp('this is the filter function');


arg = [];

%default parameters
arg.mg = [];
arg.fileList = [];
arg.filterflag = 0;
arg.filtertype = 'Regular';
arg.thresh = 0.1;
arg.color = 'off';
arg.invert = 'off';
arg.frameInterval = obj.frameInterval;
arg.fileCount = length(obj.video);

if(arg.fileCount <= 1)
    arg.startTime = obj.startTime;
    arg.stopTime = obj.stopTime;
end





for argi = 1:nargin-1

    if (strcmpi(varargin{argi},'Regular') || strcmpi(varargin{argi},'Binary') )
    disp('filtertype specified in argument');
    arg.filtertype = varargin{argi};
    arg.filterflag = 1;
    if(argi + 1 <= nargin-1 &&  isnumeric(varargin{argi + 1}))
        disp('thresh specified in argument');
        arg.thresh = varargin{argi+1};
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
    elseif (strcmpi(varargin{argi},'Gray'))
        disp('color mode on is specified in argument');
        arg.color = 'off'
    elseif (strcmpi(varargin{argi},'invert'))
        disp('invert mode on is specified in argument');
        arg.invert = 'on'
    elseif (strcmpi(varargin{argi},'Interval'))
        if(argi + 1 <= nargin-1 &&  isnumeric(varargin{argi + 1}))
            arg.frameInterval = varargin{argi+1};
        end
    end
end


filtertype = arg.filtertype;
thresh = arg.thresh;
filterflag = 1;
colorflag = [];
invertflag = [];


if(strcmpi(arg.color, 'on'))
    colorflag = true;
else
    colorflag = false;
end


if(strcmpi(arg.invert, 'on'))
    invertflag = true;
else
    invertflag = false;
end


if(arg.fileCount <= 1)
    obj.mg.video.gram.y = [];
    obj.mg.video.gram.x = [];
    obj.mg.video.qom = [];
    obj.mg.video.com = [];
    obj.mg.video.aom = [];
    obj.mg.video.wom = [];
    obj.mg.video.hom = [];

    
    [filepath,filename,ext] = fileparts(obj.video.Name);
    newfile = strcat(filename,'_motion.avi');
    v = VideoWriter(newfile);
    v.FrameRate = obj.video.FrameRate;
    open(v);
    
    fh = figure('visible','off');

    obj.video.CurrentTime = arg.startTime;
    numfr = obj.video.FrameRate*(arg.stopTime-arg.startTime);
    
    
    if colorflag == true
        fr1 = readFrame(obj.video);
    else
        fr1 = rgb2gray(readFrame(obj.video));
    end
    
    
    
 
    
    for i = 1:arg.frameInterval:numfr-1
        
        if colorflag == true
            fr2 = readFrame(obj.video);
        else
            fr2 = rgb2gray(readFrame(obj.video));
        end
        
        diff = abs(fr2-fr1);
        

        if colorflag == true
            
        else
             diff = abs(fr2-fr1);
            if filterflag
                diff = mgmotionfilter(diff,filtertype,thresh);
            end
        end
        

        
        if colorflag == true
            [com,qom] = mgcentroid(rgb2gray(diff));
        else
            [com,qom] = mgcentroid(diff);
        end
        
        
        
        obj.mg.video.qom = [obj.mg.video.qom;qom];
        obj.mg.video.com = [obj.mg.video.com;com];
        gramx = mean(diff);
        gramy = mean(diff,2);
        obj.mg.video.gram.y = [obj.mg.video.gram.y;gramx];
        obj.mg.video.gram.x = [obj.mg.video.gram.x,gramy];
        if invertflag == true
            diff = imcomplement(diff);
        end
        writeVideo(v,diff);
        fr1 = fr2;
        
        progmeter(obj.video.CurrentTime,obj.stopTime);
        obj.video.CurrentTime = arg.startTime + (1/obj.video.FrameRate)*i;
        
    end
    

    
    if invertflag == true
        obj.mg.video.gram.x = imcomplement(obj.mg.video.gram.x);
        obj.mg.video.gram.y = imcomplement(obj.mg.video.gram.y);
    end
  
    
    close(v);
    disp(['The motion video is created with name ',newfile]);


    % Write motiongrams to files
    tmpfile=strcat(filename,'_mgx.tiff');
    imwrite(obj.mg.video.gram.x, tmpfile);
    tmpfile=strcat(filename,'_mgy.tiff');
    imwrite(obj.mg.video.gram.y, tmpfile);
    

    
else
    for fileIndex = 1:arg.fileCount
        obj.mg{fileIndex}.video.gram.y = [];
        obj.mg{fileIndex}.video.gram.x = [];
        obj.mg{fileIndex}.video.qom = [];
        obj.mg{fileIndex}.video.com = [];
        obj.mg{fileIndex}.video.aom = [];
        obj.mg{fileIndex}.video.wom = [];
        obj.mg{fileIndex}.video.hom = [];


        [filepath,filename,ext] = fileparts(obj.video{fileIndex}.Name);
        newfile = strcat(filename,'_motion.avi');
        v = VideoWriter(newfile);
        v.FrameRate = obj.video{fileIndex}.FrameRate;
        open(v);

        fh = figure('visible','off');

        


        if colorflag == true
            fr1 = readFrame(obj.video{fileIndex});
        else
            fr1 = rgb2gray(readFrame(obj.video{fileIndex}));
        end


        obj.video{fileIndex}.CurrentTime = obj.startTime{fileIndex};
        numfr = obj.video{fileIndex}.FrameRate*(obj.stopTime{fileIndex}-obj.startTime{fileIndex});


        for i = 1:arg.frameInterval:numfr-1

            if colorflag == true
                fr2 = readFrame(obj.video{fileIndex});
            else
                fr2 = rgb2gray(readFrame(obj.video{fileIndex}));
            end

            diff = abs(fr2-fr1);


            if colorflag == true

            else
                 diff = abs(fr2-fr1);
                if filterflag
                    diff = mgmotionfilter(diff,filtertype,thresh);
                end
            end



            if colorflag == true
                [com,qom] = mgcentroid(rgb2gray(diff));
            else
                [com,qom] = mgcentroid(diff);
            end



            obj.mg{fileIndex}.video.qom = [obj.mg{fileIndex}.video.qom;qom];
            obj.mg{fileIndex}.video.com = [obj.mg{fileIndex}.video.com;com];
            gramx = mean(diff);
            gramy = mean(diff,2);
            obj.mg{fileIndex}.video.gram.y = [obj.mg{fileIndex}.video.gram.y;gramx];
            obj.mg{fileIndex}.video.gram.x = [obj.mg{fileIndex}.video.gram.x,gramy];
            if invertflag == true
                diff = imcomplement(diff);
            end
            writeVideo(v,diff);
            fr1 = fr2;

            progmeter(obj.video{fileIndex}.CurrentTime,obj.stopTime{fileIndex});
            obj.video{fileIndex}.CurrentTime = obj.startTime{fileIndex} + (1/obj.video{fileIndex}.FrameRate)*i;

        end


        if invertflag == true
            obj.mg{fileIndex}.video.gram.x = imcomplement(obj.mg{fileIndex}.video.gram.x);
            obj.mg{fileIndex}.video.gram.y = imcomplement(obj.mg{fileIndex}.video.gram.y);
        end

        
        close(v);
        disp(['The motion video is created with name ',newfile]);
        

        % Write motiongrams to files
        tmpfile=strcat(filename,'_mgx.tiff');
        imwrite(obj.mg{fileIndex}.video.gram.x, tmpfile);
        tmpfile=strcat(filename,'_mgy.tiff');
        imwrite(obj.mg{fileIndex}.video.gram.y, tmpfile);


        
    end
    
end



end


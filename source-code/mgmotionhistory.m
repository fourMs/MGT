function mgmotionhistory(vidfile,nframe,type,varargin)
% mgmotionhistory(vidfile,nframe,type,starttime,endtime) compute the motion history image
% it writes the motion history video back to disk.
% syntax:
% mgmotionhistory(vidfile) using defualt nframe = 5 to create grayscale motion
% history image
% mgmotionhistory(vidfile,nframe) using nframe to create grayscale motion
% image
% mgmotionhistory(vidfile,nframe,type,starttime,endtime)
%
% input:
% vidfile: video file name
% nframe: gives the number of frames to create motion history image,defualt
% value 5
% type: 'gray' or 'color'
% starttime: starting time of the video to create motion history image
% endtime: end time of the video to create motion history image
%
% output: a history video written back to disk
%
% example:
% mgmotionhistory(videofile,3,'gray',0,20)
% mgmotionhistory(videofile)
% mgmotionhistory(videofile,10,'color')

if nargin == 1 && ischar(vidfile)
    file = vidfile;
    [~,pr,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
        mg = mgvideoreader(file);
    else
        disp('please input a video file!');
        return
    end
    nf = 5;
    method = 'gray';
    starttime = mg.video.starttime;
    endtime = mg.video.endtime;
elseif nargin == 2 && ischar(vidfile)
    file = vidfile;
    if ischar(nframe)
        nf = 5;
        method = nframe;
    else
        method = 'gray';
        nf = nframe;
    end
    [~,pr,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
        mg = mgvideoreader(file);
    else
        disp('please input a video file!');
        return
    end
    starttime = mg.video.starttime;
    endtime = mg.video.endtime;
elseif nargin == 3 && ischar(vidfile)
    file = vidfile;
    nf = nframe;
    [~,pr,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
        mg = mgvideoreader(file);
    else
        disp('please input a video file!');
        return
    end
    if ischar(type)
        method = type;
    else
        disp('please input a proper type:gray or color');
        return
    end
    starttime = mg.video.starttime;
    endtime = mg.video.endtime;    
elseif nargin == 5 && ischar(vidfile)
    file = vidfile;
    nf = nframe;
    [~,pr,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
        mg = mgvideoreader(file);
    else
        disp('please input a video file!');
        return
    end
    if ischar(type)
        method = type;
    else
        disp('please input a proper type:gray or color');
        return
    end
    if length(varargin) == 1
        starttime = varargin{1};
        endtime = mg.video.endtime;
    elseif length(varargin) == 2
        starttime = varargin{1};
        endtime = varargin{2};
    end
end

mg.video.obj.CurrentTime = starttime;
newfile = strcat(pr,'history.avi');
v = VideoWriter(newfile);
v.FrameRate = mg.video.obj.FrameRate;
open(v);
if strcmpi(method,'gray')
    temparray = zeros(mg.video.obj.Height,mg.video.obj.Width,nf-1,'uint8');
    fr1 = rgb2gray(readFrame(mg.video.obj));
    fr2 = rgb2gray(readFrame(mg.video.obj));
    diff = imsubtract(fr2,fr1);
    temparray(:,:,1) = diff;
    history = diff;
    writeVideo(v,imadd(diff,fr2));
    for i = 1:nf-2
        nextf = rgb2gray(readFrame(mg.video.obj));
        temp = imsubtract(nextf,fr2);
        fr2 = nextf;
        temparray(:,:,i+1) = temp;
        history = imadd(temp,history);
        writeVideo(v,imadd(history,nextf));
    end
    while mg.video.obj.CurrentTime < endtime
        temparray = temparray(:,:,[2:end 1]);
        nextf = rgb2gray(readFrame(mg.video.obj));
        temp = imsubtract(nextf,fr2);
        fr2 = nextf;
        temparray(:,:,end) = temp;
        history = uint8(sum(temparray,3));
        writeVideo(v,imadd(history,nextf));
    end       
elseif strcmpi(method,'color')
    temparray = zeros(mg.video.obj.Height,mg.video.obj.Width,3,nf-1,'uint8');
    fr1 = readFrame(mg.video.obj);
    fr2 = readFrame(mg.video.obj);
    diff = imsubtract(fr2,fr1);
    temparray(:,:,:,1) = diff;
    history = diff;
    writeVideo(v,imadd(diff,fr2));
    for i = 1:nf-2
        nextf = readFrame(mg.video.obj);
        temp = imsubtract(nextf,fr2);
        fr2 = nextf;
        temparray(:,:,:,i+1) = temp;
        history = imadd(temp,history);
        writeVideo(v,imadd(history,nextf));
    end
    disp('*****creating motion history video*****')
    indf = 1;
    numfr = mg.video.obj.FrameRate*(endtime-starttime)-nf;
    while mg.video.obj.CurrentTime < endtime
        progmeter(indf,numfr)
        temparray = temparray(:,:,:,[2:end 1]);
        nextf = readFrame(mg.video.obj);
        temp = imsubtract(nextf,fr2);
        fr2 = nextf;
        temparray(:,:,:,end) = temp;
        history = uint8(sum(temparray,4));
        writeVideo(v,imadd(history,nextf));
        indf = indf + 1;
    end           
end
disp(['the motion history video is created with name ',newfile]);
close(v)

    

    
        
    

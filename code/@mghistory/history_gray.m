function [retval,videoOut] = history_gray(obj,varargin)
%HISTORY_GRAY Summary of this function goes here
%   Detailed explanation goes here



disp('*****creating motion history video : gray*****')

video = obj.video;
nFrame = obj.nFrame;
startTime = obj.startTime;
stopTime = obj.stopTime;
frameInterval = obj.frameInterval;



[~,pr,ex] = fileparts(video.Name);
newfile = strcat(pr,'_history.avi');
v = VideoWriter(newfile);
v.FrameRate = video.FrameRate;
open(v);


video.CurrentTime = startTime;
temparray = zeros(video.Height,video.Width,nFrame-1,'uint8');
prevFrame = rgb2gray(readFrame(video));

numfr = video.FrameRate*(stopTime-startTime)-nFrame;
progmeter(0);
for indf = 1:frameInterval:numfr-1
    progmeter(indf,numfr)
    temparray = temparray(:,:,[2:end 1]);
    currentFrame = rgb2gray(readFrame(video));
    temp = imsubtract(currentFrame,prevFrame);
    prevFrame = currentFrame;
    temparray(:,:,end) = temp;
    history = uint8(sum(temparray,3));
    writeVideo(v,imadd(history,currentFrame));
    video.CurrentTime = (1/video.FrameRate)*indf;
end


close(v);

videoOut = VideoReader(newfile);
retval = 0;

end


function mgwrite(mg,fileName)
% function for writing video files with audio sync
%
% mgwrite(mg)
% mgwrite(mg,fileName)
%
% INPUTS:
% mg - mgt data structure containing an audio and a video track
% fileName - file name of saved file (default: myFile.avi)
% 
% Requires 'Computer Vision System Toolbox 8.1'
% Only writes uncompressed video
% 
% Quicktime doesn't work for playing the audio, but VLC does
%
%

if nargin < 2
    fileName = 'myFile.avi';
end

sr = uncell(get(mg.audio.mir,'Sampling'));

audiosignal = zeros(sr*(mg.video.endtime-mg.video.starttime),1);
tmpaudio = mirgetdata(mg.audio.mir);
la = min([length(tmpaudio),length(audiosignal)]);
audiosignal(1:la) = tmpaudio(1:la);


numVF = mg.video.obj.FrameRate*(mg.video.endtime-mg.video.starttime);
numAF = size(audiosignal,1);
numAFperVF = floor(numAF/numVF);

videoFWriter = vision.VideoFileWriter(fileName, ...
                                      'FileFormat', 'AVI', ...
                                      'AudioInputPort', true, ...
                                      'FrameRate',  mg.video.obj.FrameRate);
                                      
mg.video.obj.CurrentTime = mg.video.starttime;
ind = 1;


while mg.video.obj.CurrentTime < mg.video.endtime
    progmeter(ind,numVF);
    fr = readFrame(mg.video.obj);

    step(videoFWriter, fr, audiosignal(numAFperVF*(ind-1)+1:numAFperVF*ind,:)); 
    
    ind = ind + 1;
end

release(videoFWriter);


end
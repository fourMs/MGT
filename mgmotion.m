function mg = mgmotion(varargin)
% function mg = mgmotion(varargin)
% mgmotion computes the motion image,motion gram,quantity of motion,
% centroid of motion from the video file or musical gestures data structure
% If the method is not given,default method 'Diff', with 'OpticalFlow' method
% mgmotion computes the optical flow field
% syntax: mg = mgmotion(mg);
% mg = mgmotion(filename);
% mg = mgmotion(mg,'Diff');
% mg = mgmotion(filename,'Diff',starttime,endtime);
% mg = mgmotion(filename,'OpticalFlow',starttime,endtime);
% mg = mgmotion(mg,'OpticalFlow');

% input:
% filename: the name of the video file
% 'Diff','OpticalFlow': indicate the methods used to compute the
% motion.'Diff' method takes the absolute difference value between
% two successive frames.'OpticalFlow' method uses the optical filed to estimate motion 
% mg: musical gestures data structure

% output: mg,a musical gestures data structure containing the computed motion
% image, motiongram, qom, com

% mg = mginitstruct;
if ischar(varargin{1})
    if nargin == 1
        file = varargin{1};
        method = 'Diff';
        starttime = 0;
        mg = mgvideoreader(file);
        endtime = mg.video.endtime;
    elseif nargin == 2
        file = varargin{1};
        method = varargin{2};
        starttime = 0;
        mg = mgvideoreader(file);
        endtime = mg.video.endtime;
    elseif nargin == 3
        file = varargin{1};
        starttime = varargin{3};
        method = varargin{2};
        mg = mgvideoreader(file,'Extract',starttime);
        endtime = mg.video.endtime;
    elseif nargin == 4
        file = varargin{1};
        starttime = varargin{3};
        endtime = varargin{4};
        method = varargin{2};
        mg = mgvideoreader(file,'Extract',starttime,endtime);
    end
    x = 1:mg.video.obj.Width;
    y = 1:mg.video.obj.Height;
elseif isstruct(varargin{1})
    if nargin == 1
        mg = varargin{1};
        method = 'Diff';
        starttime = mg.video.starttime;
        endtime = mg.video.endtime;
    elseif nargin == 2
        mg = varargin{1};
        method = varargin{2};
        starttime = mg.video.starttime;
        endtime = mg.video.endtime;
    elseif nargin == 3
        mg = varargin{1};
        starttime = varargin{3};
        method = varargin{2};
        endtime = mg.video.endtime;
    elseif nargin == 4
        mg = varargin{1};
        starttime = varargin{3};
        endtime = varargin{4};
        method = varargin{2};
    end
    x = 1:mg.video.obj.Width;
    y = 1:mg.video.obj.Height;
end
mg.video.method = method;
mg.video.gram.gramy = [];
mg.video.gram.gramx = [];
mg.video.qom = [];
mg.video.com = [];
mg.video.aom = [];
mg.video.starttime = starttime;
mg.video.endtime = endtime;
hblob = vision.BlobAnalysis;
hblob.AreaOutputPort = true;
if strcmp(method,'Diff')   
    mg.video.obj.CurrentTime = starttime;
    fr = rgb2gray(readFrame(mg.video.obj));
    v = VideoWriter('motion.avi');
    v.FrameRate = mg.video.obj.FrameRate;
    ind = 1;
    numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
    open(v);
    while mg.video.obj.CurrentTime < endtime
        progmeter(ind,numf);
        pfr = rgb2gray(readFrame(mg.video.obj));
        diff = abs(pfr-fr);
%         diff = mgmotionfilter(diff,'Binary',0.1);
%         diff = mgmotionfilter(diff,'Regular',0.2);
%         diff = mgmotionfilter(diff,'Blob',[0 1 0;1 1 1;0 1 0]);
        [com,qom] = mgcentroid(diff);
        hautoh = vision.Autothresholder;
        bw = step(hautoh,diff);
        aom = sum(step(hblob,bw));
        mg.video.aom = [mg.video.aom;aom];
        gramx = mean(diff);
        gramy = mean(diff,2);
        mg.video.gram.gramy = [mg.video.gram.gramy;gramx];
        mg.video.gram.gramx = [mg.video.gram.gramx,gramy];
        mg.video.qom = [mg.video.qom;qom];
        mg.video.com = [mg.video.com;com];
        writeVideo(v,diff);
        fr = pfr;
        ind = ind + 1;
    end
    close(v)
    mg.video.nframe = v.FrameCount;
%     mg.video.nframe = ind - 1;
    figure,subplot(211),plot(mg.video.qom)
    title('Quantity of motion by motiongram');
    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:mg.video.nframe])
    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:...
        2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
    xlabel('time(s)')
    ylabel('Quantity')
    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
    axis equal;
    title('Centroid of motion by motiongram');
    xlabel('x direction')
    ylabel('y direction')
    s = mgvideoreader('motion.avi');
    mg.video.obj = s.video.obj;
elseif strcmp(method,'OpticalFlow')
    mg.video.obj.CurrentTime = starttime;
%     v = VideoWriter('optical.avi');
    v.FrameRate = mg.video.obj.FrameRate;
    ind = 1;
    numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
%     open(v);
%     fh = figure('visible','off');
    fr1 = rgb2gray(readFrame(mg.video.obj));
    while mg.video.obj.CurrentTime < endtime
        progmeter(ind,numf);
        fr2 = rgb2gray(readFrame(mg.video.obj));
        flow = mgopticalflow(fr2,fr1);
        magnitude = flow.Magnitude;
        magnitude = mgmotionfilter(magnitude,'Binary',0.4);
%         magnitude = mgmotionfilter(magnitude,'Regular',0.4);
        qom = sum(sum(magnitude));
        [m,n] = size(magnitude);
        x = 1:n;
        y = 1:m;
        meanx = mean(magnitude);
        comx = x*meanx'/sum(meanx);
        meany = mean(magnitude,2);
        comy = y*meany/sum(meany);
        com = [comx,comy];
        gramx = mean(magnitude);
        gramy = mean(magnitude,2);
        mg.video.gram.gramy = [mg.video.gram.gramy;gramx];
        mg.video.gram.gramx = [mg.video.gram.gramx,gramy];
        mg.video.qom = [mg.video.qom;qom];
        mg.video.com = [mg.video.com;com];
%         imshow(fr1),hold on;
%         plot(flow,'DecimationFactor',[20 20],'ScaleFactor',10);
%         hold off;
%         writeVideo(v,getframe(fh));
        fr1 = fr2;
        ind = ind + 1;
    end
%     close(v)
    figure,subplot(211),plot(mg.video.qom)
    title('Quantity of motion by opticalflow');
    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:ind])
    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
    xlabel('time(s)')
    ylabel('Quantity')
    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
    axis equal
    title('Centroid of motion by opticalflow');
    xlabel('x direction')
    ylabel('y direction')
end
mg.video.obj.CurrentTime = 0;
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));




    
    

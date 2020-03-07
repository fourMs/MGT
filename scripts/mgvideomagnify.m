function mg = mgvideomagnify(varargin)
% mgvideomagnify magnifies a video with small variations, the magnified
% video is created with the name of 'original name+magnifyvideo.avi' and
% written back to disk.
% mg = mgvideomagnify(mg,'IIR',a1,a2,alpha,lambda_c,attenuation);
% mg = mgvideomagnify(mg,'Butter',a1,a2,alpha,lambda_c,samplingrate,attentuation)
% magnify the small movements in a video
%
% input:
% mg: input mg containing video or videofile
% med:'IIR','Butter';
% a1,a2: coeficients of two-order filter
% alpha:magnification factor
% lambda_c:spatial cutoff frequency
% attenuation;attenuation factor
%
% output:
% mg: contains magnified video
% 
% example:
% mg = mgvideomagnify('video.mp4','IIR',0.4,0.05,10,16,0.1);
% mg = mgvideomagnify('video.mp4','Butter',3.6,6.2,60,90,30,0.3)
addpath('./matlabPyrTools');
addpath('./matlabPyrTools/MEX');
if isempty(varargin)
    return;
end
l = length(varargin);
if l >=2
    med = varargin{2};
    if strcmp(med,'IIR') && l >=7
        a1 = varargin{3};
        a2 = varargin{4};
        alpha = varargin{5};
        lambda_c = varargin{6};
        attenuation = varargin{7};
    elseif strcmp(med,'Butter') && l >=8
        fl = varargin{3};
        fh = varargin{4};
        alpha = varargin{5};
        lambda_c = varargin{6};
        samplingrate = varargin{7};
        attenuation = varargin{8};
    elseif strcmp(med,'Ideal') && l >= 8
        fl = varargin{3};
        fh = varargin{4};
        alpha = varargin{5};
        lambda_c = varargin{6};
        samplingrate = varargin{7};
        attenuation = varargin{8};
    end
end 
    
if ischar(varargin{1})
    file = varargin{1};
    [~,pr,ex] = fileparts(file);
    if ismember(ex,{'.mp4';'.avi';'mpg';'mov';'m4v'})
        mg = mgvideoreader(file);
    else 
        error('unknown video format,please the video format');
    end
elseif isstruct(varargin{1}) && isfield(varargin{1},'video')
    mg = varargin{1};
    [~,pr,~] = fileparts(mg.video.obj.Name);
end
newfile = strcat(pr,'magnifyvideo.avi');
switch med
    case 'IIR'
    v = VideoWriter(newfile);
    v.FrameRate = mg.video.obj.FrameRate;
    open(v);
    mg.video.obj.CurrentTime = mg.video.starttime;
    fror = readFrame(mg.video.obj); 
    fr = im2double(fror);
    fr = rgb2ntsc(fr);
    [pyr(:,1),pind] = buildLpyr(fr(:,:,1),'auto');
    [pyr(:,2),~] = buildLpyr(fr(:,:,2),'auto');
    [pyr(:,3),~] = buildLpyr(fr(:,:,3),'auto');
    lp1 = pyr;
    lp2 = pyr;
    numfr = mg.video.obj.FrameRate*(mg.video.endtime-mg.video.starttime)-1;
    writeVideo(v,fror);
    indf = 1;
    while mg.video.obj.CurrentTime < mg.video.endtime;
    progmeter(indf,numfr);
    fror = readFrame(mg.video.obj);
    fr = im2double(fror);
    fr = rgb2ntsc(fr);
    [pyr(:,1),~] = buildLpyr(fr(:,:,1),'auto');
    [pyr(:,2),~] = buildLpyr(fr(:,:,2),'auto');
    [pyr(:,3),~] = buildLpyr(fr(:,:,3),'auto');
    lp1 = (1-a1)*lp1 + a1*pyr;
    lp2 = (1-a2)*lp2 + a2*pyr;
    lp = lp1- lp2;
    ind = size(pyr,1);
    delta = lambda_c/8/(1+alpha);
    ex_factor = 2;
    lambda = (mg.video.obj.Height^2+mg.video.obj.Width^2).^0.5/3;
    for i = size(pind,1):-1:1
        index = ind - prod(pind(i,:))+1:ind;
        currAlpha = (lambda/delta/8-1)*ex_factor;
        if i == size(pind,1) || i == 1
            lp(index,:) = 0;
        elseif currAlpha > alpha
            lp(index,:) = alpha*lp(index,:);
        else 
            lp(index,:) = currAlpha*lp(index,:);
        end
        ind = ind - prod(pind(i,:));
        lambda = lambda/2;
    end
    relp(:,:,1) = reconLpyr(lp(:,1),pind);
    relp(:,:,2) = reconLpyr(lp(:,2),pind)*attenuation;
    relp(:,:,3) = reconLpyr(lp(:,3),pind)*attenuation;
    relp = relp + fr;
    relp = ntsc2rgb(relp);
    relp(relp > 1) = 1;
    relp(relp < 0) =0;
    writeVideo(v,im2uint8(relp));
    indf = indf + 1;
    end
    close(v);
    s = mgvideoreader(newfile);
    mg.video.obj = s.video.obj;
    
    case 'Butter'
        [l_a,l_b] = butter(1,fl/samplingrate,'low');
        [h_a,h_b] = butter(1,fh/samplingrate,'low');
        
        
        v = VideoWriter(newfile);
        v.FrameRate = mg.video.obj.FrameRate;
        open(v);
        mg.video.obj.CurrentTime = mg.video.starttime;
        fror = readFrame(mg.video.obj); 
        fr = im2double(fror);
        fr = rgb2ntsc(fr);
        [pyr(:,1),pind] = buildLpyr(fr(:,:,1),'auto');
        [pyr(:,2),~] = buildLpyr(fr(:,:,2),'auto');
        [pyr(:,3),~] = buildLpyr(fr(:,:,3),'auto');
        lp1 = pyr;
        lp2 = pyr;
        pre_pyr = pyr;
        numfr = mg.video.obj.FrameRate*(mg.video.endtime-mg.video.starttime)-1;
        writeVideo(v,fror);
        indf = 1;
        while mg.video.obj.CurrentTime < mg.video.endtime
            progmeter(indf,numfr);
            fror = readFrame(mg.video.obj);
            fr = im2double(fror);
            fr = rgb2ntsc(fr);
            [pyr(:,1),~] = buildLpyr(fr(:,:,1),'auto');
            [pyr(:,2),~] = buildLpyr(fr(:,:,2),'auto');
            [pyr(:,3),~] = buildLpyr(fr(:,:,3),'auto');
            lp1 = (-h_b(2).*lp1 + h_a(1).*pyr + h_a(2).*pre_pyr)./h_b(1); 
            lp2 = (-l_b(2).*lp2 + l_a(1).*pyr + l_a(2).*pre_pyr)./l_b(1);
            lp = lp1- lp2;
            pre_pyr = pyr;
            ind = size(pyr,1);
            delta = lambda_c/8/(1+alpha);
            ex_factor = 2;
            lambda = (mg.video.obj.Height^2+mg.video.obj.Width^2).^0.5/3;
            for i = size(pind,1):-1:1
                index = ind - prod(pind(i,:))+1:ind;
                currAlpha = (lambda/delta/8-1)*ex_factor;
                if i == size(pind,1) || i == 1
                    lp(index,:) = 0;
                elseif currAlpha > alpha
                    lp(index,:) = alpha*lp(index,:);
                else 
                    lp(index,:) = currAlpha*lp(index,:);
                end
                ind = ind - prod(pind(i,:));
                lambda = lambda/2;
            end
            relp(:,:,1) = reconLpyr(lp(:,1),pind);
            relp(:,:,2) = reconLpyr(lp(:,2),pind)*attenuation;
            relp(:,:,3) = reconLpyr(lp(:,3),pind)*attenuation;
            relp = relp + fr;
            relp = ntsc2rgb(relp);
            relp(relp > 1) = 1;
            relp(relp < 0) =0;
            writeVideo(v,im2uint8(relp));
            indf = indf + 1;
        end
        close(v);
        s = mgvideoreader(newfile);
        mg.video.obj = s.video.obj;
    case 'Ideal'
        v = VideoWriter(newfile);
        v.FrameRate = mg.video.obj.FrameRate;
        open(v);
        startind = 1;
        mg.video.obj.CurrentTime = mg.video.starttime;
        endind = mg.video.obj.FrameRate*mg.video.obj.Duration;
        [pyr,pind] = build_Lpyr_stack(mg,startind,endind);
        filter_pyr = ideal_bandpassing(pyr,3,fl,fh,samplingrate);
        ind = size(pyr(:,1,1),1);
        delta = lambda_c/8/(1+alpha);
        ex_factor = 2;
        lambda = (mg.video.obj.Height^2+mg.video.obj.Width^2).^0.5/3;
        for i = size(pind,1):-1:1
            index = ind-prod(pind(i,:))+1:ind;
            currAlpha = (lambda/delta/8-1)*ex_factor;
            if (i == size(pind,1) || i == 1)
                filter_pyr(index,:,:) = 0;
            elseif (currAlpha > alpha)
                filter_pyr(index,:,:) = alpha*filter_pyr(index,:,:);
            end
            ind = ind - prod(pind(i,:));
            lambda = lambda/2;
        end
        indf = 1;
        numf = mg.video.obj.FrameRate*mg.video.obj.Duration;
        while mg.video.obj.CurrentTime < mg.video.endtime
            progmeter(indf,numf);
            frame = readFrame(mg.video.obj);
            rgbframe = im2double(frame);
            frame = rgb2ntsc(rgbframe);
            filter(:,:,1) = reconLpyr(filter_pyr(:,1,indf),pind);
            filter(:,:,2) = reconLpyr(filter_pyr(:,2,indf),pind)*attenuation;
            filter(:,:,3) = reconLpyr(filter_pyr(:,3,indf),pind)*attenuation;
            filter = filter + frame;
            frame = ntsc2rgb(filter);
            frame(frame>1) = 1;
            frame(frame<0) = 0;
            wirteVideo(v,im2unit8(frame));
            indf = indf + 1;
        end
        close(v);
        s = mgvideoreader(newfile);
        mg.video.obj = s.video.obj;                               
end


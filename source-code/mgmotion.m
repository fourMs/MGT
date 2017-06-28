function mg = mgmotion(f,varargin)
%MGMOTION - Calculate various motion features from a video file
% mgmotion computes a motion image, motiongram, quantity of motion, centroid of
% motion, width of motion, and height of motion from the video file or musical
% gestures data structure. The default method is frame differencing ('Diff'),
% and an optical flow field can be calculated with the 'OpticalFlow' method. The
% founction also provides the color and convert mode, which is to compute the
% color scale or convert white on black. To use the mode, you need to set mode
% in the command, e.g.,
% mg.video.mode.color = 'On'
% mg.video.mode.convert = 'On'
%
% syntax:
% mg = mgmotion(mg,method,starttime,endtime,filtertype,thresh)
% mg = mgmotion(filename);
% mg = mgmotion(mg,'Diff');
% mg = mgmotion(filename,'Diff',starttime,endtime,'Regular',0.3);
% mg = mgmotion(filename,'OpticalFlow',starttime,'Binary',0.2);
% mg = mgmotion(mg,'OpticalFlow');
%
% input:
% filename: the name of the video file
% 'Diff', 'OpticalFlow': indicate the methods used to compute the
% motion. 'Diff' method takes the absolute difference value between
% two successive frames. 'OpticalFlow' method uses the optical filed to estimate motion
% mg: musical gestures data structure
% filtertype: Binary, Regular, Blob, when choose the Blob, the element
% structure need be constructed using function strel
% thresh: threshold [0,1]
%
% output:
% mg, a musical gestures data structure containing the computed motion
% image, motiongram, qom, com

% mg = mginitstruct;
thres = 0.05;
l = length(varargin);
if ischar(f)
    if l < 1
        method = 'Diff'; % default;
        starttime = 0;
        mg = mgvideoreader(f);
        endtime = mg.video.endtime;
        filterflag = 0;
    elseif l == 1
        if strcmpi(varargin{1},'Diff') || strcmpi(varargin{1},'OpticalFlow')
            method = varargin{1};
            starttime = 0;
            mg = mgvideoreader(f);
            endtime = mg.video.endtime;
            filterflag = 0;
        else
            error('please specify a method for motion estimation,Diff or OpticalFlow.');
        end
    elseif l == 2
        if strcmpi(varargin{1},'Diff') || strcmpi(varargin{1},'OpticalFlow')
            method = varargin{1};
            if isnumeric(varargin{2})
                starttime = varargin{2};
                mg = mgvideoreader(f,'Extract',starttime);
                endtime = mg.video.endtime;
                filterflag = 0;
            elseif ischar(varargin{2})&& (strcmpi(varargin{2},'Regular') || strcmpi(varargin{2},'Binary'))
                starttime = 0;
                mg = mgvideoreader(f);
                endtime = mg.video.endtime;
                filtertype = varargin{2};
                thres = 0.2; % default;
                filterflag = 1;
            else
                error('Please specify a filter type, Regular or Binary');
            end
        else
            error('Please specify a method for motion estimation, Diff or OpticalFlow');
        end
    elseif l == 3
        if strcmpi(varargin{1},'Diff') || strcmpi(varargin{1},'OpticalFlow')
            method = varargin{1};
            if isnumeric(varargin{2})  && isnumeric(varargin{3})
                starttime = varargin{2};
                endtime = varargin{3};
                mg = mgvideoreader(f,'Extract',starttime,endtime);
                filterflag = 0;
            elseif isnumeric(varargin{2}) && ischar(varargin{3})
                starttime = varargin{2};
                mg = mgvideoreader(f,'Extract',starttime);
                endtime = mg.video.endtime;
                filtertype = varargin{3};
                filterflag = 1;
                thres = 0.2; % default;
            elseif ischar(varargin{2})
                starttime = 0;
                mg = mgvideoreader(f);
                endtime = mg.video.endtime;
                filtertype = varargin{2};
                thres = varargin{3};
                filterflag = 1;
            else
                error('Please input proper parameters.');
            end
        else
            error('please specify a method for motion estimation,Diff or OpticalFlow.');
        end
    elseif l == 4
        if strcmpi(varargin{1},'Diff') || strcmpi(varargin{1},'OpticalFlow')
            method = varargin{1};
            if isnumeric(varargin{2}) && isnumeric(varargin{3}) && ismember(lower(varargin{4}),lower({'Binary','Regular'}))
                starttime = varargin{2};
                endtime = varargin{3};
                mg = mgvideoreader(f,'Extract',starttime,endtime);
                filtertype = varargin{4};
                thres = 0.2;
                filterflag = 1;
            elseif isnumeric(varargin{2}) && ischar(varargin{3}) && isnumeric(varargin{4})
                starttime = varargin{2};
                mg = mgvideoreader(f,'Extract',starttime);
                endtime = mg.video.endtime;
                filtertype = varargin{3};
                thres = varargin{4};
                filterflag = 1;
            else
                error('Please input proper parameters.');
            end
        else
            error('Please specify a method for motion estimation,Diff or OpticalFlow');
        end
    elseif l == 5
        if ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'}))
            method = varargin{1};
            if isnumeric(varargin{2}) && isnumeric(varargin{3}) && ismember(lower(varargin{4}),lower({'Binary','Regular','Blob'})) && isnumeric(varargin{5})
                starttime = varargin{2};
                endtime = varargin{3};
                mg = mgvideoreader(f,'Extract',starttime,endtime);
                filtertype = varargin{4};
                filterflag = 1;
                thres = varargin{5};
            else
                error('Please input proper parameters.');
            end
        else
            error('Please specify a method for motion estimation,Diff or OpticalFlow');
        end
    end
elseif isstruct(f) && isfield(f,'video')
    mg = f;
    if l < 1
        method = 'Diff';
        starttime = mg.video.starttime;
        endtime = mg.video.endtime;
        filterflag = 0;
    elseif l == 1
        if ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'}))
            method = varargin{1};
            starttime = mg.video.starttime;
            endtime = mg.video.endtime;
            filterflag = 0;
        else
            error('Please specify a method for motion estimation.');
        end
    elseif l == 2
        if ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'})) && isnumeric(varargin{2})
            method = varargin{1};
            starttime = varargin{2};
            endtime = mg.video.endtime;
            filterflag = 0;
        elseif ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'})) && ismember(lower(varargin{2}),lower({'Binary','Regular'}))
            method = varargin{1};
            filtertype = varargin{2};
            filterflag = 1;
            starttime = mg.video.starttime;
            endtime = mg.video.endtime;
            thres = 0.2; % default;
        else
            error('Please specify a method for motion estimation,Diff or OpticalFlow');
        end
    elseif l == 3
        if ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'}))
            method = varargin{1};
            if isnumeric(varargin{2}) && isnumeric(varargin{3})
                starttime = varargin{2};
                endtime = varargin{3};
                filterflag = 0;
            elseif isnumeric(varargin{2}) && ismember(lower(varargin{3}),lower({'Binary','Regular'}))
                starttime = varargin{2};
                endtime = mg.video.endtime;
                filtertype = varargin{3};
                thres = 0.2;
                filterflag = 1;
            elseif ischar(varargin{2}) && isnumeric(varargin{3})
                starttime = mg.video.starttime;
                endtime = mg.video.endtime;
                filtertype = varargin{2};
                filterflag = 1;
                thres = varargin{3};
            else
                error('Please input proper parameters')
            end
        else
            error('Please specify a method for motion estimation');
        end
    elseif l == 4
        if ismember(lower(varargin{1}),lower({'Diff','OpticalFlow'}))
            method = varargin{1};
            if isnumeric(varargin{2}) && isnumeric(varargin{3}) && ismember(lower(varargin{4}),lower({'Binary','Regular'}))
                starttime = varargin{2};
                endtime = varargin{3};
                filtertype = varargin{4};
                thres = 0.2;
                filterflag = 1;
            elseif isnumeric(varargin{2}) && ischar(varargin{3}) && isnumeric(varargin{4})
                starttime = varargin{2};
                endtime = mg.video.endtime;
                filtertype = varargin{3};
                thres = varargin{4};
                filterflag = 1;
            else
                error('Please input proper parameters');
            end
        else
            error('Please specify a method for motion estimation');
        end
    elseif l == 5
        if ischar(varargin{1}) && ischar(varargin{4})
            method = varargin{1};
            starttime = varargin{2};
            endtime = varargin{3};
            filtertype = varargin{4};
            thres = varargin{5};
            filterflag = 1;
        else
            error('Please check the input parameters');
        end
    else
        error('Wrong number of input parameters');
    end
end
mg.video.method = method;
mg.video.gram.y = [];
mg.video.gram.x = [];
mg.video.qom = [];
mg.video.com = [];
mg.video.aom = [];
mg.video.wom = [];
mg.video.hom = [];
mg.video.starttime = starttime;
mg.video.endtime = endtime;
% hblob = vision.BlobAnalysis;
% hblob.AreaOutputPort = true;
if isfield(mg.video,'mode') && isfield(mg.video.mode,'color')
    if strcmpi(mg.video.mode.color,'on')
        colorflag = true;
    else
        colorflag = false;
    end
else
    colorflag = false;
end

if isfield(mg.video,'mode') && isfield(mg.video.mode,'convert')
    if strcmpi(mg.video.mode.convert,'on')
        convertflag = true;
    else
        convertflag = false;
    end
else
    convertflag = false;
end

if strcmpi(method,'Diff')
    mg.video.obj.CurrentTime = starttime;
    if colorflag == true
        fr = readFrame(mg.video.obj);
    else
        fr = rgb2gray(readFrame(mg.video.obj));
    end
    [~,pr,~] = fileparts(mg.video.obj.Name);
    newfile = strcat(pr,'_motion.avi');
    v = VideoWriter(newfile);
    v.FrameRate = mg.video.obj.FrameRate;
    ind = 1;
    numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
    open(v);
    if colorflag == true
        while mg.video.obj.CurrentTime < endtime
            progmeter(ind,numf);
            pfr = readFrame(mg.video.obj);
            diff = abs(pfr-fr);
            if filterflag
                for i = 1:size(diff,3)
                    diff(:,:,i) = mgmotionfilter(diff(:,:,i),filtertype,thres);
                end
            end
            [com,qom] = mgcentroid(rgb2gray(diff));
%             hautoh = vision.Autothresholder;
%             level = multithresh(rgb2gray(diff));
%             bw = step(hautoh,rgb2gray(diff));
%             bw = rgb2gray(diff) >= level;
%             aom = sum(step(hblob,bw));
            [bbox,aom] = findboundingbox(diff);
            mg.video.wom = [mg.video.wom;bbox(3)];
            mg.video.hom = [mg.video.hom;bbox(4)];
            mg.video.aom = [mg.video.aom;aom];
            mg.video.qom = [mg.video.qom;qom];
            mg.video.com = [mg.video.com;com];
            gramx = mean(diff);
            gramy = mean(diff,2);
            mg.video.gram.y = [mg.video.gram.y;gramx];
            mg.video.gram.x = [mg.video.gram.x,gramy];
            if convertflag == true
               diff = imcomplement(diff);
            end
            writeVideo(v,diff);
            fr = pfr;
            ind = ind + 1;
        end
        if convertflag == true
            mg.video.gram.x = imcomplement(mg.video.gram.x);
            mg.video.gram.y = imcomplement(mg.video.gram.y);
        end
    else
        while mg.video.obj.CurrentTime < endtime
            progmeter(ind,numf);
            pfr = rgb2gray(readFrame(mg.video.obj));
            diff = abs(pfr-fr);
            if filterflag
                diff = mgmotionfilter(diff,filtertype,thres);
            end
            [com,qom] = mgcentroid(diff);
%             hautoh = vision.Autothresholder;
%             level = multithresh(diff);
%             bw = imquantize(diff,level);
%             bw = diff >= level;
%             bw = step(hautoh,diff);
%             aom = sum(step(hblob,bw));
%            [bbox,aom] = findboundingbox(diff);
%            mg.video.aom = [mg.video.aom;aom];
%            mg.video.wom = [mg.video.wom;bbox(3)];
%            mg.video.hom = [mg.video.hom;bbox(4)];
            gramx = mean(diff);
            gramy = mean(diff,2);
            mg.video.gram.y = [mg.video.gram.y;gramx];
            mg.video.gram.x = [mg.video.gram.x,gramy];
            mg.video.qom = [mg.video.qom;qom];
            mg.video.com = [mg.video.com;com];
            if convertflag == true
               diff = imcomplement(diff);
            end
            writeVideo(v,diff);
            fr = pfr;
            ind = ind + 1;
        end
        if convertflag == true
            mg.video.gram.y = imcomplement(mg.video.gram.y);
            mg.video.gram.x = imcomplement(mg.video.gram.x);
        end
    end
    close(v)
    disp(' ');
    disp(['The motion video is created with name ',newfile]);
    mg.video.nframe = v.FrameCount;
%     mg.video.nframe = ind - 1;

    % Write motiongrams to files
    tmpfile=strcat(pr,'_mgx.tiff');
    imwrite(mg.video.gram.x, tmpfile);
    tmpfile=strcat(pr,'_mgy.tiff');
    imwrite(mg.video.gram.y, tmpfile);

    % Plot graphs
%    figure,subplot(211),plot(mg.video.qom)
%    title('Quantity of Motion');
%    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:mg.video.nframe])
%    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:...
%        2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
%    xlabel('Time (s)')
%    ylabel('Quantity')
%    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
%    axis equal;
%    title('Centroid of Motion');
%    xlabel('x direction')
%    ylabel('y direction')
    s = mgvideoreader(newfile);
    mg.video.obj = s.video.obj;
elseif strcmpi(method,'OpticalFlow')
    mg.video.obj.CurrentTime = starttime;
    [~,pr,~] = fileparts(mg.video.obj.Name);
    newfile = strcat(pr,'_flow.avi');
    v = VideoWriter(newfile);
    v.FrameRate = mg.video.obj.FrameRate;
    ind = 1;
    numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
    open(v);
    fh = figure('visible','off');
    fr1 = rgb2gray(readFrame(mg.video.obj));
    while mg.video.obj.CurrentTime < endtime
        progmeter(ind,numf);
        fr2 = rgb2gray(readFrame(mg.video.obj));
        flow = mgopticalflow(fr2,fr1);
        magnitude = flow.Magnitude;
        if filterflag
            magnitude = mgmotionfilter(magnitude,filtertype,thres);
        end
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
        mg.video.gram.y = [mg.video.gram.y;gramx];
        mg.video.gram.x = [mg.video.gram.x,gramy];
        mg.video.qom = [mg.video.qom;qom];
        mg.video.com = [mg.video.com;com];
        imshow(fr1),hold on;
        plot(flow,'DecimationFactor',[20 20],'ScaleFactor',10);
        hold off;
        writeVideo(v,getframe(fh));
        fr1 = fr2;
        ind = ind + 1;
    end
    close(v)
    disp(' ');
    disp(['The motion video is created with name ',newfile]);

%    figure,subplot(211),plot(mg.video.qom)
%    title('Quantity of motion by opticalflow');
%    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:ind])
%    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
%    xlabel('Time (s)')
%    ylabel('Quantity')
%    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
%    axis equal
%    title('Centroid of motion by opticalflow');
%    xlabel('x direction')
%    ylabel('y direction')
end
mg.video.obj.CurrentTime = 0;
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));

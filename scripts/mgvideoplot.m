function mgvideoplot(varargin)
% function mgvideoplot(varargin)
% mgvideoplot plots the motion image, motiongrams mocap grams over time
% syntax: mgvideoplot(mg,'Converted','On')
% mgvideoplot(mg,'Converted','Off')
% input:
% mg: musical gestures data structure containing video and mocap data at
% least
% output:
% a figure showing the motion image ,motion grams,mocap gram
% comments:the motion should computed by 'Diff' method.

l = length(varargin);
positionVector1 = [0.075, 0.5, 0.4, 0.4];
positionVector2 = [0.5, 0.5, 0.4, 0.4];
positionVector3 = [0.075, 0.05, 0.4, 0.4];
positionVector4 = [0.55, 0.05,0.35,0.4];
if ischar(varargin{1})
    motionfile = varargin{1};
    [~,~,ex] = fileparts(motionfile);
    if ismember(ex,{'.mp4';'.avi';'.mov';'.m4v';'.mpg'})
        mgmotion = mgvideoreader(motionfile);
        m = mgmotion.video.obj.Height;
        n = mgmotion.video.obj.Width;
        tmp1 = zeros(m,n);
        tmp2 = zeros(m,n);
    else
        error('unknown video format,please check the video file');
    end
    if l == 1;
        type = 'Off';
    elseif l == 3 && strcmpi(varargin{2},'Converted')
        type =  varargin{3};
    end
elseif isstruct(varargin{1})
    if isfield(varargin{1},'video')
        mgmotion = varargin{1};
    elseif isfield(varargin{1},'obj')
        mgmotion.video = varargin{1};
    end
    if l == 1
        type = 'Off';
    elseif l == 3 && strcmp(varargin{2},'Converted')
        type = varargin{3};
    end
    m = mgmotion.video.obj.Height;
    n = mgmotion.video.obj.Width;
    tmp1 = zeros(m,n);
    tmp2 = zeros(m,n);
end
i = 1;
while hasFrame(mgmotion.video.obj)
    tmp = readFrame(mgmotion.video.obj);
    subplot('Position',positionVector1)
    imshow(tmp);
    title('motion image')
    pause(1/mgmotion.video.obj.FrameRate);
    subplot('Position',positionVector2)
    if strcmp(type,'Off')
    if isfield(mgmotion.video,'gram') && i > n
        tmp1 = mgmotion.video.gram.x(:,i-n+1:i);
        imshow(tmp1,[])
        title('Horizontal motiongram')
    elseif isfield(mgmotion.video,'gram')
        tmp1(:,1:i) = mgmotion.video.gram.x(:,1:i);
        imshow(tmp1,[])
        title('Horizontal motiongram')
    end
    subplot('Position',positionVector3);
    if isfield(mgmotion.video,'gram') && i > m
        tmp2 = mgmotion.video.gram.y(i-m+1:i,:);
        imshow(tmp2,[])
        title('Vertical motiongram')
    elseif isfield(mgmotion.video,'gram')
        tmp2(1:i,:) = mgmotion.video.gram.y(1:i,:);
        imshow(tmp2,[]);
        title('Vertical motiongram')
    end
    tmp3 = mctrim(mgmotion.mocap,(i-1)/30,i/30);
    rgb = mgmocapgram(tmp3);
    subplot('Position',positionVector4);
    image([0 mgmotion.mocap.nFrames/mgmotion.mocap.freq],[1 mgmotion.mocap.nMarkers],rgb);
    ax = gca;
    ax.XTickLabel = [0:1/60:1/30];
    ax.XTickLabel = [(i-1)/30:1/60:i/30];
    if ~isempty(mgmotion.mocap.markerName)
        if ischar(mgmotion.mocap.markerName{1})
             set(gca,'YTick',1:mgmotion.mocap.nMarkers,'YTickLabel',mgmotion.mocap.markerName)
         elseif iscell(mgmotion.mocap.markerName{1})
             set(gca,'YTick',1:mgmotion.mocap.nMarkers,'YTickLabel',[mgmotion.mocap.markerName{:}])
        else
             disp('unknown markerName type')
        end
    end

    xlabel('Time (s)')
    title('mocapgram')
    pause(1/mgmotion.video.obj.FrameRate);
    elseif strcmp(type,'On')
        subplot('Position',positionVector2);
        if isfield(mgmotion.video,'gram') && i > n
            tmp1 = imcomplement(mgmotion.video.gram.x(:,i-n+1:i));
            imshow(tmp1,[])
            title('Horizontal motiongram')
        elseif isfield(mgmotion.video,'gram')
            tmp1(:,1:i) = imcomplement(mgmotion.video.gram.x(:,1:i));
            imshow(tmp1,[])
            title('Horizontal motiongram')
        end
        subplot('Position',positionVector3);
        if isfield(mgmotion.video,'gram') && i > m
            tmp2 = imcomplement(mgmotion.video.gram.y(i-m+1,:));
            imshow(tmp2,[])
            title('Vertical motiongram')
        elseif isfield(mgmotion.video,'gram')
            tmp2(1:i,:) = imcomplement(mgmotion.video.gram.y(1:i,:));
            imshow(tmp2,[]);
            title('Vertical motiongram')
        end
        tmp3 = mctrim(mgmotion.mocap,(i-1)/30,i/30);
        rgb = mgmocapgram(tmp3);
        subplot('Position',positionVector4);
        image([0 mgmotion.mocap.nFrames/mgmotion.mocap.freq],[1 mgmotion.mocap.nMarkers],rgb);
        ax = gca;
        ax.XTickLabel = [0:1/60:1/30];
        ax.XTickLabel = [(i-1)/30:1/60:i/30];
        if ~isempty(mgmotion.mocap.markerName)
            if ischar(mgmotion.mocap.markerName{1})
                 set(gca,'YTick',1:mgmotion.mocap.nMarkers,'YTickLabel',mgmotion.mocap.markerName)
            elseif iscell(mgmotion.mocap.markerName{1})
                 set(gca,'YTick',1:mgmotion.mocap.nMarkers,'YTickLabel',[mgmotion.mocap.markerName{:}])
            else
                 disp('unknown markerName type')
            end
        end
        xlabel('time(s)')
        title('mocapgram')
        pause(1/mgmotion.video.obj.FrameRate);
    end
   i = i + 1;
  
   if(  (round((i/30) * mgmotion.mocap.freq) + 1) > mgmotion.mocap.nFrames)
    break;
   end
   
end

function mgvideoplot(varargin)
% function mgvideoplot(varargin)
% mgvideoplot plots the motion image,motion grams mocap grams over time
% syntax: mgvideoplot(mg,'Converted','On')
% mgvideoplot(mg,'Converted','Off')

% input:
% mg: musical gestures data structure containing video and mocap data at
% least

% output:
% a figure showing the motion image ,motion grams,mocap gram

% comments:the motion should computed by 'Diff' method.

l = length(varargin);
mg = varargin{1};
if isfield(mg,'mocap')
    positionVector1 = [0.075, 0.5, 0.4, 0.4];
    positionVector2 = [0.5, 0.5, 0.4, 0.4];
    positionVector3 = [0.075, 0.05, 0.4, 0.4];
    positionVector4 = [0.55, 0.05,0.35,0.4];
else
    positionVector1 = [0.075, 0.5, 0.4, 0.4];
    positionVector2 = [0.5, 0.5, 0.4, 0.4];
    positionVector3 = [0.075, 0.05, 0.4, 0.4];
end

med = varargin{2};
switch med
    case 'Motiongram'
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
            if l == 2;
                type = 'Off';
            elseif l == 4 && strcmp(varargin{3},'Converted')
                type =  varargin{4};
            end
        elseif isstruct(varargin{1})
            if isfield(varargin{1},'video')
                mgmotion = varargin{1};
            elseif isfield(varargin{1},'obj')
                mgmotion.video = varargin{1};
            end
            if l == 2
                type = 'Off';
            elseif l == 4 && strcmp(varargin{3},'Converted')
                type = varargin{4};
            end   
            m = mgmotion.video.obj.Height;
            n = mgmotion.video.obj.Width;
            tmp1 = zeros(m,n);
            tmp2 = zeros(m,n);
        end
    i = 1;
    figure;
    while hasFrame(mgmotion.video.obj)
        tmp = readFrame(mgmotion.video.obj);
        subplot('Position',positionVector1)
        imshow(tmp);
        title('motion image')
        pause(1/mgmotion.video.obj.FrameRate);
        subplot('Position',positionVector2)
        if strcmp(type,'Off')
            if isfield(mgmotion.video,'gram') && i > n
                tmp1 = mgmotion.video.gram.gramx(:,i-n+1:i);
                imshow(tmp1,[])
                title('Horizontal motiongram')
            elseif isfield(mgmotion.video,'gram')
                tmp1(:,1:i) = mgmotion.video.gram.gramx(:,1:i);
                imshow(tmp1,[])
                title('Horizontal motiongram')
            end
            subplot('Position',positionVector3);
            if isfield(mgmotion.video,'gram') && i > m
                tmp2 = mgmotion.video.gram.gramy(i-m+1:i,:);
                imshow(tmp2,[])
                title('Vertical motiongram')
            elseif isfield(mgmotion.video,'gram')
                tmp2(1:i,:) = mgmotion.video.gram.gramy(1:i,:);
                imshow(tmp2,[]);
                title('Vertical motiongram')
            end
            if isfield(mg,'mocap')
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
            end
            pause(1/mgmotion.video.obj.FrameRate);
            
         elseif strcmp(type,'On')
            subplot('Position',positionVector2);
            if isfield(mgmotion.video,'gram') && i > n
                tmp1 = imcomplement(mgmotion.video.gram.gramx(:,i-n+1:i));
                imshow(tmp1,[])
                title('Horizontal motiongram')
            elseif isfield(mgmotion.video,'gram')
                tmp1(:,1:i) = imcomplement(mgmotion.video.gram.gramx(:,1:i));
                imshow(tmp1,[])
                title('Horizontal motiongram')
            end
            subplot('Position',positionVector3);
            if isfield(mgmotion.video,'gram') && i > m
                tmp2 = imcomplement(mgmotion.video.gram.gramy(i-m+1,:));
                imshow(tmp2,[])
                title('Vertical motiongram')
            elseif isfield(mgmotion.video,'gram')
                tmp2(1:i,:) = imcomplement(mgmotion.video.gram.gramy(1:i,:));
                imshow(tmp2,[]);
                title('Vertical motiongram')
            end
            if isfield(mg,'mocap')
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
            end
            pause(1/mgmotion.video.obj.FrameRate);
        end
        i = i + 1;
    end
        
    case 'Boundingbox'
          hblob = vision.BlobAnalysis;
          hblob.BoundingBoxOutputPort = true;
          hblob.AreaOutputPort = true;
          hblob.CentroidOutputPort = true;
          thres = vision.Autothresholder;
          fr = rgb2gray(readFrame(mg.video.obj));
          while hasFrame(mg.video.obj)
              pfr = readFrame(mg.video.obj);
              pfr = rgb2gray(pfr);
              tmp = abs(pfr-fr);
              bw = step(thres,tmp);
              [AREA,CENTROID,BBOX] = step(hblob,bw);
              [~,ind] = sort(AREA,'descend');
              if length(ind) > 2
                  ind = ind(1:2);
              end
              objim = insertShape(pfr,'Rectangle',BBOX(ind,:),'color','red');
              imshow(objim);
              pause(1/mg.video.obj.FrameRate);
              fr = pfr;
          end
    case 'Opticalflow'
        fr = rgb2gray(readFrame(mg.video.obj));
        figure,
        while hasFrame(mg.video.obj)
            bfr = rgb2gray(readFrame(mg.video.obj));
            [dx,dy,dt] = Gradient(bfr,fr);
            [U,V] = ComputeFlow(dx,dy,dt);
            FL = opticalFlow(U,V);
            imshow(bfr);
            hold on
            plot(FL,'DecimationFactor',[20 20],'ScaleFactor',10);
            title('Video frame with optical flow field')
            hold off
            fr = bfr;
        end
    case 'Gradient'
        fr = rgb2gray(readFrame(mg.video.obj));
        figure, hold on 
        while hasFrame(mg.video.obj)
            bfr = rgb2gray(readFrame(mg.video.obj));
            [dy,dx,dt] = Gradient(bfr,fr);
            subplot(121),imshow(dy,[]);
            title('dy');
            subplot(122),imshow(dx,[]);
            title('dx')
            pause(1/mg.video.obj.FrameRate);
            fr = bfr;
        end
        hold off
end

function f = mgvideoaverage(varargin)
% f = mgvideoaverage(varargin)
% mgvideoaverage computes the average of all video frames
% syntax:
% f = mgvideoaverage(mg,'color','bg',true); mg contains video
% info,starttime,endtime. If you only want to compute a temporal segment in
% a video, you can try mg = mgvideoreader(vidfile,'extract',0,10); f =
% mgvideoaverage(mg,'color','bg',true).
% f = mgvideoaverage(mg,'gray','bg',false);
% f = mgvideoaverage(vidfile,'gray','bg',true);
%
% input:
% mg or video file
% type: 'color' or 'gray'
% 'bg': true or false; if true, the last video frame will added to average
% video; if false, f is average video;
%
% output:
% f: average video
if isempty(varargin)
    f = [];
    return;
end
l = length(varargin);
if l == 1
    if ischar(varargin{1}) 
        [~,~,ex] = fileparts(varargin{1});
        if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
            mg = mgvideoreader(varargin{1});
        else 
            disp('please check video format...');
            f = [];
            return;
        end
    elseif isstruct(varargin{1})
        if isfield(varargin{1},'video')
            mg = varargin{1};
        else
            disp('please make sure the input structure contains video...');
            f = [];
            return;
        end
    end
    type = 'gray';
    bg = false;
elseif l >= 2
   if ischar(varargin{1})
       [~,~,ex] = fileparts(varargin{1});
       if ismember(ex,{'.mp4';'.avi';'.mov';'.mpg';'.m4v'})
           mg = mgvideoreader(varargin{1});
       else
           disp('please check video format...');
           f = [];
           return;
       end
   elseif isstruct(varargin{1})
       if isfield(varargin{1},'video')
           mg = varargin{1};
       else
           disp('please make sure the input structure contains video...');
           f = [];
           return;
       end
   end
   if strcmpi(varargin{2},'gray') || strcmpi(varargin{2},'color')
       if l >3
            type = varargin{2};
            bg = varargin{4};
       else
           type = varargin{2};
           bg = 'gray';
       end
   elseif strcmpi(varargin{2},'bg')
       if l >=3
            type = 'gray';
            bg = varargin{3};
       else
           type = 'gray';
           bg = false;
       end
   end
end
numf = 0;
mg.video.obj.CurrentTime = mg.video.starttime;
if strcmpi(type,'gray')
    f = zeros(mg.video.obj.Height,mg.video.obj.Width,'double');
    while mg.video.obj.CurrentTime < mg.video.endtime
        fr = double(rgb2gray(readFrame(mg.video.obj)));
        f = f + fr;
        numf = numf + 1;
    end
    f = f/numf;
    if bg
        f = imadd(f,fr);
        figure,imshow(f,[]);  
        title('average video + background')
    else
        f = uint8(f);
        figure,imshow(f)
        title('average video');
    end
elseif strcmpi(type,'color')
    f = zeros(mg.video.obj.Height,mg.video.obj.Width,3,'double');
    while mg.video.obj.CurrentTime < mg.video.endtime
        fr = double(readFrame(mg.video.obj));
        f = f + fr;
        numf = numf + 1;
    end
    f = f/numf;
    if bg
        f = uint8(imadd(f,fr));
        figure,imshow(f,[]);
        title('average video + background');
    else
        f = uint8(f);
        figure,imshow(f)
        title('average video');
    end
end

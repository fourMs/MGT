function f = mgmotionfilter(varargin)
% f = mgmotionfilter(varargin)
% mgmotionfilter filter the motion image or optical flow field
% It provides three options, 'Regular','Binary','Blob' options.
% syntax: f = mgmotionfilter(f,method,thres)
% f = mgmotionfilter(f), default method 'Regular', thres =  0.1;
% input:
% f :input motion image or optical flow field.
% method :'Regular', turn all values below thres to 0;
% 'Binary', turn all values below thres to 0, above thres to 1;
% 'Blob', remove individual pixels with erosion.
% thres: for 'Regular','Binary' option, thres is the value of threshold;for
% 'Blob' option, thres is element structure created by strel.
% output:
% f: filtered f

l  = length(varargin);
if l == 1
    f = varargin{1};
    med = 'Regular';
    thres = 0.1;
elseif l >=3
    f = varargin{1};
    med = varargin{2};
    thres = varargin{3};
end
switch med
    case 'Regular'
        thres = min(f(:))+(max(f(:))-min(f(:)))*thres;
        f(find(f<thres)) = 0;
        f = medfilt2(f,[5,5]);
    case 'Binary'
%         thres = min(f(:))+(max(f(:))-min(f(:)))*thres;
        thres = max(f(:))*thres;
        f(find(f<thres)) = 0;
        f(find(f>=thres)) = 1;
        f = 255*medfilt2(f,[5,5]);
    case 'Blob'
        f = imerode(f,thres);
end




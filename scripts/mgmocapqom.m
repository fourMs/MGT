function s = mgmocapqom(varargin)
% mgmocapqom computes the quantity of motion of mocap data. 
% syntax:
% s = mgmocapqom(mg);
%
% input:
% mg: data structure contains mocap data set
% s: the quantity of motion of mocap data set is stored in the field of
% s.mocap.data

s = varargin{1};
if isstruct(varargin{1})
    if isfield(varargin{1},'mocap')
        mocap = varargin{1}.mocap;
        [m,n] = size(mocap.data);
        for i =  1:m-1
            mocap.diffdata(i,:) = abs((mocap.data(i+1,:) - mocap.data(i,:)));
        end
        mocap_diff = mocap;
        mocap_diff.data = mocap.diffdata;
        mocap_diff.nFrames = mocap_diff.nFrames - 1;
        mocap_diff = mcnorm(mocap_diff);
        s.mocap = mocap_diff;
    else
        s = varargin{1};
        [m,n] = size(s.data);
        for i =  1:m-1
            s.diffdata(i,:) = abs((s.data(i+1,:) - s.data(i,:)));
        end
        mocap_diff = s;
        mocap_diff.data = s.diffdata;
        mocap_diff.nFrames = mocap_diff.nFrames - 1;
        mocap_diff = mcnorm(mocap_diff);
        s = mocap_diff;
    end
end
        


    
    
    

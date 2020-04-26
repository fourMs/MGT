function [per,ac,eac,lag] = mgautocor(mg,type,maxp,method)
% function out = mgautocor(fn,max,method)
% mgautocor computes the period of the input data and returns the
% period, autocorrelation functions and enhanced autocorrelation functions
% and lags
% syntax:[per,ac,eac,lag] = mgautocor(out,type,maxp,method);
%
% input:
% mg: musical gestures data structure
% maxp: maximum period ,default value,2
% method: 'first','highest' maximal value of the autocorrelation function
% is taken as periodicity estimation
%
% output:
% per: a scalar containing the period estimation of the quantity of motion
% ac: a vector containing the autocorrelation functions of quantity of
% motion
% eac: a vector containing the enhanced autocorrelation functions of
% quantity of motion
% lag: a vector containing the lag values for the autocorrelation functions
%
% eg:[per,ac,eac,lag] = mgautocor(mg);
if nargin == 2
    maxp = 2;
    method = 'first';
end
if nargin == 3
    if isletter(maxp)
        method = maxp;
        maxp = 2;
    else
        method = 'first';
    end
end
if strcmpi(type,'video')
mg.video.qom = detrend(mg.video.qom);
frate = mg.video.obj.FrameRate;
maxlag = round(maxp*frate);
lagfr = [0:maxlag]';
lag = lagfr/frate;
tmp = mg.video.qom - mean(mg.video.qom);
tmp1 = xcorr(tmp,maxlag);
tmp1 = tmp1((maxlag+1):end);
ac = tmp1;
tmp1 = tmp1/max(tmp1);
ind = find(diff(sign(diff(tmp1)))==-2);
if isempty(ind)
    per = NaN;
elseif strcmpi(method,'highest')
    w = min(ind);
    [q,ww] = max(tmp1(w:end));
    ma = w + ww - 1;
elseif strcmp(method,'first')
    ma = min(ind) + 1;
end
if ma == 1
    per = NaN;
elseif ma == length(tmp1)
    per = NaN;
else
    fra = -(tmp1(ma+1)-tmp1(ma-1))/(tmp1(ma-1)+tmp1(ma+1)-2*tmp1(ma));
    per = (ma-1+fra)/frate;
end
tmp2 = max(tmp1,0);
tmp3 = tmp2-interp1(lagfr,tmp2,lagfr/2);
eac = max(tmp3,0);
elseif strcmpi(type,'mocap') && isfield(mg,'mocap')
    mocap = mg.mocap;
    [m,n] = size(mocap.data);
    for i =  1:m-1
        mocap.diffdata(i,:) = abs((mocap.data(i+1,:) - mocap.data(i,:)));
    end
    mocap_diff = mocap;
    mocap_diff.data = mocap.diffdata;
    mocap_diff.nFrames = mocap_diff.nFrames - 1;
    mocap_diff = mcnorm(mocap_diff);
    if size(mocap_diff.data,2) > 1
        mocap_diff.data = sum(mocap_diff.data,2);
    end
    [per,ac,eac,lag] = mcperiod(mocap_diff,maxp,method);
end


    

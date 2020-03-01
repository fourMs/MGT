function features = mgstatistics(varargin)
% function features = mgstatistics(varargin)
% mgstatistics computes the first order and second order features from the
% motion image
% syntax: features = mgstatistics(mg,'Video','FirstOrder')
% features = mgstatistics(mg,'Video','SecondOrder')

% input:
% mg: musical gestures data structure containing motion data
% 'FirstOrder','SecondOrder':compute the level of features

% output: 
% features: a matrix with  N by 4 dimensions,when choosing the 'FirstOrder'
% a matrix with N by 8 dimensions,when choosing the 'SecondOrder',N
% represents the number of the samples.

if strcmp(varargin{2},'Video')
    s = varargin{1};
    i = 1;
    s.video.obj.CurrentTime = 0;
    while hasFrame(s.video.obj)
        a = readFrame(s.video.obj);
        if size(a,3) == 3
            a = rgb2gray(a);
        end
        N_gray = 32;
        if strcmp(varargin{3},'FirstOrder')
            a = double(a);
            a = round((N_gray-1)*((a-min(a(:)))/(max(a(:))-min(a(:)))));
            features(i,1) = mean2(a);
            features(i,2) = std2(a);
            features(i,3) = skewness(a(:));
            features(i,4) = kurtosis(a(:));
        elseif strcmp(varargin{3},'SecondOrder')
            N_gray = 32;
            a = double(a);
            a = round((N_gray-1)*((a-min(a(:)))/(max(a(:))-min(a(:)))));
            [glcm,SI]=graycomatrix(a,'GrayLimits',[0,N_gray-1],...
            'NumLevels',...
            N_gray,'Offset',[0 1;-1 0;-1 1; -1 -1],'Symmetric',true);
             stats=graycoprops(glcm,{'Contrast','Correlation',...
            'Energy','Homogeneity'});
            features(i,1)=mean(stats.Contrast);
            features(i,2)=mean(stats.Correlation);
            features(i,3)=mean(stats.Energy);
            features(i,4)=mean(stats.Homogeneity);
            features(i,5)=range(stats.Contrast);
            features(i,6)=range(stats.Correlation);
            features(i,7)=range(stats.Energy);
            features(i,8)=range(stats.Homogeneity);
        end
        i  = i + 1;
    end
end

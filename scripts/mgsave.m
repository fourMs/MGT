function mgsave(mg)
% function out = mgsave(mg)
% save the musical structure in one folder
% syntax:mgsave(mg)
% input:
% fn:musical data structure or variable

% output:

if isempty(mg)
    return;
end
foldername = datestr(now,'yyyy_mm_dd_HH_MM');
currentpath = pwd;
if ~exist(foldername,'file')
    mkdir(foldername);
end
readme = ['This is a musical gestures data structure,'...
    'which is created by Musical Gestures Toolbox.'...
    'The data structure contains the video,audio,or mocap data information.'...
    'The Musical Gestures Toolbox 1.1 Software Package,Copyright 2016,Informatics Department,University of Oslo,Norway.'...
    'Developed by Bo Zhou,bozhou@ifi.uio.no.'];
fname = 'readme.txt';
save(fullfile(currentpath,foldername,'mg.mat'),'mg')
fid = fopen(fullfile(currentpath,foldername,fname),'w');
if fid ~= -1
    fprintf(fid,'%s\r\n',readme);
    fclose(fid);
end
function mg = mginitstruct(varargin)
% function mg = mginitstruct;
% mginitstruct initiates a musical gestures data structure, containing video, audio, 
% and mocap fields
% syntax: mg = mginitstruct;
% output: mg, musical gestures data structure

% example:
% mg = mginitstruct;
% mg = mginitstruct('Video');
% mg = mginitstruct('Audio');
% mg = mginitstruct('Mocap');
if isempty(varargin)
    mg.video = struct('gram',...
    struct('gramx',[],'gramy',[]),...
    'qom',[],'obj',[],...
    'com',[],'aom',[],'method',[]);
    mg.audio.mir = mirstruct;
    mg.mocap = mcinitstruct;
elseif strcmp(varargin{1},'Video')
    mg.video = struct('gram',...
    struct('gramx',[],'gramy',[]),...
    'qom',[],'obj',[],...
    'com',[],'aom',[],'method',[]);
elseif strcmp(varargin{1},'Audio')
    mg.audio.mir = mirstruct;
elseif strcmp(varargin{1},'Mocap')
    mg.mocap = mcinitstruct;
end
mg.type = 'mg data';
mg.createtime = datestr(datetime('today'));

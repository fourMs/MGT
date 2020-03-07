function tempo = mgtempo(varargin)


if ischar(varargin{1})
     filename = varargin{1};
     tempo = mirgetdata(mirtempo(filename));
elseif isstruct(varargin{1}) && isfield(varargin{1},'audio')
    tempo = mirgetdata(mirtempo(varargin{1}.audio.mir));
end
    
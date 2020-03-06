%% Under development
function [outputArg1] = mgmotion(inputTarget,varargin)




thresh = 0.1;
frameInterval = 1;

l = length(varargin);
cmd = [];


cmd.method = 'Diff';
%cmd.starttime = mg.video.starttime;
%cmd.endtime = mg.video.endtime;
cmd.filterflag = 0;
cmd.filtertype = [];
cmd.thresh = 0.1;
cmd.color = 'off';
cmd.convert = 'off';
cmd.frameInterval = 1;

for argi = 1:l
    if( ischar(varargin{argi}))   
        if(strcmpi(varargin{argi},'Diff') || strcmpi(varargin{argi},'OpticalFlow') )
            disp('method specified in argument');
            
            cmd.method = varargin{argi};
            
            if(argi + 1 <= l && isnumeric(varargin{argi + 1}))
                disp('starttime specified in argument');
                cmd.starttime = varargin{argi+1};
                if(argi + 2 <= l &&isnumeric(varargin{argi + 2})) 
                    disp('stoptime specified in argument');
                    cmd.endtime = varargin{argi+2};
                end
            end
            
        elseif (strcmpi(varargin{argi},'Regular') || strcmpi(varargin{argi},'Binary') ) 
            disp('filtertype specified in argument');
            cmd.filtertype = varargin{argi};
            cmd.filterflag = 1;
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                disp('thresh specified in argument');
                cmd.thresh = varargin{argi+1};
            end
        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            cmd.color = 'on'
        elseif (strcmpi(varargin{argi},'Convert'))
            disp('Convert mode on is specified in argument');
            cmd.convert = 'on'
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                cmd.frameInterval = varargin{argi+1};
            end
        end
    end
end





color = [];
convert = [];

if (strcmpi(cmd.color,'on'))
    color = 'color';
else
    color = 'grayscale';
end

if (strcmpi(cmd.convert,'on'))
    convert = 'convert';
else
    convert = 'noconversion';
end


method = cmd.method;
%starttime = cmd.starttime;
%endtime = cmd.endtime;
filterflag = cmd.filterflag;
filtertype = cmd.filtertype;
thresh = cmd.thresh;
disp(thresh);
frameInterval = cmd.frameInterval;


disp('haha');
disp(inputTarget);

if exist(inputTarget, 'dir')
    disp('your folder exists');
    disp(varargin);
    files = dir(inputTarget);

    fileCount = size(files);
    fileCount = fileCount(1);

    for i= 1:fileCount

        if(files(i).isdir == 0)
            %disp(files(i).name);

            [~, ~, extension_i] = fileparts(files(i).name);
            extension_i = lower(extension_i);
            if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                disp(files(i).name);
                mgmotion(files(i).name, method,color,convert,filtertype,thresh,'Interval',frameInterval);
            end
        end
    end
else
    disp('is not a folder');
    mgmotion(inputTarget, method,color,convert,filtertype,thresh,'Interval',frameInterval);
end

return;








    
    
    
end


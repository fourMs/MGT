%% Under development
function [outputArg1] = mgmotion_loadMultiple(directory,varargin)


thresh = 0.1;
frameInterval = 1;

l = length(varargin);
cmd = [];


%cmd.method = 'Diff';
cmd.starttime = mg.video.starttime;
cmd.endtime = mg.video.endtime;
%cmd.filterflag = 0;
%cmd.filtertype = [];
%cmd.thresh = 0.1;
cmd.color = 'off';
%cmd.convert = 'off';
cmd.frameInterval = 1;
cmd.normalize = 'on'


for argi = 1:l
    if( ischar(varargin{argi}))   
        if(argi == 1 ) %the file name is always the first element in the varargin 
            if(argi + 1 <= l && isnumeric(varargin{argi + 1}))
                disp('starttime specified in argument');
                cmd.starttime = varargin{argi+1};
                if(argi + 2 <= l &&isnumeric(varargin{argi + 2})) 
                    disp('stoptime specified in argument');
                    cmd.endtime = varargin{argi+2};
                end
            end
        elseif (strcmpi(varargin{argi},'normalize'))
            disp('normalization option is specified in argument');
            
            if(argi < l) 
                if (strcmpi(varargin{argi+1},'off'))
                    cmd.normalize = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    cmd.normalize = 'on'
                end
            else
                cmd.normalize = 'on'
            end
            
        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            cmd.color = 'on'
            
            
             if(argi < l) 
                if (strcmpi(varargin{argi+1},'off'))
                    cmd.color = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    cmd.color = 'on'
                end
            else
                cmd.color = 'on'
             end
            
            
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                cmd.frameInterval = varargin{argi+1};
            end
        end
    end
end

frameInterval = cmd.frameInterval;





method = cmd.method;
%starttime = cmd.starttime;
%endtime = cmd.endtime;
filterflag = cmd.filterflag;
filtertype = cmd.filtertype;
thresh = cmd.thresh;
disp(thresh);
frameInterval = cmd.frameInterval;



    disp(varargin);
    files = dir(directory);

    fileCount = size(files);
    fileCount = fileCount(1);

    for i= 1:fileCount

        if(files(i).isdir == 0)
            %disp(files(i).name);

            [~, ~, extension_i] = fileparts(files(i).name);
            extension_i = lower(extension_i);
            if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                disp(files(i).name);
                mgmotionaverage(files(i).name,color,'Interval',frameInterval);
            end
        end
    end
end


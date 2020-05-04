function [outputArg1,outputArg2] = average(obj,varargin)
% function mgmotionaverage(varargin)
% Create an average image by calculating the average of the video frames.
%
% syntax:
% mgmotionaverage(videofile,starttime,endtime);
% mgmotionaverage(mg,starttime,endtime);
% mgmotionaverage(mg);
% mgmotionaverage(videofile);
%
% mgmotionaverage(videofile, ... , 'color', ...); 
% mgmotionaverage(mg, ... , 'color', ...);
% mgmotionaverage(videofile, ... , 'normalize', ...); 
%
% input:
% videofile or mg: input video file or data structure which contains video
% information
% starttime: specified startting time for averaging video
% endtime: specified end time for averaging video
%
% output:
% ave: average image.



f = obj.file;


arg = [];

%default parameters
arg.mg = [];
arg.method = 'Diff';
arg.fileList = [];
arg.filterflag = 0;
arg.filtertype = [];
arg.thresh = 0.1;
arg.color = 'off';
arg.invert = 'off';
arg.frameInterval = 1;
arg.fileCount = 0;
arg.normalize = 'on'




if(ischar(f))
    disp('input is file or folder');
    if exist(f, 'dir')
        disp('folder exists');
        arg.inputType = 'folder';
        
        files = dir(f);
        fileCount = size(files);
        
        fileCount = size(files);   
        fileCount = fileCount(1);
        %disp(fileCount);
        validFileCount = 0;
        for fileIndex= 1:fileCount
            if(files(fileIndex).isdir == 0)
                %disp(files(i).name);

                [~, ~, extension_i] = fileparts(files(fileIndex).name);
                extension_i = lower(extension_i);
                if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                    validFileCount = validFileCount + 1;
                    arg.fileList{validFileCount} = files(fileIndex);
                    arg.mg{validFileCount} = mgvideoreader([files(fileIndex).folder,'\',files(fileIndex).name]);
                    %disp[files(i).folder,files(i).name];
                    arg.fileCount = arg.fileCount + 1;
                end
            end
        end
        
        disp({'file count is ', arg.fileCount});
        
        

    else
        disp('folder does not exist. probably the input is file');
        [~, ~, extension_i] = fileparts(f);
        extension_i = lower(extension_i);
        
        if exist(f, 'file')
            disp('file exists. checking file format')
            if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                disp('valid file format');
                arg.fileCount = 1;
                arg.inputType = 'file';
                arg.mg = mgvideoreader(f);
                arg.starttime = arg.mg.video.starttime;
                arg.endtime = arg.mg.video.endtime;

            else
                disp('invalid file format');
        end
        else
            disp('file not found');
        end
    end
elseif isstruct(f) && isfield(f,'video')
    disp('input is mg struct');
    arg.fileCount = 1;
    arg.inputType = 'struct';
    arg.mg = f;
    arg.starttime = arg.mg.video.starttime;
    arg.endtime = arg.mg.video.endtime;
    
else
    error('invalid input ');
end



l = length(varargin);


for argi = 1:l
    
    if(strcmpi(arg.inputType, 'folder') == 0)    
        if(argi == 1)
            if(argi <= l && isnumeric(varargin{argi }))
                disp('starttime specified in argument');
                arg.starttime = varargin{argi+1};
                if(argi + 1 <= l &&isnumeric(varargin{argi + 1})) 
                    disp('stoptime specified in argument');
                    arg.endtime = varargin{argi+2};
                end
            end
        end
    end
    
    
    if( ischar(varargin{argi}))     
        if (strcmpi(varargin{argi},'normalize'))
            disp('normalization option is specified in argument');
            
            if(argi + 1 <= l) 
                if (strcmpi(varargin{argi+1},'off'))
                    arg.normalize = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    arg.normalize = 'on'
                end
            else
                arg.normalize = 'on'
            end
            
        elseif (strcmpi(varargin{argi},'Color'))
            disp('color mode on is specified in argument');
            arg.color = 'on'
            
            
             if(argi + 1 <= l) 
                if (strcmpi(varargin{argi+1},'off'))
                    arg.color = 'off'
                elseif (strcmpi(varargin{argi+1},'on'))
                    arg.color = 'on'
                end
            else
                arg.color = 'on'
             end
            
            
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                arg.frameInterval = varargin{argi+1};
            end
    end
        
    end
end




for fileIndex = 1:arg.fileCount
    frameInterval = arg.frameInterval;
    if(arg.fileCount == 1)
        mg = arg.mg;
    else
        mg = arg.mg{fileIndex};
        arg.starttime = arg.mg{fileIndex}.video.starttime;
        arg.endtime = arg.mg{fileIndex}.video.endtime;
    end
    
    ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
    %i = 1;
    mg.video.obj.CurrentTime = arg.starttime;
    
    
    if (strcmpi(arg.color, 'on')) || (isfield(mg.video,'mode') && strcmpi(mg.video.mode.color,'on'))
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width,3);
        numfr = mg.video.obj.FrameRate*(arg.endtime-arg.starttime);
        progmeter(0);
        for indf = 1:frameInterval:numfr
            %progmeter(indf,numfr);
            progmeter(mg.video.obj.CurrentTime,arg.endtime);
            fr = readFrame(mg.video.obj);
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
            
        end
        
%         while mg.video.obj.CurrentTime < endtime
%             fr = readFrame(mg.video.obj);
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
    else
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
        numfr = mg.video.obj.FrameRate*(arg.endtime-arg.starttime);
        progmeter(0);
        for indf = 1:frameInterval:numfr
            %progmeter(indf,numfr);
            progmeter(mg.video.obj.CurrentTime,arg.endtime);
            fr = rgb2gray(readFrame(mg.video.obj));
            ave = double(ave) + double(fr);
            mg.video.obj.CurrentTime = (1/mg.video.obj.FrameRate)*indf;
        end
%         while mg.video.obj.CurrentTime < endtime
%             fr = rgb2gray(readFrame(mg.video.obj));
%             ave = double(ave) + double(fr);
%             %i = i + 1;
%         end
    end
    

    % Normalizing values to [0,1]

    if (strcmpi(arg.normalize,'on'))
        %ave2 = uint8(ave/i); % old approach didnt work well
        ave2=(ave-min(ave(:))) ./ max(ave(:)-min(ave(:)));
    end
    %figure, imshow(ave2);

    % Write to file
    [~,pr,~] = fileparts(mg.video.obj.Name);
    tmpfile=strcat(pr,'_average.tiff');
    disp(' ');
    disp('file created under name :');
    disp(tmpfile);
    imwrite(ave2, tmpfile);


end

return;

end


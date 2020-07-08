function ave = mgmotionaverage(f, varargin)
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






cmd = [];

%default parameters
cmd.mg = [];
cmd.method = 'Diff';
cmd.fileList = [];
cmd.filterflag = 0;
cmd.filtertype = [];
cmd.thresh = 0.1;
cmd.color = 'off';
cmd.invert = 'off';
cmd.frameInterval = 1;
cmd.fileCount = 0;
cmd.normalize = 'on'




if(ischar(f))
    disp('input is file or folder');
    if exist(f, 'dir')
        disp('folder exists');
        cmd.inputType = 'folder';
        
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
                    cmd.fileList{validFileCount} = files(fileIndex);
                    cmd.mg{validFileCount} = mgvideoreader([files(fileIndex).folder,'\',files(fileIndex).name]);
                    %disp[files(i).folder,files(i).name];
                    cmd.fileCount = cmd.fileCount + 1;
                end
            end
        end
        
        disp({'file count is ', cmd.fileCount});
        
        

    else
        disp('folder does not exist. probably the input is file');
        [~, ~, extension_i] = fileparts(f);
        extension_i = lower(extension_i);
        
        if exist(f, 'file')
            disp('file exists. checking file format')
            if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                disp('valid file format');
                cmd.fileCount = 1;
                cmd.inputType = 'file';
                cmd.mg = mgvideoreader(f);
                cmd.starttime = cmd.mg.video.starttime;
                cmd.endtime = cmd.mg.video.endtime;

            else
                disp('invalid file format');
        end
        else
            disp('file not found');
        end
    end
elseif isstruct(f) && isfield(f,'video')
    disp('input is mg struct');
    cmd.fileCount = 1;
    cmd.inputType = 'struct';
    cmd.mg = f;
    cmd.starttime = cmd.mg.video.starttime;
    cmd.endtime = cmd.mg.video.endtime;
    
else
    error('invalid input ');
end



l = length(varargin);


for argi = 1:l
    
    if(strcmpi(cmd.inputType, 'folder') == 0)    
        if(argi == 1)
            if(argi <= l && isnumeric(varargin{argi }))
                disp('starttime specified in argument');
                cmd.starttime = varargin{argi+1};
                if(argi + 1 <= l &&isnumeric(varargin{argi + 1})) 
                    disp('stoptime specified in argument');
                    cmd.endtime = varargin{argi+2};
                end
            end
        end
    end
    
    
    if( ischar(varargin{argi}))     
        if (strcmpi(varargin{argi},'normalize'))
            disp('normalization option is specified in argument');
            
            if(argi + 1 <= l) 
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
            
            
             if(argi + 1 <= l) 
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




for fileIndex = 1:cmd.fileCount
    frameInterval = cmd.frameInterval;
    if(cmd.fileCount == 1)
        mg = cmd.mg;
    else
        mg = cmd.mg{fileIndex};
        cmd.starttime = cmd.mg{fileIndex}.video.starttime;
        cmd.endtime = cmd.mg{fileIndex}.video.endtime;
    end
    
    ave = zeros(mg.video.obj.Height,mg.video.obj.Width);
    %i = 1;
    mg.video.obj.CurrentTime = cmd.starttime;
    
    
    if (strcmpi(cmd.color, 'on')) || (isfield(mg.video,'mode') && strcmpi(mg.video.mode.color,'on'))
        ave = zeros(mg.video.obj.Height,mg.video.obj.Width,3);
        numfr = mg.video.obj.FrameRate*(cmd.endtime-cmd.starttime);
        progmeter(0);
        for indf = 1:frameInterval:numfr
            %progmeter(indf,numfr);
            progmeter(mg.video.obj.CurrentTime,cmd.endtime);
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
        numfr = mg.video.obj.FrameRate*(cmd.endtime-cmd.starttime);
        progmeter(0);
        for indf = 1:frameInterval:numfr
            %progmeter(indf,numfr);
            progmeter(mg.video.obj.CurrentTime,cmd.endtime);
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
    aveOut = ave
    if (strcmpi(cmd.normalize,'on'))
        %ave2 = uint8(ave/i); % old approach didnt work well
        aveNormalized=(ave-min(ave(:))) ./ max(ave(:)-min(ave(:)));
        aveOut = aveNormalized;
    else
        aveOut = ave;
    end
    %figure, imshow(ave2);

    % Write to file
    [~,pr,~] = fileparts(mg.video.obj.Name);
    tmpfile=strcat(pr,'_average.tiff');
    disp(' ');
    disp('file created under name :');
    disp(tmpfile);
    imwrite(aveOut, tmpfile);


end

return;



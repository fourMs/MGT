function mgOut = mgmotion_file(f,varargin)
%MGMOTION - Calculate various motion features from a video file
% mgmotion computes a motion video, motiongram, quantity of motion, centroid of
% motion, width of motion, and height of motion from the video file or musical
% gestures data structure. The default method is to use plain frame differencing
% ('Diff'). A more expensive optical flow field can be calculated with the
% 'OpticalFlow' method. The mgmotion founction also provides a color mode, and the
% possibility to invert images with white on black instead of black on white. 
%
% syntax:
% mg = mgmotion(mg,method,starttime,endtime,filtertype,thresh)
% mg = mgmotion(filename);
% mg = mgmotion(mg,'Diff');
% mg = mgmotion(filename,'Diff',starttime,endtime,'Regular',0.3);
% mg = mgmotion(filename,'OpticalFlow',starttime,'Binary',0.2);
% mg = mgmotion(mg, ..., 'Diff',starttime,endtime , ... );
% mg = mgmotion(mg, ..., 'Regular', 0.3 , ...);
% mg = mgmotion(mg, ..., 'Binary', 0.2, ...);
% mg = mgmotion(mg, ..., 'OpticalFlow', ...);
% mg = mgmotion(mg, ..., 'color', ...);
% mg = mgmotion(mg, ..., 'invert', ...);
% mg = mgmotion(mg, ..., 'interval', 10, ...);
% mg = mgmotion(directory);
% mg = mgmotion(directory, 'Diff', 'Color', 'Regular', 0.3');





% input:
% filename: the name of the video file
% mg: instead of filename it is possible to use a MG data structure
% Diff: method calculates the absolute frame difference between
% two successive frames. 
% OpticalFlow: calculates the optical flow field
% filtertype: Binary, Regular, Blob. When choosing Blob, the element
% structure needs to be constructed using function strel
% thresh: threshold [0,1] (default=0.1)
% color: does the analysis with 4 planes (default: grayscale)
% invert: creates motiongrams with white background (default: black)
% interval: skip frames for more rapid processing
%
% output:
% mg, a musical gestures data structure containing the computed motion
% image, motiongram, qom, com

% mg = mginitstruct;

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
        for ik= 1:fileCount
            if(files(ik).isdir == 0)
                %disp(files(i).name);

                [~, ~, extension_i] = fileparts(files(ik).name);
                extension_i = lower(extension_i);
                if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                    validFileCount = validFileCount + 1;
                    cmd.fileList{validFileCount} = files(ik);
                    cmd.mg{validFileCount} = mgvideoreader([files(ik).folder,'\',files(ik).name]);
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
    if( ischar(varargin{argi}))   
        if(strcmpi(varargin{argi},'Diff') || strcmpi(varargin{argi},'OpticalFlow') )
            disp('method specified in argument');
            
            cmd.method = varargin{argi};
            
            
            if(strcmpi(cmd.inputType, 'folder') == 0)
                disp('input type accepts starttime and stoptime only if input is file or struct and not folder');
                if(argi + 1 <= l && isnumeric(varargin{argi + 1}))
                    disp('starttime specified in argument');
                    cmd.starttime = varargin{argi+1};
                    if(argi + 2 <= l &&isnumeric(varargin{argi + 2})) 
                        disp('stoptime specified in argument');
                        cmd.endtime = varargin{argi+2};
                    end
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
        elseif (strcmpi(varargin{argi},'invert'))
            disp('invert mode on is specified in argument');
            cmd.invert = 'on'
        elseif (strcmpi(varargin{argi},'Interval'))
            if(argi + 1 <= l &&  isnumeric(varargin{argi + 1}))
                cmd.frameInterval = varargin{argi+1};
            end
        end
    end
end



for ik = 1:cmd.fileCount
    
    if(cmd.fileCount == 1)
        mg = cmd.mg;
    else
        mg = cmd.mg{ik};
        cmd.starttime = cmd.mg{ik}.video.starttime;
        cmd.endtime = cmd.mg{ik}.video.endtime;
    end
    
    method = cmd.method;
    starttime = cmd.starttime;
    endtime = cmd.endtime;
    filterflag = cmd.filterflag;
    filtertype = cmd.filtertype;
    thresh = cmd.thresh;
    %disp(thresh);
    frameInterval = cmd.frameInterval;

    mg.video.method = method;
    mg.video.gram.y = [];
    mg.video.gram.x = [];
    mg.video.qom = [];
    mg.video.com = [];
    mg.video.aom = [];
    mg.video.wom = [];
    mg.video.hom = [];
    mg.video.starttime = starttime;
    mg.video.endtime = endtime;
    % hblob = vision.BlobAnalysis;
    % hblob.AreaOutputPort = true;

    if(strcmpi(cmd.color, 'on'))
        colorflag = true;
    else
        if (isfield(mg.video,'mode') && isfield(mg.video.mode,'color') ) 
            if strcmpi(mg.video.mode.color,'on') 
                colorflag = true;
            else
                colorflag = false;
            end
        else
            colorflag = false;
        end
    end


    if(strcmpi(cmd.invert, 'on'))
        invertflag = true'
    else
        if (isfield (mg.video,'mode') && isfield(mg.video.mode,'invert'))
            if strcmpi(mg.video.mode.invert,'on')
                invertflag = true;
            else
                invertflag = false;
            end
        else
            invertflag = false;
        end
    end




    if strcmpi(method,'Diff')
        mg.video.obj.CurrentTime = starttime;
        if colorflag == true
            fr = readFrame(mg.video.obj);
        else
            fr = rgb2gray(readFrame(mg.video.obj));
        end
        [filepath,filename,ext] = fileparts(mg.video.obj.Name);
        newfile = strcat(filename,'_motion.avi');
        mg.output.type = 'motion';
        mg.output.motion.filename = newfile;
        
        

        v = VideoWriter(newfile);
        v.FrameRate = mg.video.obj.FrameRate;
        ind = 1;

        %numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
        %numf = mg.video.obj.FrameRate*(endtime-starttime); %eg. for 1 second at 25fps,  25*(0-1) = 25 
        disp(' ');
        open(v);
        progmeter(0);

        if colorflag == true
            while hasFrame(mg.video.obj)
                %progmeter(mg.video.obj.CurrentTime,endtime);
                mg.video.obj.CurrentTime = mg.video.obj.CurrentTime - (1/mg.video.obj.FrameRate); %subtracting the incremented currenttime due to readFrame()
                mg.video.obj.CurrentTime = mg.video.obj.CurrentTime + (1/mg.video.obj.FrameRate)*frameInterval;
                
                
                pfr = readFrame(mg.video.obj);


                diff = abs(pfr-fr);
                if filterflag
                    for i = 1:size(diff,3)
                        diff(:,:,i) = mgmotionfilter(diff(:,:,i),filtertype,thresh);
                    end
                end
                [com,qom] = mgcentroid(rgb2gray(diff));
                %             hautoh = vision.Autothresholder;
                %             level = multithresh(rgb2gray(diff));
                %             bw = step(hautoh,rgb2gray(diff));
                %             bw = rgb2gray(diff) >= level;
                %             aom = sum(step(hblob,bw));
                %            [bbox,aom] = findboundingbox(diff);
                %            mg.video.wom = [mg.video.wom;bbox(3)];
                %            mg.video.hom = [mg.video.hom;bbox(4)];
                %            mg.video.aom = [mg.video.aom;aom];
                mg.video.qom = [mg.video.qom;qom];
                mg.video.com = [mg.video.com;com];
                gramx = mean(diff);
                gramy = mean(diff,2);
                mg.video.gram.y = [mg.video.gram.y;gramx];
                mg.video.gram.x = [mg.video.gram.x,gramy];
                if invertflag == true
                    diff = imcomplement(diff);
                end
                writeVideo(v,diff);
                fr = pfr;

                ind = ind + 1;
                progmeter(mg.video.obj.CurrentTime,endtime);

                if(mg.video.obj.CurrentTime > endtime)
                    break;
                end
                
            end

            if invertflag == true
                mg.video.gram.x = imcomplement(mg.video.gram.x);
                mg.video.gram.y = imcomplement(mg.video.gram.y);
            end
        else

            while hasFrame(mg.video.obj)
                %progmeter(mg.video.obj.CurrentTime,endtime);
                
                mg.video.obj.CurrentTime = mg.video.obj.CurrentTime - (1/mg.video.obj.FrameRate); %subtracting the incremented currenttime due to readFrame()
                mg.video.obj.CurrentTime = mg.video.obj.CurrentTime + (1/mg.video.obj.FrameRate)*frameInterval;
                
                pfr = rgb2gray(readFrame(mg.video.obj));


                diff = abs(pfr-fr);
                if filterflag
                    diff = mgmotionfilter(diff,filtertype,thresh);
                end
                [com,qom] = mgcentroid(diff);
                %             hautoh = vision.Autothresholder;
                %             level = multithresh(diff);
                %             bw = imquantize(diff,level);
                %             bw = diff >= level;
                %             bw = step(hautoh,diff);
                %             aom = sum(step(hblob,bw));
                %            [bbox,aom] = findboundingbox(diff);
                %            mg.video.aom = [mg.video.aom;aom];
                %            mg.video.wom = [mg.video.wom;bbox(3)];
                %            mg.video.hom = [mg.video.hom;bbox(4)];
                gramx = mean(diff);
                gramy = mean(diff,2);
                mg.video.gram.y = [mg.video.gram.y;gramx];
                mg.video.gram.x = [mg.video.gram.x,gramy];
                mg.video.qom = [mg.video.qom;qom];
                mg.video.com = [mg.video.com;com];
                if invertflag == true
                    diff = imcomplement(diff);
                end
                writeVideo(v,diff);
                fr = pfr;
                ind = ind + 1;
                progmeter(mg.video.obj.CurrentTime,endtime);
                if(mg.video.obj.CurrentTime > endtime)
                    break;
                end
            end
            if invertflag == true
                mg.video.gram.y = imcomplement(mg.video.gram.y);
                mg.video.gram.x = imcomplement(mg.video.gram.x);
            end
        end
        
           
        
        close(v)
        disp(' ');
        disp(['The motion video is created with name ',newfile]);
        
        if(cmd.fileCount == 1)
            mgOut = mgvideoreader(newfile);
        else
            mgOut{ik} = mgvideoreader(newfile);

        end

        
        
        mg.video.nframe = v.FrameCount;
        %     mg.video.nframe = ind - 1;

        % Write motiongrams to files
        tmpfile=strcat(filename,'_mgx.tiff');
        imwrite(mg.video.gram.x, tmpfile);
        tmpfile=strcat(filename,'_mgy.tiff');
        imwrite(mg.video.gram.y, tmpfile);

        % Plot graphs
        %    figure,subplot(211),plot(mg.video.qom)
        %    title('Quantity of Motion');
        %    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:mg.video.nframe])
        %    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:...
        %        2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
        %    xlabel('Time (s)')
        %    ylabel('Quantity')
        %    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
        %    axis equal;
        %    title('Centroid of Motion');
        %    xlabel('x direction')
        %    ylabel('y direction')
        s = mgvideoreader(newfile);
        mg.video.obj = s.video.obj;
    elseif strcmpi(method,'OpticalFlow')
        mg.video.obj.CurrentTime = starttime;
        [filepath,filename,ext] = fileparts(mg.video.obj.Name);
        newfile = strcat(filename,'_flow.avi');
        mg.output.type = 'opticalFlow';
        mg.output.opticalFlow.filename = newfile;
        v = VideoWriter(newfile);
        v.FrameRate = mg.video.obj.FrameRate;
        ind = 1;
        %numf = mg.video.obj.FrameRate*(endtime-starttime)-1;
        open(v);
        fh = figure('visible','off');
        fr1 = rgb2gray(readFrame(mg.video.obj));
        %h = waitbar(0,'Running motion analysis...');
        %textprogressbar('Running motion analysis: ');
        progmeter(0);
        ii = 1;
        while hasFrame(mg.video.obj)
            mg.video.obj.CurrentTime = mg.video.obj.CurrentTime - (1/mg.video.obj.FrameRate); %subtracting the incremented currenttime due to readFrame()
            mg.video.obj.CurrentTime = mg.video.obj.CurrentTime + (1/mg.video.obj.FrameRate)*frameInterval;
            fr2 = rgb2gray(readFrame(mg.video.obj));
            ii = ii + 1;

            flow = mgopticalflow(fr2,fr1);
            magnitude = flow.Magnitude;
            if filterflag
                magnitude = mgmotionfilter(magnitude,filtertype,thresh);
            end
            qom = sum(sum(magnitude));
            [m,n] = size(magnitude);
            x = 1:n;
            y = 1:m;
            meanx = mean(magnitude);
            comx = x*meanx'/sum(meanx);
            meany = mean(magnitude,2);
            comy = y*meany/sum(meany);
            com = [comx,comy];
            gramx = mean(magnitude);
            gramy = mean(magnitude,2);
            mg.video.gram.y = [mg.video.gram.y;gramx];
            mg.video.gram.x = [mg.video.gram.x,gramy];
            mg.video.qom = [mg.video.qom;qom];
            mg.video.com = [mg.video.com;com];
            imshow(fr1),hold on;
            plot(flow,'DecimationFactor',[20 20],'ScaleFactor',10);
            hold off;
            writeVideo(v,getframe(fh));
            fr1 = fr2;
            ind = ind + 1;
            progmeter(mg.video.obj.CurrentTime,endtime);


        end
            %textprogressbar('done');
            %close(h);
            close(v);
        disp(' ');
        disp(['The motion video is created with name ',newfile]);
        
        if(cmd.fileCount == 1)
            mgOut = mgvideoreader(newfile);
        else
            mgOut{ik} = mgvideoreader(newfile);

        end
        mg.video.nframe = v.FrameCount;

        %    figure,subplot(211),plot(mg.video.qom)
        %    title('Quantity of motion by opticalflow');
        %    set(gca,'XTick',[0:2*mg.video.obj.FrameRate:ind])
        %    set(gca,'XTickLabel',[starttime*mg.video.obj.FrameRate:2*mg.video.obj.FrameRate:endtime*mg.video.obj.FrameRate]/mg.video.obj.FrameRate);
        %    xlabel('Time (s)')
        %    ylabel('Quantity')
        %    subplot(212),plot(mg.video.com(:,1),mg.video.com(:,2),'.')
        %    axis equal
        %    title('Centroid of motion by opticalflow');
        %    xlabel('x direction')
        %    ylabel('y direction')
    end
    mg.video.obj.CurrentTime = 0;
    mg.type = 'mg data';
    mg.createtime = datestr(datetime('today'));

    % Write data to text file
    csvdata = [mg.video.qom mg.video.com];
    newfile = strcat(filename,'_data.csv');

    csvwrite(newfile, csvdata); % Need to write header info as well
    % xlswrite(newfile, csvdata);

    mgmotionplot(mg);
    
end

return;






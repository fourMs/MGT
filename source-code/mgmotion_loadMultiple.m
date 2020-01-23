%% Under development
function [outputArg1] = mgmotion_loadMultiple(directory,varargin)

    disp(varargin);
    files = dir(directory);

    fileCount = size(files);
    fileCount = fileCount(1);

    for i= 1:fileCount

        if(files(i).isdir == 0)
            %disp(files(i).name);

            [~, ~, extension_i] = fileparts(files(i).name);

            if((extension_i == ".avi")||(extension_i == ".mp4")||(extension_i == ".m4v") ||(extension_i == ".mpg") ||(extension_i == ".mov")    )
                disp(files(i).name);
                mgmotion(files(i).name);
            end
        end
    end
end


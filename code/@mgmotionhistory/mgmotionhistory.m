classdef mgmotionhistory
    %MGMOTIONHISTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        file
    end
    
    methods
        function obj = mgmotionhistory(f,varargin)
            %MGMOTIONHISTORY Construct an instance of this class
            %   Detailed explanation goes here
            %obj.Property1 = inputArg1 + inputArg2;
            %disp("mgmotionhistory class created");
            disp(["mgmotionhistory class created with values" f]);
            obj.file = f;
        end
        
        
        [outputArg1,outputArg2] = history(obj, varargin)
    end
end


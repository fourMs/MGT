classdef mgmotion
    %MGMOTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        
    end
    
    methods
        function obj = mgmotion(varargin)
            %MGMOTION Construct an instance of this class
            %   Detailed explanation goes here
            %obj.Property1 = inputArg1 + inputArg2;
            %disp(["mgmotion class created with values" f]);
            %obj.file = f;
        end
        
        function outputArg = method_mgmotion(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
            disp(obj.file);
        end
        
        [outputArg1,outputArg2] = motion(obj,varargin)
    end
end


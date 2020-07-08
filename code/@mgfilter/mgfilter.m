classdef mgfilter
    %FILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = mgfilter(f,varargin)
            %FILTER Construct an instance of this class
            %   Detailed explanation goes here
         
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        
        [retval,videoOut] = filter(obj, varargin)
        
        
    end
end


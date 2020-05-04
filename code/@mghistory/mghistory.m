classdef mghistory 
    %MGMOTIONHISTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        nFrame
    end
    
    methods
        function obj = mghistory(varargin)
            obj.nFrame = 10;
        end
        
        
        [outputArg1,outputArg2] = history(obj, varargin)
        [retval,videoOut] = history_color(obj,varargin)
        [retval,videoOut] = history_gray(obj,varargin)
    end
end


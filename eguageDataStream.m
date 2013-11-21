classdef eguageDataStream 
    %EGUAGEDATASTREAM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        timeReadings ;          % Vector containing the time stamps [UTC]
        powerReadings ;         % Vector containing power readings [Watts]
        currentReadings ;       % Vector containing current readings [mAmps]
        voltageReadings ;       % Vector containing voltage
    end
    
    properties(SetAccess = private, GetAccess = private)
        bufferSize      = 500 ;   % Max number of samples to store in buffer
        isActive        = 0 ;     % Flag to indicate if the stream is active
        hyperlink ;               % Hyperlink of the power meter
        hPlot ;                   % Handle for the current plot
        currentChannel  = [1 2] ; % 
        voltageChannel  = [1 2] ; % 
        powerChannel    = [1 2] ; %
    end
    
    methods
        function eds = eguageDataStream(varargin)
            % Class constructor - no inputs uses default IP address
            % 152.3.3.246 otherwise, enter a string of the eGuage IP
            % address
            if nargin == 0
                ipAddress = '152.3.3.246' ;
            elseif nargin == 1
                ipAddress = varargin{1} ;
            else
                error('Invalid number of input arguments')
            end
            
            startHyperlink  = 'http://' ;
            endHyperlink    = '/cgi-bin/egauge?tot' ;
            eds.hyperlink   = [startHyperlink ipAddress endHyperlink] ;
        end
        
        function eds = setSource(eds,newSource)
            switch lower(newSource)
                case 'totalusage'
                    eds.currentChannel = [1 2] ;
                    eds.voltageChannel = [1 2] ;
                    eds.powerChannel   = [1 2] ;
                case 'microwave'
                    eds.currentChannel = 5 ;
                    eds.voltageChannel = 1 ;
                    eds.powerChannel   = 3 ;
                case 'washingmachine'
                    eds.currentChannel = 6 ;
                    eds.voltageChannel = 1 ;
                    eds.powerChannel   = -4 ;
                case 'ovenunit'
                    eds.currentChannel = 7 ;
                    eds.voltageChannel = [1 2] ;
                    eds.powerChannel   = [-5 6] ;
                case 'stoveunit'
                    eds.currentChannel = 8 ;
                    eds.voltageChannel = [1 2] ;
                    eds.powerChannel   = [7 8] ;
                case '1stfloorahu'
                    eds.currentChannel = [9 10] ;
                    eds.voltageChannel = [1 2] ;
                    eds.powerChannel   = [9 10] ;
                case 'refrigerator'
                    eds.currentChannel = 11 ;
                    eds.voltageChannel = 1 ;
                    eds.powerChannel   = 11 ;
                case 'dishwasher'
                    eds.currentChannel = 12 ;
                    eds.voltageChannel = 1 ;
                    eds.powerChannel   = -12 ;
                case 'pvsolar1'
                    eds.currentChannel = 3 ;
                    eds.voltageChannel = [1 2] ;
                    eds.powerChannel   = [- 13 14] ;
                case 'pvsolar2'
                    eds.currentChannel = 4 ;
                    eds.voltageChannel = 2 ;
                    eds.powerChannel   = -15 ;
                otherwise
                    fprintf('Invalid source\n')
            end
        end
        
        function eds = setBuffer(eds,newBuffer)
            % Set the size of the buffer. Default is 500 samples
            eds.bufferSize = newBuffer ;
        end
        
        function eds = streamInitiate(eds)
            % Opens communication with the eGuage system
           
            % Initialize
            eds.timeReadings    = nan(eds.bufferSize,1) ;
            eds.powerReadings   = nan(eds.bufferSize,1) ;
            eds.voltageReadings = nan(eds.bufferSize,1) ;
            eds.currentReadings = nan(eds.bufferSize,1) ;
            eds.isActive        = 1 ;
        end
        
        function eds = streamClose(eds)
            % Closes the data stream
            eds.isActive      = 0 ;
        end
        
        function eds = streamUpdate(eds)
            % Sample from the data stream and update the buffer
            eguageXml = xmlread(eds.hyperlink) ;
            
            % Convert the java structure into a Matlab structure
            Eguage = xml2struct(eguageXml) ;
            
            % Test if the timestamp is a duplicate - if not record
            cTimeStamp = str2double(Eguage.measurements.timestamp.Text) ;
            if cTimeStamp ~= eds.timeReadings(1)
                
                % Update the data arrays
                eds.timeReadings    = circshift(eds.timeReadings, 1) ;
                eds.powerReadings   = circshift(eds.powerReadings,1) ;
                eds.currentReadings = circshift(eds.currentReadings,1) ;
                eds.voltageReadings = circshift(eds.voltageReadings,1) ;

                eds.timeReadings(1)  = str2double(Eguage.measurements.timestamp.Text) ;
                if length(eds.currentChannel) == 1
                    if eds.currentChannel < 0
                        eds.currentReadings(1) = -str2double(Eguage.measurements.current{abs(eds.currentChannel)}.Text) ;
                    else
                        eds.currentReadings(1) = str2double(Eguage.measurements.current{abs(eds.currentChannel)}.Text) ;
                    end
                else
                    addend(1) = abs(str2double(Eguage.measurements.current{abs(eds.currentChannel(1))}.Text)) ;
                    addend(2) = abs(str2double(Eguage.measurements.current{abs(eds.currentChannel(2))}.Text)) ;
                    %if eds.currentChannel(1) < 0 ; addend(1) = -addend(1) ; end ;
                    %if eds.currentChannel(2) < 0 ; addend(2) = -addend(2) ; end ;
                    eds.currentReadings(1) = sum(addend) ;
                end
                
                if length(eds.voltageChannel) == 1
                    eds.voltageReadings(1) = str2double(Eguage.measurements.voltage{eds.voltageChannel}.Text) ;
                else
                    eds.voltageReadings(1) = 0.5*str2double(Eguage.measurements.voltage{1}.Text) + ...
                                             0.5*str2double(Eguage.measurements.voltage{2}.Text);                    
                end
                
                if length(eds.powerChannel) == 1
                    if eds.powerChannel < 0
                        eds.powerReadings(1)   = -str2double(Eguage.measurements.cpower{abs(eds.powerChannel)}.Text) ;
                    else
                        eds.powerReadings(1)   = str2double(Eguage.measurements.cpower{abs(eds.powerChannel)}.Text) ;
                    end
                else
                    addend(1) = abs(str2double(Eguage.measurements.cpower{abs(eds.powerChannel(1))}.Text)) ;
                    addend(2) = abs(str2double(Eguage.measurements.cpower{abs(eds.powerChannel(2))}.Text)) ;
                   % if eds.powerChannel(1) < 0 ; addend(1) = -addend(1) ; end ;
                    %if eds.powerChannel(2) < 0 ; addend(2) = -addend(2) ; end ;
                    eds.powerReadings(1) = sum(addend) ;
                end
            end
        end
        
        function eds = plot(eds,varargin)
            % Plot the data from the stream
            if nargin == 0 || isempty(varargin) % Default plotting options
                eds.hPlot = plot(eds.timeReadings ,eds.powerReadings,'.') ;
            elseif nargin == 1 % If only the axis handle is given
                eds.hPlot = plot(varargin{1},eds.timeReadings ,eds.powerReadings,'.') ;
            elseif nargin > 1 % If the axis handle and additional arguments are given.
                plotSpec = varargin(2:end) ;
                eds.hPlot = plot(varargin{1},eds.timeReadings ,eds.powerReadings,plotSpec{:}) ;
            end
            set(eds.hPlot,'YDataSource','eds.powerReadings')
            set(eds.hPlot,'XDataSource','eds.timeReadings')
        end
        
        function eds = plotUpdate(eds)
            % Update the data plot
            refreshdata(eds.hPlot,'caller')
        end
    end
end


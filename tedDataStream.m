classdef tedDataStream 
    %TEDDATASTREAM Summary of this class goes here
    %   This class was coded in order to be similar to the eguageDataStream
    %   Substantial difference is the presence of the apparent power
    %   readings. powerReadings only refers to the active power
    
    properties
        timeReadings ;          % Vector containing the time stamps [UTC]
        powerReadings ;         % Vector containing active power readings [Watts]
        apparentPowerReadings ;    % Vector containing power readings [mAmps]
        voltageReadings ;       % Vector containing voltage
    end
    
    properties(SetAccess = private, GetAccess = private)
        bufferSize      = 500 ;   % Max number of samples to store in buffer
        isActive        = 0 ;     % Flag to indicate if the stream is active
        hyperlink ;               % Hyperlink of the power meter
        hPlot ;                   % Handle for the current plot

  end
    
    methods
        function tds = tedDataStream(varargin)
            % Class constructor - no inputs uses default IP address
            % 152.3.3.246 otherwise, enter a string of the eGuage IP
            % address
            if nargin == 0
                ipAddress = '192.168.7.2' ;
            elseif nargin == 1
                ipAddress = varargin{1} ;
            else
                error('Invalid number of input arguments')
            end
            
            startHyperlink  = 'http://' ;
            endHyperlink    = '/api/LiveData.xml' ;
            tds.hyperlink   = [startHyperlink ipAddress endHyperlink] ;
        end
  
        
        function tds = setBuffer(tds,newBuffer)
            % Set the size of the buffer. Default is 500 samples
            tds.bufferSize = newBuffer ;
        end
        
        function tds = streamInitiate(tds)
            % Opens communication with the TED system
           
            % Initialize
            tds.timeReadings    = nan(tds.bufferSize,1) ;
            tds.powerReadings   = nan(tds.bufferSize,1) ;
            tds.voltageReadings = nan(tds.bufferSize,1) ;
            tds.apparentPowerReadings = nan(tds.bufferSize,1) ;
            tds.isActive        = 1 ;
        end
        
        function tds = streamClose(tds)
            % Closes the data stream
            tds.isActive      = 0 ;
        end
        
        function tds = streamUpdate(tds)
            % Sample from the data stream and update the buffer
            tedXml = xmlread(tds.hyperlink) ;
            
            % Convert the java structure into a Matlab structure
            ted = xml2struct(tedXml) ;
            
            % Test if the timestamp is a duplicate - if not record
            year = str2double(['20' ted.LiveData.GatewayTime.Year.Text]); %the xml just display the last two figures of the year
            hour = str2double(ted.LiveData.GatewayTime.Hour.Text);
            minute = str2double(ted.LiveData.GatewayTime.Minute.Text);
            day = str2double(ted.LiveData.GatewayTime.Day.Text);
            second = str2double(ted.LiveData.GatewayTime.Second.Text);
            month = str2double(ted.LiveData.GatewayTime.Month.Text);
           
            %conversion in unix time. For detailed explaination see help
            %datenum and the definition of unix time
            cTimeStamp = (datenum(year, month, day, hour, minute, second)-datenum('1970', 'yyyy'))* 8.64e4;    
          
         %check the if the stream is updated
           if cTimeStamp ~= tds.timeReadings(1)
                
                % Update the data arrays and move all the past readings of
                % one position down
                tds.timeReadings    = circshift(tds.timeReadings, 1) ;
                tds.powerReadings   = circshift(tds.powerReadings,1) ;
                tds.apparentPowerReadings = circshift(tds.apparentPowerReadings,1) ;
                tds.voltageReadings = circshift(tds.voltageReadings,1) ;

                tds.timeReadings(1)  = cTimeStamp ;
                tds.powerReadings(1) =str2double(ted.LiveData.Power.MTU1.PowerNow.Text);
                tds.apparentPowerReadings(1) =str2double(ted.LiveData.Power.MTU1.KVA.Text);
                tds.voltageReadings(1) =str2double(ted.LiveData.Voltage.MTU1.VoltageNow.Text)/10; % beacause the unit displayed in the xml is 10*V

            end
        end
        
        function tds = plot(tds,varargin)
            % Plot the data from the stream
            if nargin == 0 || isempty(varargin) % Default plotting options
                tds.hPlot = plot(tds.timeReadings ,tds.powerReadings,'.') ;
            elseif nargin == 1 % If only the axis handle is given
                tds.hPlot = plot(varargin{1},tds.timeReadings ,tds.powerReadings,'.') ;
            elseif nargin > 1 % If the axis handle and additional arguments are given.
                plotSpec = varargin(2:end) ;
                tds.hPlot = plot(varargin{1},tds.timeReadings ,tds.powerReadings,plotSpec{:}) ;
            end
            set(tds.hPlot,'YDataSource','tds.powerReadings')
            set(tds.hPlot,'XDataSource','tds.timeReadings')
        end
        
        function tds = plotUpdate(tds)
            % Update the data plot
            refreshdata(tds.hPlot,'caller')
        end
    end
end


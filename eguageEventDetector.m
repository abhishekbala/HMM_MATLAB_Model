% this called is called in the timer command string of detectEvent in the
% case the source selected is eguage or none (default)
x = x.setSource(source).streamUpdate;   %updata the stream
  

%% there are 5 cases: 1)event starts 2)event stops 3)event continues 4)event not present 

if  x.powerReadings(2:timeLag+2)<threshold|isnan(x.powerReadings(2:timeLag+2))  
%% if the parameter is not satisfactory reset the values (after a certain time lag) of the readings to the initiliazed one
    x.timeReadings(timeLag +3) = NaN;   
    x.powerReadings(timeLag +3) = NaN;    
   x.voltageReadings(timeLag +3) = NaN;   
   x.currentReadings(timeLag +3) = NaN;
     
  
  elseif x.powerReadings(2:timeLag+1)<threshold  & x.powerReadings(timeLag+2)>threshold 
    %%
      msgbox ('event finished', 'watch out', 'warn');   % notify the end of the event
   event = x.powerReadings;                          
    event(isnan(event)) = [];                         %delete all the components that are NaN
    timeStamp = x.timeReadings;                       
   timeStamp(isnan(timeStamp)) = [];                  %delete all the components that are NaN           
    current = x.currentReadings;
   current(isnan(current)) = [];                       %delete all the components that are NaN
   
    if exist('eventStruct')==0  %check the existance and write fist component if not present
             eventStruct.power = flipud(event);    % flip vector:going down--->time increasing
             eventStruct.timeStamp = flipud(timeStamp);% flip vector:going down--->time increasing
             eventStruct.current = flipud(current);% flip vector:going down--->time increasing
    else
    
   %if present add another component to the array of structures
   eventStruct(length(eventStruct)+1).power = flipud(event);% flip vector:going down--->time increasing
   
   eventStruct(length(eventStruct)).timeStamp = flipud(timeStamp);% flip vector:going down--->time increasing
   
   eventStruct(length(eventStruct)).current = flipud(current);% flip vector:going down--->time increasing
   
   
    end

    inizialization;   %reinitialitize the class to read another event
   %clear all the variables memorize in the base workspace
    clear event; 
    clear current;
    clear timeStamp;
    
    %LAUNCH THE EVENT RECOGNITION CODE and the FIGURE-------------------------------------------%%
    figurePopout;
          
elseif  x.powerReadings(2)>threshold   & (isnan(x.powerReadings(3:timeLag+2))| x.powerReadings(3:timeLag+2)<threshold)   % event starts
  %%  Notify the start of the event
       msgbox('event started','watch out', 'warn'); 
%        
     
elseif  x.powerReadings (2:3) > threshold | x.powerReadings(timeLag+1)>threshold   %event continues
   %%     
%         continues to stream normally. the object x in the workspace in
%         continuosly updated

    
end
     
    



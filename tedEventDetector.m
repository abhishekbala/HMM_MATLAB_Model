% this called is called in the timer command string of detectEvent in the
% case the source selected is TED 
%This script is not updated with the possibility of changing the timeLag.
%If this is to be done, have a look at eguageEventDetector

x = x.streamUpdate;

%% there are 5 cases: 1)event starts 2)event stops 3)event continues 4)event not present 

if x.powerReadings(2)<threshold   && (x.powerReadings(3)<threshold || isnan(x.powerReadings(3))) % event not present. We check the second componenent to keep the first recorded and to get the complete shape
   %% % if the parameter is not satisfactory reset to the value of the redings to the initiliazed one
    x.timeReadings(3) = NaN;
    x.powerReadings(3) = NaN;    
   x.voltageReadings(3) = NaN;   
   x.apparentPowerReadings(3) = NaN;
     
   
elseif x.powerReadings(2)<threshold   && x.powerReadings(3)>threshold   %event finishes
%%    
    msgbox ('event finished', 'watch out', 'warn');
    event(length(event)+1) = x.powerReadings(2);           %event should be already there. Record also the second after
    
    timeStamp = x.timeReadings;
   timeStamp(isnan(timeStamp)) = [];
   timeStamp(1) = [];
    apparentPower = x.apparentPowerReadings;
   apparentPower(isnan(apparentPower)) = [];
   apparentPower(1) = [];
   
    if exist('eventStruct')==0  %check the existance
             eventStruct.power = event';    % initialize struct
             eventStruct.timeStamp = flipud(timeStamp);
             eventStruct.apparentPower = flipud(apparentPower);
    else
    
    
   eventStruct(length(eventStruct)+1).power = event';
   
   eventStruct(length(eventStruct)).timeStamp = flipud(timeStamp);
   
   eventStruct(length(eventStruct)).apparentPower = flipud(apparentPower);
   
   
    end

    inizialization;   %reinitialitize the class
    clear event; 
    clear apparentPower;
    clear timeStamp;
    
    %LAUNCH THE EVENT RECOGNITION CODE-------------------------------------------%%
    figurePopout;
          
elseif  x.powerReadings(2)>threshold   && (isnan(x.powerReadings(3))|| x.powerReadings(3)<threshold)   % event starts
  %%  
       msgbox('event started','watch out', 'warn'); % return a message box----> to add picture popout
        event(1) = x.powerReadings(3);   % initialization of the variable event
        event(2) = x.powerReadings(2);
     
elseif  x.powerReadings(2)>threshold   && x.powerReadings(3)>threshold     %event continues
   %%     
        event(length(event)+1) = x.powerReadings(2);

    
end


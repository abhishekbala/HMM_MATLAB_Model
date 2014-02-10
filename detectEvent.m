%This script launch the eventDetector code for either the TED device or the
%eGuage. 
%---------------TO BE CHANGED according to preferences----------------%

threshold = 10 ; %Minimum event wattage
timeLag = 10;   %Waiting time below the minimum wattage before assessing the end of the want
%---------------------------------------------------------------------%
%the choice of the source is done interactively with a question dialog box.
%Default is eGuage
device = questdlg('Which device do you want to use?','SELECT DEVICE','eGuage','TED','eGuage');

inizialization;   %launch the initialization code for the class source selected

t = timer ;     %create a timer object


switch device
   
    case 'eGuage'
rate = 1;  %rate of refreshments
set(t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'eguageEventDetector; disp(x.powerReadings(1));',...
      'Period',         rate) ; % Seconds per period

    
    case  'TED'
  rate = 2; %rate of refreshments
  set(t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'tedEventDetector; disp(x.powerReadings(1));',...
      'Period',         rate) ; % Seconds per period

        
        
end

 start(t)   %start the timer object
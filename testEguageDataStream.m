x = eguageDataStream ; % Create the eguageDataStream object
x = x.streamInitiate ; % Initialize the data stream. This object passed by value not by reference
                       %  so you need to assign the result to the object
                       %  itself to keep the object up-to-date
x = x.plot ;           % Initialize the plot

% Create a timer
t = timer ;

source = 'microwave';
class(source)
% set(t,'ExecutionMode',  'fixedRate',...
% 	  'TimerFcn',       'x = x.setSource(source).streamUpdate ; x = x.setSource(source).plotUpdate ; display(t);',...
%       'Period',         1) ; % Seconds per period
  
  set(t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'x = x.setSource(source).streamUpdate ; x = x.setSource(source).plotUpdate ; display(t);',...
      'Period',         1) ; % Seconds per period
start(t)

%datetick('x','HH:MM:SS')


x = tedDataStream ; % Create the eguageDataStream object
x = x.streamInitiate ; % Initialize the data stream. Object passed by value
x = x.plot ;           % Initialize the plot

% Create a timer object
t = timer ;

set(t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'x = x.streamUpdate ; x = x.plotUpdate ; display(t);',...
      'Period',         5) ; % Seconds per period. Set to 5 in the test in order to overcome communication delays
start(t)                    %start the timer


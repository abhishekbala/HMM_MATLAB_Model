%This script is read in the timer commands string . It displayed the
%elapsed time of refreshing data

x = getappdata(0,'x'); 
t = tic;
x = x.streamUpdate;
tElapsed = toc(t);

if tElapsed> 4;
    stop (handles.t)
end
 

plot(plot2,x.timeReadings-tStart, x.powerReadings, 'b*-') ;
plot(plot1,x.timeReadings-tStart, x.voltageReadings,'r') ;
plot(plot3,x.timeReadings-tStart, x.apparentPowerReadings, 'g'); 
setappdata(0,'x',x);

disp (tElapsed);
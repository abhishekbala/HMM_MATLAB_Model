function[timeString] = timeConversion(timeUnix)

%Converts unix time in a readable time string. Reference day is January 1st 1970 and reference
%meridian is the Greenwhich meridian

timeReference = datenum('1970', 'yyyy'); 
timeMatlab = timeReference + timeUnix / 8.64e4;   %8.64e4 is seconds per day
timeString = datestr(timeMatlab, 'HH:MM:SS');



  
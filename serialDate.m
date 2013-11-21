function [ timeMatlab ] = serialDate(timeReadings )
%Converts unix time in matlab format time. Reference day is January 1st 1970 and reference
%meridian is the Greenwhich meridian

 timeReadings = x.timeReadings
timeReference = datenum('1970', 'yyyy'); 
timeMatlab = timeReference + /8.64e4;  %8.64e4 is seconds per day


end


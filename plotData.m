% This script plots all the power recordings registered in data in the same
% graphwith random colors . This is very usefuel to check for the exsitance of some strange
% recordings

uiopen('C:\Users\Alberto\Desktop\Disaggregation MATLAB\guiV2\Results');   %directory to be changed according to the user's need
cc=hsv(length(data));
for i = 1 : length(data)
    plot(data(i).power, 'color',cc(i,:));
    hold on;    
end

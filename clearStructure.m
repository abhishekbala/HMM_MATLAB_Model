% This script checks if the recorded data obtained trough the GUI contain
% any empty component in the array of structure data and if so, delete it
uiopen;   % interactivey open the file with the recorded data
for i  = 1: length(data)
    if isempty(data(i).power)==1
        data(i) =[];
    end
end
uisave;   %to update previos file
%this script is used event recognition of past events memorized with the
%GUI. It allows the user to interactively open some recordings and see if
%the event recognition works with them.
%KennyPrtHmmForSmartHome output must be opened before

uiopen('C:\Users\Alberto\Desktop\Disaggregation MATLAB\guiV2\Results');   %directory to be changed according to the user's need
for i =1: length(data)

if exist('eventStruct') ==0
    eventStruct = data(i);
else
eventStruct(length(eventStruct)) = data(i);
end
device = questdlg('What device did you use to perform the measurements?','SELECT DEVICE','eGuage','TED','eGuage');
figurePopout;
end
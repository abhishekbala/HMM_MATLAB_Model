%% The figurePopout script is launched by the eventDetector script when the end of the end is established. 
%----------calls Kenny's algorithm and establish the cases----------
% p(i) is the log-likelihood 
dsNew = prtDataSetTimeSeries({eventStruct(length(eventStruct)).power}');
newLogLikelihoods = run(classifierTrained,dsNew) ;
p = newLogLikelihoods.X;

%find the power max of the the last component in the array of structure evenStruc
%eventStruct is defined in the eventDetector code and saved in the base
%workspace

maxPower = max(eventStruct(length(eventStruct)).power);          
switch device
    case 'eGuage'
maxCurrent = max(eventStruct(length(eventStruct)).current);      %find the current max of the the last component in the array of structure evenStruct   
    case 'TED'
        maxApparentPower = max(eventStruct(length(eventStruct)).apparentPower);% the TED device does not display current readings but it gives the apparentPOwer
end
        
duration = length(eventStruct(length(eventStruct)).power);       %find the duration of the event

energy = 0;   %initialize the energy calculation
for i = 1:duration
energy = energy + eventStruct(length(eventStruct)).power(i);   %Calute the energy in Ws
end
energy = energy/3600; %Convert the energy just calculated in Wh
cost = energy *8.67/1000;   %$cents assuming the average retail price for NC of 8.67 4cent/KWh

switch device
    case 'TED'
startTime = timeConversion(eventStruct(length(eventStruct)).timeStamp(1));  %with the function timeConversion converst unix to a readable string
    case 'eGuage'
startTime = timeConversion(eventStruct(length(eventStruct)).timeStamp(1)); %with the function timeConversion converst unix to a readable string
NCHour = num2str(str2num(startTime(1:2))-4);   % converts time according to the current local time. 4 hours in advance respect to GreenWhich
startTime(1:2) = NCHour;            %pastes the NC hour in the hour position of the string
end

[maxLogLikelihood, i] = max(p);
object = ds24.classNames(ds24.classNamesToClassInd(ds24.classNames)==i);  %Memorize the name of the object with the max lok likelihood
dirEnd = [object{1} '.jpg'];   %end of the directory



figureHandle = figure('Name','EVENT DETECTED','NumberTitle','off',...
    'units','normalized','outerposition',[0 0 1 1]);   %diplay a maximized figure with the title EVENT detected
set(figureHandle, 'Color', 'w');                 %change default background color to white

%% Picture of the appliance
ax(1) = subplot(2,2,1);               % plot in the first position of a 2*2 matrix of subplots
dirStart = 'C:\Users\Alberto\Desktop\Disaggregation MATLAB\guiV2\Pictures\';     %-------------TO BE CHANGED----------------------%
directory = [dirStart, dirEnd];    % put together the complete directory address of the figure
 

if exist(directory)==2     %if it doesnt exist no task is performed
 im = imread(directory);
image(im);            %open the just read image in the specified position
axis off;              % set the axes labelling off
axis image;            % optimize the figure format
box(ax(1), 'off');      % set the box not visible
title(object,'FontSize',14,'Color',[1 0 0] ); %title in the speicified format
end
%% Display plot of the log-likelyhood
ax(2) = subplot (2,2,3);           % plot in the third position of a 2*2 matrix of subplots       
plot(ax(2), p, 'b*-');%display bar graph. ax(2) is the plot handle and p the log-likehood
hold on;
 set(ax(2),'YMinorGrid','on');
%labels = ds24.classNames;
labels = {};
for j = 1: length(ds24.classNamesToClassInd(ds24.classNames))
temp = ds24.classNamesToClassInd(ds24.classNames);
labels{length(labels)+1} = ds24.classNames{temp(j)};
end
set(gca, 'XTick', 1:6, 'XTickLabel', labels);            % set the specified string cell as the x labelling of the bar chart
title(ax(2), ' Calculated log-likelihood', 'FontSize',14,'Color',[1 0 0]);       %title in the speicified forma
%);
%% Power plot
ax(3) = subplot(3,2,4);             % plot in the fourth position of a 3*2 matrix of subplots   
plot(eventStruct(length(eventStruct)).power);
title(ax(3),'Power', 'FontSize',14,'Color',[1 0 0]);
ylabel (ax(3), 'power[W]');
set(ax(3), 'xtick', []);      % don't display xtick bacause visible from the graph below

%% Current/ Apparent power plot depending on the source chosen
ax(4) = subplot(3,2,6);           % plot in the sixth position of a 3*2 matrix of subplots  
%plot(eventStruct(length(eventStruct)).current);
switch device
    case 'eGuage'
plot(eventStruct(length(eventStruct)).current);
xlabel(ax(4),' time [s]');
ylabel(ax(4), 'current [A]');
title(ax(4), 'Current', 'FontSize',14,'Color',[1 0 0]);
    case 'TED'
        plot(eventStruct(length(eventStruct)).apparentPower);
xlabel(ax(4),' time [s]');
ylabel(ax(4), 'Apparent Power [VA]');
        
title(ax(4), 'Apparent Power', 'FontSize',14,'Color',[1 0 0]);
end

%% Text box
ax(5) = subplot(3,2,2);     % plot in the second position of a 3*2 matrix of subplots  (upper right)
axis off                      % set the axes labelling off

set(ax(5), 'box', 'off');
% create a string to insert in the annotation textbox
str = {sprintf('Maximum power : %6.2f watt' , maxPower);... 
    sprintf('Duration of the event: %d seconds' , duration);....
    sprintf('Energy utilized: %6.2f Wh', energy);...
    sprintf('Cost: %6.4f $cents',cost);....
    ['Time of start: ' startTime ]};
%create the object annotation
annotation(figureHandle,'textbox',...
    [0.571595900439239 0.714285714285714 0.331039531478769 0.241046277666002],...
    'String',str, 'FontSize',20,'FitBoxToText','off','LineStyle','none',......
    'BackgroundColor','w');
%elimanate the box
box('off')





function varargout = guiV2(varargin)
% GUIV2 MATLAB code for guiV2.fig
%      GUIV2, by itself, creates a new GUIV2 or raises the existing
%      singleton*.
%
%      H = GUIV2 returns the handle to a new GUIV2 or the handle to
%      the existing singleton*.
%
%      GUIV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIV2.M with the given input arguments.
%
%      GUIV2('Property','Value',...) creates a new GUIV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiV2

% Last Modified by GUIDE v2.5 09-Jul-2013 13:47:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiV2_OpeningFcn, ...
                   'gui_OutputFcn',  @guiV2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiV2 is made visible.
function guiV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiV2 (see VARARGIN)


handles.output = hObject;                                                  % Choose default command line output for guiV2

guidata(hObject, handles);                                                 % Update handles structure

                                                                     
assignin('base', 'plot1', handles.axes1);
assignin('base', 'plot3', handles.axes3);
assignin('base', 'plot2', handles.axes2);



% --- Outputs from this function are returned to the command line.
function varargout = guiV2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in iCircuit.
function iCircuit_Callback(hObject, eventdata, handles)
% hObject    handle to iCircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns iCircuit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from iCircuit


strPopup1 = cellstr(get(hObject,'String'));                                 %get the content of the popup menu in a cell array
handles.source= strPopup1{get(hObject,'Value')};                           %pass the selected item to the handle

guidata(hObject, handles);                                                  %returns the handle


% --- Executes during object creation, after setting all properties.
function iCircuit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iCircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


hold(handles.axes1, 'on');                                                                   %keep everything graphed previously
hold(handles.axes2, 'on'); 
hold(handles.axes3, 'on'); 

set(get(handles.axes2, 'xlabel'), 'string', 'time[s]');                     
set(get(handles.axes2, 'ylabel'), 'string', 'power [W]');
set(handles.axes1, 'xtick', []);                     
set(get(handles.axes1, 'ylabel'), 'string', 'voltage[V]');
set(handles.axes3, 'xtick', []);                     

if isfield(handles,'popup2')==0                                            %set eGuage as a default since it is the first of the list in the popup menu
handles.popup2 = 'eGuage';
end

switch handles.popup2                                                      %switch loop depending on the definition of the higher hierarchy popup
    
    case 'eGuage'

set(get(handles.axes3, 'ylabel'), 'string', 'current [A]');
if isfield(handles, 'source') == 0
    handles.source = 'totalusage';
end


assignin('base' ,'source', handles.source);

handles.t = timer ;                                                        %pass the timer to the handles

if evalin('base','exist(''tStart'')')==0
    
x = eguageDataStream;                                                      % Create the eguageDataStream object

x = x.streamInitiate;                                                      % Initialize the data stream. This object passed by value not by reference

                                                                          %  so you need to assign the result to the object
                                                                           %  itself to keep the object up-to-date
x = x.plot;                                                                % Initialize the plot

setappdata(0,'x',x);                                                        % pass the class x to the base workaspace

x = x.streamUpdate;
tStart = x.timeReadings(1);
assignin('base' ,'tStart', tStart);
end


set(handles.t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'x = getappdata(0,''x''); x = x.setSource(source).streamUpdate; plot(plot2, x.setSource(source).timeReadings-tStart, x.setSource(source).powerReadings, ''b*-'') ;plot(plot1, x.setSource(source).timeReadings -tStart,x.setSource(source).voltageReadings,''r'') ;plot(plot3, x.setSource(source).timeReadings -tStart, x.setSource(source).currentReadings, ''g''); setappdata(0,''x'',x);',...
      'Period',         1) ;                                               %1= seconds per period between timer updates
start(handles.t)

set(handles.start,'Visible','off');      %make the start button disappear in order not to give the user the possibility to push it



    case 'TED'                                                             %second case of selection for popupMenu2
      
 set(get(handles.axes3, 'ylabel'), 'string', 'Apparent Power [VA]');       
 
 if evalin('base','exist(''tStart'')')==0
     
x = tedDataStream;                                                      % Create the tedDataStream object

x = x.streamInitiate;                                                       % Initialize the data stream. This object passed by value not by reference


                                                                           %  so you need to assign the result to the object
                                                                           %  itself to keep the object up-to-date
                      
x = x.plot;

x = x.streamUpdate;

tStart = x.timeReadings(1);
assignin('base' ,'tStart', tStart);

display ('dai');

setappdata(0,'x',x); 

end

handles.t = timer;

rate = handles.rate;

if strcmp(handles.rate, 'rate')
    handles.rate = 2;
end

% set(handles.t,'ExecutionMode',  'fixedRate',...
% 	  'TimerFcn',       'x = getappdata(0,''x''); x = x.streamUpdate; plot(plot2,x.timeReadings-tStart, x.powerReadings, ''b*-'') ;plot(plot1,x.timeReadings-tStart, x.voltageReadings,''r'') ;plot(plot3,x.timeReadings-tStart, x.apparentPowerReadings, ''g''); setappdata(0,''x'',x);',...
%       'Period',         rate) ;                                               %5= seconds per period between timer updates

 set(handles.t,'ExecutionMode',  'fixedRate',...
	  'TimerFcn',       'timerCommandsTed;',...
      'Period',         rate) ;

start(handles.t)

set(handles.start,'Visible','off');  
        
       
      
        
end

guidata(hObject, handles);                                                 %returns the handle

% --- Executes on button press in stop.

function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% global t;

stop(handles.t);

set(handles.start,'Visible','on');

%--------------------------name
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.item = get(hObject, 'String');                                     %get the handle

guidata(hObject, handles);                                                 %returns the handle



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%----------------description-------
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

handles.description = get(hObject, 'String');                              %get the handle

guidata(hObject, handles);                                                 %returns the handle

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%------------specifications------
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

handles.specification = get(hObject, 'String');                            %get the handle

guidata(hObject, handles);                                                 %returns the handle

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2





function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double

handles.filename = get(hObject, 'String');                                 %get the handle

guidata(hObject, handles);                                                 %returns the handle

% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'mouse')==0                                             %return error if the handle of mouse selection does not exist
    msgbox('Please select a valid range','ERROR','error');
end

tStart = evalin('base', 'tStart');
lb = (handles.mouse(1)) + tStart;
ub = (handles.mouse(2)) + tStart;


x = getappdata(0,'x');                                                     %get the structure that is in the workspace
XData =x.timeReadings;
XData(isnan(XData)) = [];                                                  %eliminate the components with NaN
XData= flipud(XData);  %reverse order upside down. Now down--->time increase    

handles.timeStamp = XData(lb<XData & XData<ub);                            %recall the lower and upper bound saved in handles.mouse
iData = find (lb<XData & XData<ub);

voltage = x.voltageReadings;
voltage(isnan(voltage)) = [];
voltage = flipud(voltage);


 switch handles.popup2                                                      %switch loop depending on the definition of the higher hierarchy popup
    
    case 'eGuage'                                                                       

YData = x.powerReadings;                                                   
YData(isnan(YData)) =[];
YData = flipud(YData);
YData = YData(iData);

current = x.currentReadings;
current(isnan(current)) = [];
current = flipud(current);
current = current(iData);

     case 'TED'
         
YData = x.powerReadings;                                                   
YData(isnan(YData)) =[];
YData = flipud(YData);
YData = YData(iData);

apparentPower = x.apparentPowerReadings;
apparentPower(isnan(apparentPower)) = [];
apparentPower = flipud(apparentPower);
apparentPower = apparentPower(iData);

 end        
         


 checkItem = get(handles.edit1,'String');                                  
 checkDescription = get(handles.edit2,'String');
 checkSpecification = get(handles.edit3,'String');
 checkFileName = get(handles.fileName,'String');
 
 %return error is the handles are still default in the edit boxwa
 if strcmp(checkItem,'Category')                                           % if the handles still contains the default string return error
    msgbox('Please enter a valid item name','ERROR','error');
    
 elseif strcmp(checkDescription, 'Description')                            % if the handles still contains the default string return error
    msgbox('Please enter a valid description','ERROR','error');
    
 elseif strcmp(checkSpecification, 'Specification')                        % if the handles still contains the default string return error
             msgbox('Please enter valid specifications','ERROR','error');
             
 elseif strcmp(checkFileName, 'Enter the device ID')                       % if the handles still contains the default string return error
             msgbox('Please enter valid file name','ERROR','error');
 
 else
      filename = [handles.filename '.mat'];                                %get the written file name in the edit box ( deviceID)

    data.item = handles.item;                                              %copy the handles into a structure data
    data.description = handles.description;
    data.specification = handles.specification;       
    
    data.timeStamp =handles.timeStamp;
    data.voltage =  voltage(iData);
   
    
    switch handles.popup2
        case 'eGuage'
            
            data.power =YData;
             data.current = current;
             
        case 'TED'
            data.power = YData;
            data.apparentPower = apparentPower;
    end
            
            
p = mfilename('fullpath');                                                %Return the path of the GUI folder  
disp(p);
dir= [p filesep 'Results' filesep data.item]                              %create a new directory name with filesep
[status,message,messageid]= mkdir(dir); %make a new subfolder of the GUI folder

if status==0
    msgbox(message, 'Problem in creating a new folder', 'error');
end
fileDir = [dir filesep filename]
save(fileDir,'data');
%uisave('data',filename);                                                   %save interactively the structure into a file with the user defined name
  %msgbox('file saved correctly','OK!');                                   %return messagebox if the file is saved correctly
 end

guidata(hObject, handles);                                                 %returns the handle



% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
% hObject    handle to Update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global oldData;                                                            %set a global variable olddata that is defined in the browse pushbutton
data = oldData;                                                            %transfer into a new structure data

x = getappdata(0,'x');                                                   %get the structure that is in the workspace
XData =x.timeReadings;
XData(isnan(XData)) = [];                                                    %eliminate the components with NaN
XData= flipud(XData);                                                         %reverse order upside down. Now down--->time increase


voltage = x.voltageReadings;
voltage(isnan(voltage)) = [];
voltage = flipud(voltage);


if isfield(handles,'mouse')==0                                             %return error if the handle of mouse selection does not exist
    msgbox('Please select a valid range','ERROR','error');
end

checkItem = get(handles.edit1,'String');                                   %tranfer handles contents into check variables
 checkDescription = get(handles.edit2,'String');
 checkSpecification = get(handles.edit3,'String');
 checkFileName = get(handles.fileName,'String');

 if strcmp(checkItem,'Category')                                           %return error is the handles string are still default in the edit boxwa
    msgbox('Please enter a valid item name','ERROR','error');
    
 elseif strcmp(checkDescription, 'Description')
    msgbox('Please enter a valid description','ERROR','error');
    
 elseif strcmp(checkSpecification, 'Specification')
             msgbox('Please enter valid specifications','ERROR','error');
              
 else


%restrict the vectors to the mouse selected range
tStart = evalin('base', 'tStart');
lb = (handles.mouse(1)) + tStart;
ub = (handles.mouse(2))+ tStart;
handles.timeStamp = XData(lb<XData & XData<ub);%recall the lower and upper bound saved in handles.mouse
iData = find (lb<XData & XData<ub);
voltage = voltage (iData);


data(length(oldData)+1).item = handles.item;                               %add and compile a new component in the array of structures. Do the process on a field by field basis
    data(length(oldData)+1).description = handles.description;
    data(length(oldData)+1).specification = handles.specification;       
   
    data(length(oldData)+1).timeStamp = handles.timeStamp; 
    
    data(length(oldData)+1).voltage = voltage;
    
    switch handles.popup2
        case 'eGuage'
           YData = x.powerReadings;
          YData(isnan(YData)) =[];
           YData = flipud(YData);

         current = x.currentReadings;
         current(isnan(current)) = [];
        current = flipud(current);
            
                                               
    current = current(iData);
     data(length(oldData)+1).power = YData(iData);
     data(length(oldData)+1).current = current;
     
        case 'TED'
           YData = x.powerReadings;
          YData(isnan(YData)) =[];
           YData = flipud(YData);
           
           apparentPower = x.apparentPowerReadings;
           apparentPower(isnan(apparentPower)) = [];
           apparentPower = flipud(apparentPower);

            
         
        data(length(oldData)+1).power = YData(iData);
        data(length(oldData)+1).apparentPower = apparentPower(iData);
    end
            
    
  uisave('data',strcat(handles.browse.dir, handles.browse.name));                                           %save with the name (saved in the hanndle) of the file previously browsed 
  %msgbox('file saved correctly','OK!');
  set(handles.fileName,'string','Enter the file name');                    %reset the default handles to the file name editbox
  
 end
  
guidata(hObject, handles);                                                 %returns the handle


% 
% --- Executes on button press in browseTag.
function browseTag_Callback(hObject, eventdata, handles)
% hObject    handle to browseTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global oldData;                                                            %set ta global variable

p = mfilename('fullpath');                                                 %get the directory of the GUI folder
[handles.browse.name, handles.browse.dir]=uigetfile(p) ;                                                  %save the old file name into the handle

if handles.browse.name~=0                                                       %give a message when the file has been loaded into the deviceID editbox
   set(handles.fileName,'string','FILE LOADED'); 
end

old=open(strcat(handles.browse.dir, handles.browse.name));                                                %get the old structure 'data' into the structure old in the field data                                             
oldData = old.data;                                                        %the field data becomes a new structure olData

guidata(hObject, handles);                                                 %returns the handle


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y]=ginput(2);                                                           %returns two vector os two point corresponding to data selected on the graph

handles.mouse = x;                                                         %saves the x vector into the handle

set(handles.edit7,'string',num2str(x(1)));                                 %display the range into the editboxes for lowerbound
set(handles.edit8,'string',num2str(x(2)));                                 %display the range into the editbox for upperbound

ylim = get(handles.axes2, 'ylim');
handles.line(1) = line([x(1), x(1)], ylim, 'color', 'k');
set(handles.line(1), 'parent', handles.axes2);

handles.line(2) = line([x(2), x(2)], ylim, 'color', 'k');
set(handles.line(2), 'parent', handles.axes2);


guidata(hObject, handles);                                                 %returns the handle



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strPopup2 = cellstr(get(hObject,'String'));                                % returns popupmenu2 contents as cell array                         
handles.popup2 = strPopup2{get(hObject,'Value')};                          %returns selected item from popupmenu2 and save it to the handle

switch handles.popup2
    
    case 'eGuage'
    set(handles.iCircuit, 'Visible','on');                                 % in case we come back to the egauge from ted
    
    case 'TED'
    set(handles.iCircuit, 'Visible','off');
end


guidata(hObject, handles);                                                 %returns the handle

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearGraphTag.
function ClearGraphTag_Callback(hObject, eventdata, handles)
% hObject    handle to ClearGraphTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold off;
cla(handles.axes2); %clear axes 
cla(handles.axes1);
cla(handles.axes3);

evalin('base','clear tStart');


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key                                                       %create keyboard shortcut in the figure eventdata
  case 'a'
    start_Callback(hObject, eventdata, handles) ;
    case 's'
         stop_Callback(hObject, eventdata, handles);
    case 'c'
        ClearGraphTag_Callback(hObject, eventdata, handles);
       
             
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

evalin('base','clear all');

delete(hObject);


% --- Executes on button press in photoButtonTag.
function photoButtonTag_Callback(hObject, eventdata, handles)
% hObject    handle to photoButtonTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

videoObject = videoinput('winvideo',1,'RGB24_1600x1200'); % Create the video object
set(videoObject, 'ReturnedColorSpace', 'RGB');   % Set the object to return RGB values
% h = imhandles(h);
h = preview(videoObject);
uistack(h, 'top');
keydown = waitforbuttonpress;
         if (keydown == 0)
             h =figure(2);
            photo = getsnapshot(videoObject);  % Take a snapshot
            closepreview(videoObject);
            imshow(photo);
            
       end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

handles.rate = str2double(get(hObject,'String'));

guidata(hObject, handles);  


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

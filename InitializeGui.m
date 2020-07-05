function InitializeGui(eventdata,handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Initialize plot properties.

% this part is to intitialize the plot so as to have a correct layout in
% the opening of the GUI
numberOfSamples = getappdata(handles.figure1,'settings_numberOfSamples');
timeStamps = nan(1, numberOfSamples);
rawData = nan(1, numberOfSamples);
plot(handles.axes1,timeStamps,rawData,'LineWidth',0.25,'Color',[1 0 0]);

% This part is common in opening and acquisition running formatting
scrollPlotWidth = getappdata(handles.figure1,'setting_scrollPlotWidth');
rightOffset = getappdata(handles.figure1,'settings_rightOffset');
xMin = 0;
xMax = scrollPlotWidth+rightOffset;
yMin = 0;
yMax = 1024;
set(handles.axes1,'XGrid','on',...
    'XMinorGrid','on',...
    'YGrid','on',...
    'YMinorGrid','on',...
    'XMinorTick','on',...
    'YMinorTick','on',...
    'GridColorMode','manual',...
    'GridColor',[0.4 0.6 0.7],...
    'FontSize',8,...
    'XLimMode','manual',...
    'YLimMode','manual',...
    'xlim',[xMin xMax],...
    'ylim',[yMin yMax]);

%title(handles.axes1,'Arduino Serial Data Acquisition','interpreter','latex');
xlabel(handles.axes1,'Elapsed Time (s)','FontSize',8);
ylabel(handles.axes1,'Raw Sensor Reading','FontSize',8);


%% Initialize panel properties.

set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'on');


set(handles.checkbox_scalingFunction,'Value',0);
AfDaq('checkbox_scalingFunction_Callback',handles.checkbox_scalingFunction, eventdata, handles);
set(handles.checkbox_scalingFunction,'Enable','off');

  

set(handles.popupmenu_channel1,'Value',1);
set(handles.popupmenu_channel2,'Value',1);
set(handles.popupmenu_channel3,'Value',1);
set(handles.popupmenu_channel4,'Value',1);
set(handles.popupmenu_channel5,'Value',1);
setappdata(handles.figure1,'settings_numberOfActiveChannels',0);


%% Initialize button properties.
set(handles.togglebutton_action,'Enable','off');
set(handles.togglebutton_action,'String','Start');
set(handles.togglebutton_action,'BackgroundColor',[0.94 0.94 0.94]);

set(handles.pushbutton_connect,'Enable','on');
set(handles.pushbutton_connect,'String','Connect');
set(handles.pushbutton_connect,'BackgroundColor',[0.94 0.94 0.94]);

set(handles.pushbutton_log,'Enable','off')



%% Initialize text properties.
% Setting text for session date
sessionDate = getappdata(handles.figure1,'settings_sessionDate');
string = sprintf('Session Date : %s', sessionDate);
set(handles.text_sessionDate, 'String', string);

% Setting text for session time
sessionTime = getappdata(handles.figure1,'settings_sessionTime');
string = sprintf('Session Time : %s', sessionTime);
set(handles.text_sessionTime, 'String', string);

% Setting text for session ID
sessionId = getappdata(handles.figure1,'settings_sessionId');
string = sprintf('Session ID : %s', sessionId);
set(handles.text_sessionId, 'String', string);

% Setting text for custom ID
customId = getappdata(handles.figure1,'settings_customId');
string = sprintf('Custom ID : %s', customId);
set(handles.text_customId, 'String', string);

% Setting text for recorded session duration
string = sprintf('Recorded Session Duration : %s sec', '.....');
set(handles.text_recordedSessionDuration, 'String', string);

% Setting text for recorded sampling frequency
string = sprintf('Recorded Sampling Frequency : %s Hz', '.....');
set(handles.text_recordedSamplingFrequency, 'String', string);

% Setting text for samples taken
string = sprintf('Recorded Number Of Samples : %s', '.....');
set(handles.text_recordedNumberOfSamples, 'String', string);

% Setting text for data quality
string = sprintf('Data Quality : %s %%', '.....');
set(handles.text_dataQuality, 'String', string);

%% initializing flags parameter variables and populating with the default values

setappdata(handles.figure1,'flags_isDebug',false);
setappdata(handles.figure1,'flags_isDataScaling',false);
setappdata(handles.figure1,'flags_isYMinAutoScale',false);
setappdata(handles.figure1,'flags_isYMaxAutoScale',false);
setappdata(handles.figure1,'flags_isAcqRunning',false);
setappdata(handles.figure1,'flags_isError',false);
setappdata(handles.figure1,'flags_isArduinoConnected',false);
setappdata(handles.figure1,'flags_isBenchmarkRunning',false);
setappdata(handles.figure1,'flags_isChannel1Running',false);
setappdata(handles.figure1,'flags_isChannel2Running',false);
setappdata(handles.figure1,'flags_isChannel3Running',false);
setappdata(handles.figure1,'flags_isChannel4Running',false);
setappdata(handles.figure1,'flags_isChannel5Running',false);


%% Initialize other properties.

cla(handles.axes1);
%dragzoom(handles.axes1);

%set(handles.output,'toolbar','figure');
set(handles.output,'menubar','figure');
set(handles.output, 'PaperPositionMode', 'auto');
set(handles.output,'InvertHardcopy','off');


%% Displaying status message.
string = 'GUI Initialized...!!!';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);

drawnow

end


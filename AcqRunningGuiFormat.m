function  AcqRunningGuiFormat(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Do not use get in this file because this is meant to set the formatting
% only and all things have already been get and variable are set prior to
% calling this file


%% Initialize plot properties.

% This part is required after calling plot, because calling plot will reset
% the axes prproperties
scrollPlotWidth = getappdata(handles.figure1,'setting_scrollPlotWidth');
rightOffset = getappdata(handles.figure1,'settings_rightOffset');
xMin = 0;
xMax = scrollPlotWidth+rightOffset;
yMin = 0;
yMax = 1024;
set(handles.axes1,'XGrid','on');
set(handles.axes1,'XMinorGrid','on');
set(handles.axes1,'YGrid','on');
set(handles.axes1,'YMinorGrid','on');

%title(handles.axes1,'Arduino Serial Data Acquisition','interpreter','latex');
xlabel(handles.axes1,'Elapsed Time (s)','interpreter','latex');
ylabel(handles.axes1,'Raw Sensor Reading','interpreter','latex');
set(handles.axes1,'XLimMode','manual','YLimMode','manual');
set(handles.axes1,'xlim',[xMin xMax],'ylim',[yMin yMax]);



%% Setting panel properties.
set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'off');

set(handles.text_scalingFunction,'Enable','off')
set(handles.checkbox_scalingFunction,'Enable','off')
set(handles.edit_scalingFunction,'Enable','off')


%% Setting button properties.

set(handles.togglebutton_action,'String','Stop');
set(handles.togglebutton_action,'BackgroundColor',[0 0.94 0]);
set(handles.pushbutton_reset,'Enable','off')
set(handles.pushbutton_snapshot,'Enable','off')
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

% Setting text for recorded samplinf frequency
string = sprintf('Recorded Sampling Frequency : %s Hz', '.....');
set(handles.text_recordedSamplingFrequency, 'String', string);

% Setting text for samples taken
string = sprintf('Recorded Number Of Samples : %s', '.....');
set(handles.text_recordedNumberOfSamples, 'String', string);

% Setting text for data quality
string = sprintf('Data Quality : %s %%', '.....');
set(handles.text_dataQuality, 'String', string);


%% Initialize other properties.




%% Displaying status message.
string = 'Acquisition Running';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);
        
drawnow

       
end


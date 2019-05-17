function DefaultSettings(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Do not use get in this file because this is meant to set the formatting
% only and all things have already been get and variable are set prior to
% calling this file



%% Populating all parameters with the defaults

set(handles.edit_sessionDuration,'String',30);
sessionDuration = str2double(get(handles.edit_sessionDuration,'String'));
setappdata(handles.figure1,'settings_sessionDuration',sessionDuration);

set(handles.edit_samplingFrequency,'String',10);
samplingFrequency = str2double(get(handles.edit_samplingFrequency,'String'));
setappdata(handles.figure1,'settings_samplingFrequency',samplingFrequency);


set(handles.edit_scrollPlotWidth,'String',30);
scrollPlotWidth = str2double(get(handles.edit_scrollPlotWidth,'String'));
setappdata(handles.figure1,'setting_scrollPlotWidth',scrollPlotWidth);

setappdata(handles.figure1,'settings_rightOffset',ceil(scrollPlotWidth/10));

set(handles.edit_yMinValue,'String',0);
set(handles.edit_yMaxValue,'String',1024);



drawnow

end


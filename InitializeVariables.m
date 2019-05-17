function  InitializeVariables(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here






%% initializing settings parameter variables -- do not initialize defaults here because this function is called each time at each start button press and also the formatting is done in DaqMultiChannelGuiInit() before calling this function

% Daq Date and Time code
daqDateTime = datetime('now');
setappdata(handles.figure1,'settings_daqDateTime',daqDateTime);

% Session Date 
sessionDate = datestr(daqDateTime,'dd-mmmm-yyyy');
setappdata(handles.figure1,'settings_sessionDate',sessionDate);

% Session Time 
sessionTime = datestr(daqDateTime,'HH:MM:SS AM');
setappdata(handles.figure1,'settings_sessionTime',sessionTime);

% Custom ID 
customId = get(handles.edit_customId,'String');
setappdata(handles.figure1,'settings_customId',customId);

% Session ID 
yearValue = daqDateTime.Year;
yearValue  = num2str(yearValue);

monthValue = daqDateTime.Month;
if(monthValue<10)
monthValue = sprintf('0%d',monthValue);
else
    monthValue  = num2str(monthValue);
end

dateValue = daqDateTime.Day;
if(dateValue<10)
dateValue = sprintf('0%d',dateValue);
else
    dateValue  = num2str(dateValue);
end

hourValue = daqDateTime.Hour;
if(hourValue<10)
hourValue = sprintf('0%d',hourValue);
else
    hourValue  = num2str(hourValue);
end


minuteValue = daqDateTime.Minute;
if(minuteValue<10)
minuteValue = sprintf('0%d',minuteValue);
else
    minuteValue  = num2str(minuteValue);
end


secondValue = fix(daqDateTime.Second);
if(secondValue<10)
secondValue = sprintf('0%d',secondValue);
else
    secondValue = num2str(secondValue);
end

millisecValue = round((daqDateTime.Second - secondValue)*1000);
millisecValue = num2str(millisecValue);


sessionId  = sprintf('%s%s%s%s%s%s%s', yearValue, monthValue, dateValue, hourValue, minuteValue, secondValue,customId);
setappdata(handles.figure1,'settings_sessionId',sessionId);

% Session Duration 
sessionDuration = str2double(get(handles.edit_sessionDuration,'String'));
setappdata(handles.figure1,'settings_sessionDuration',sessionDuration);


% Sampling Frequency 
samplingFrequency = str2double(get(handles.edit_samplingFrequency,'String'));
setappdata(handles.figure1,'settings_samplingFrequency',samplingFrequency);


% Sampling Time Interval 
setappdata(handles.figure1,'settings_samplingTimeInterval',1/samplingFrequency);


% Scroll Plot Width 
scrollPlotWidth = str2double(get(handles.edit_scrollPlotWidth,'String'));
setappdata(handles.figure1,'setting_scrollPlotWidth',scrollPlotWidth);
  

% Right Offset 
setappdata(handles.figure1,'settings_rightOffset',ceil(scrollPlotWidth/10));

% Scaling Function 
isDataScaling = getappdata(handles.figure1,'flags_isDataScaling');
if(isDataScaling)
 scalingFunction = get(handles.edit_scalingFunction,'String');
 setappdata(handles.figure1,'settings_scalingFunction',scalingFunction);
end

% YAxis Autoscale
isYAxisAutoScale = getappdata(handles.figure1,'flags_isYAxisAutoScale');


% Number of samples to be recorded 
numberOfSamples = samplingFrequency * sessionDuration;
setappdata(handles.figure1,'settings_numberOfSamples',numberOfSamples);

% Number of channels to be recorded
setappdata(handles.figure1,'settings_numberOfActiveChannels',[]);

isChannel1Running = getappdata(handles.figure1,'flags_isChannel1Running');
isChannel2Running = getappdata(handles.figure1,'flags_isChannel2Running');
isChannel3Running = getappdata(handles.figure1,'flags_isChannel3Running');
isChannel4Running = getappdata(handles.figure1,'flags_isChannel4Running');
isChannel5Running = getappdata(handles.figure1,'flags_isChannel5Running');

if(~isChannel1Running)
% Channel 1 type and pin
setappdata(handles.figure1,'settings_channel1Type',[]);
setappdata(handles.figure1,'settings_channel1Pin',[]);
end

if(~isChannel2Running)
% Channel 2 type and pin
setappdata(handles.figure1,'settings_channel2Type',[]);
setappdata(handles.figure1,'settings_channel2Pin',[]);
end

if(~isChannel3Running)
% Channel 2 type and pin
setappdata(handles.figure1,'settings_channel3Type',[]);
setappdata(handles.figure1,'settings_channel3Pin',[]);
end

if(~isChannel4Running)
% Channel 2 type and pin
setappdata(handles.figure1,'settings_channel4Type',[]);
setappdata(handles.figure1,'settings_channel4Pin',[]);
end

if(~isChannel5Running)
% Channel 2 type and pin
setappdata(handles.figure1,'settings_channel5Type',[]);
setappdata(handles.figure1,'settings_channel5Pin',[]);
end


% yMin and yMax value
setappdata(handles.figure1,'settings_yMinValue',str2double(get(handles.edit_yMinValue,'String')));
setappdata(handles.figure1,'settings_yMaxValue',str2double(get(handles.edit_yMaxValue,'String')));

% Status message for the user
setappdata(handles.figure1,'settings_statusMsg',[]);


%% initializing data parameter variables and populating with the blank

% The time stamps of the data
setappdata(handles.figure1,'data_timeStampsRaw',[]);
setappdata(handles.figure1,'data_timeStampsMsec',[]);

% The raw data acquired - Channel 1 to 5
setappdata(handles.figure1,'data_rawDataChannel1',[]);
setappdata(handles.figure1,'data_rawDataChannel2',[]);
setappdata(handles.figure1,'data_rawDataChannel3',[]);
setappdata(handles.figure1,'data_rawDataChannel4',[]);
setappdata(handles.figure1,'data_rawDataChannel5',[]);

% The scaled data based on selected scaling function
setappdata(handles.figure1,'data_scaledDataChannel1',[]);

% the actual recorded session duration
setappdata(handles.figure1,'data_recordedSessionDuration',[]);

% The actual recorded sampling frequency (This will be computed after acquisition)
setappdata(handles.figure1,'data_recordedSamplingFrequency',[]);

% The actual recorded number of samples
setappdata(handles.figure1,'data_recordedNumberOfSamples',[]);

% Data Quality
setappdata(handles.figure1,'data_dataQuality',[]);


% The sample number
setappdata(handles.figure1,'data_sampleNumber',[]);


drawnow

end


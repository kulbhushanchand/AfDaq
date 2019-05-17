function  CalculateResults(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

recordedNumberOfSamples = getappdata(handles.figure1,'data_recordedNumberOfSamples');
timeStampsMsec = getappdata(handles.figure1,'data_timeStampsMsec');

lastTimeStamp = timeStampsMsec(1,recordedNumberOfSamples);
recordedSessionDuration = lastTimeStamp/1000;

recordedSamplingFrequency = recordedNumberOfSamples/recordedSessionDuration;

setappdata(handles.figure1,'data_recordedSessionDuration',recordedSessionDuration);
setappdata(handles.figure1,'data_recordedSamplingFrequency',recordedSamplingFrequency);

% Setting text for recorded session duration
string = sprintf('Recorded Session Duration : %0.2f sec', recordedSessionDuration);
set(handles.text_recordedSessionDuration, 'String', string);

% Setting text for recorded samplinf frequency
string = sprintf('Recorded Sampling Frequency : %0.2f Hz', recordedSamplingFrequency);
set(handles.text_recordedSamplingFrequency, 'String', string);

% Setting text for samples recorded
string = sprintf('Recorded Number Of Samples : %d', recordedNumberOfSamples);
set(handles.text_recordedNumberOfSamples, 'String', string);

% Setting text for data quality
samplingFrequency = str2double(get(handles.edit_samplingFrequency,'String'));
sessionDuration = str2double(get(handles.edit_sessionDuration,'String'));
string = sprintf('Data Quality : %0.1f %%', (100 * recordedNumberOfSamples/round(recordedSessionDuration * samplingFrequency)));
set(handles.text_dataQuality, 'String', string);

% assignin('base','data_recordedSessionDuration',recordedSessionDuration);
% assignin('base','data_recordedSamplingFrequency',recordedSamplingFrequency);

drawnow

end


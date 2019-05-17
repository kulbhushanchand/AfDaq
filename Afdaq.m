function varargout = Afdaq(varargin)
% AFDAQ MATLAB code for Afdaq.fig
%      AFDAQ, by itself, creates a new AFDAQ or raises the existing
%      singleton*.
%
%      H = AFDAQ returns the handle to a new AFDAQ or the handle to
%      the existing singleton*.
%
%      AFDAQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFDAQ.M with the given input arguments.
%
%      AFDAQ('Property','Value',...) creates a new AFDAQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Afdaq_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Afdaq_OpeningFcn via varargin.
%

%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Afdaq

% Last Modified by GUIDE v2.5 08-May-2019 11:10:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Afdaq_OpeningFcn, ...
    'gui_OutputFcn',  @Afdaq_OutputFcn, ...
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


% --- Executes just before Afdaq is made visible.
function Afdaq_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Afdaq (see VARARGIN)

% Choose default command line output for Afdaq
handles.output = hObject;
guidata(hObject, handles);


evalin('base','clear');
clc
format;

%set(handles.figure1,'Position', [0 0.2 0.8 0.8]);

set(findall(handles.figure1,'-property','FontUnits'),'FontUnits','normalized');


DefaultSettings(handles);
InitializeVariables(handles);
InitializeGui(eventdata,handles);
Arduino(handles,'initialize');


disp('Session Started...');

% UIWAIT makes Afdaq wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Afdaq_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in togglebutton_action.
function togglebutton_action_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_action (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_action


%try

u = udp('127.0.0.1',8000);
fopen(u);

actionButtonState = get(hObject,'Value');

if actionButtonState == get(hObject,'Max')
    
    InitializeVariables(handles);
    ard = getappdata(handles.figure1,'settings_ard');

    %  profile on
    % initializing some of the variables to be used in the loop
    timeInterval = getappdata(handles.figure1,'settings_samplingTimeInterval');
    sessionDuration = getappdata(handles.figure1,'settings_sessionDuration');
    numberOfSamples = getappdata(handles.figure1,'settings_numberOfSamples');
    sampleNumber = nan(1, numberOfSamples);
    timeStampsMsec = nan(1, numberOfSamples);
    rawDataChannel1 = uint16(nan(1, numberOfSamples));
    rawDataChannel2 = uint16(nan(1, numberOfSamples));
    rawDataChannel3 = uint16(nan(1, numberOfSamples));
    rawDataChannel4 = uint16(nan(1, numberOfSamples));
    rawDataChannel5 = uint16(nan(1, numberOfSamples));
    scaledDataChannel1 = nan(1, numberOfSamples);
    
    timeJitterDiff = uint16(nan(1, numberOfSamples));      
    
    samplingFrequency = getappdata(handles.figure1,'settings_samplingFrequency');
        
    isDataScaling =  getappdata(handles.figure1,'flags_isDataScaling');
    isBenchmarkRunning =   getappdata(handles.figure1,'flags_isBenchmarkRunning');
    
    
    if(isDataScaling)
        scalingFunction = getappdata(handles.figure1,'settings_scalingFunction');
        scalingFunction = strrep(scalingFunction,'X','rawDataSampleChannel1');
        scalingFunction = char(scalingFunction);
    end
    
    
    scrollPlotWidth = getappdata(handles.figure1,'setting_scrollPlotWidth');
    rightOffset = getappdata(handles.figure1,'settings_rightOffset');
        
    count = 0;
    lCount = 1;
    overruns = 0;
    
    isChannel1Running = getappdata(handles.figure1,'flags_isChannel1Running');
    isChannel2Running = getappdata(handles.figure1,'flags_isChannel2Running');
    isChannel3Running = getappdata(handles.figure1,'flags_isChannel3Running');
    isChannel4Running = getappdata(handles.figure1,'flags_isChannel4Running');
    isChannel5Running = getappdata(handles.figure1,'flags_isChannel5Running');
    
    channel1Type = getappdata(handles.figure1,'settings_channel1Type');
    channel1Pin =  getappdata(handles.figure1,'settings_channel1Pin');
    channel2Type = getappdata(handles.figure1,'settings_channel2Type');
    channel2Pin =  getappdata(handles.figure1,'settings_channel2Pin');
    channel3Type = getappdata(handles.figure1,'settings_channel3Type');
    channel3Pin =  getappdata(handles.figure1,'settings_channel3Pin');
    channel4Type = getappdata(handles.figure1,'settings_channel4Type');
    channel4Pin =  getappdata(handles.figure1,'settings_channel4Pin');
    channel5Type = getappdata(handles.figure1,'settings_channel5Type');
    channel5Pin =  getappdata(handles.figure1,'settings_channel5Pin');
    
    numberOfActiveChannels =  NumberOfActiveChannels(handles);
    setappdata(handles.figure1,'settings_numberOfChannels',numberOfActiveChannels);
    
    dcBias = 0;
    if(isChannel1Running)
        if(strcmp(channel1Type,'AnalogInput'))
            configurePin(ard,channel1Pin,channel1Type);
        elseif(strcmp(channel1Type,'DigitalInput'))
            configurePin(ard,channel1Pin,channel1Type);
            configurePin(ard,channel1Pin,'pullup');
            dcBiasChannel1 = dcBias;
            dcBias = dcBias + 200;
        end
    end
    
    if(isChannel2Running)
        
        if(strcmp(channel2Type,'AnalogInput'))
            configurePin(ard,channel2Pin,channel2Type);
        elseif(strcmp(channel2Type,'DigitalInput'))
            configurePin(ard,channel2Pin,channel2Type);
            configurePin(ard,channel2Pin,'pullup');
            dcBiasChannel2 = dcBias;
            dcBias = dcBias + 200;
        end
    end
    
    if(isChannel3Running)
        if(strcmp(channel3Type,'AnalogInput'))
            configurePin(ard,channel3Pin,channel3Type);
        elseif(strcmp(channel3Type,'DigitalInput'))
            configurePin(ard,channel3Pin,channel3Type);
            configurePin(ard,channel3Pin,'pullup');
            dcBiasChannel3 = dcBias;
            dcBias = dcBias + 200;
        end
    end
    
    if(isChannel4Running)
        if(strcmp(channel4Type,'AnalogInput'))
            configurePin(ard,channel4Pin,channel4Type);
        elseif(strcmp(channel4Type,'DigitalInput'))
            configurePin(ard,channel4Pin,channel4Type);
            configurePin(ard,channel4Pin,'pullup');
            dcBiasChannel4 = dcBias;
            dcBias = dcBias + 200;
        end
    end
    
    if(isChannel5Running)
        if(strcmp(channel5Type,'AnalogInput'))
            configurePin(ard,channel5Pin,channel5Type);
        elseif(strcmp(channel5Type,'DigitalInput'))
            configurePin(ard,channel5Pin,channel5Type);
            configurePin(ard,channel5Pin,'pullup');
            dcBiasChannel5 = dcBias;
            %dcBias = dcBias + 200;
        end
    end
    
    if(numberOfActiveChannels>1)
        hold( handles.axes1, 'on' );
    end
    
    hold( handles.axes1, 'on' );
    cla(handles.axes1);
    
    if(isChannel1Running)
        plotHandle1 = plot(handles.axes1,timeStampsMsec,rawDataChannel1,'LineWidth',0.25,'Color',[1 0 0]);
    end
    if(isChannel2Running)
        plotHandle2 = plot(handles.axes1,timeStampsMsec,rawDataChannel2,'LineWidth',0.25,'Color',[0 0 1]);
    end
    if(isChannel3Running)
        plotHandle3 = plot(handles.axes1,timeStampsMsec,rawDataChannel3,'LineWidth',0.25,'Color',[0 1 0]);
    end
    if(isChannel4Running)
        plotHandle4 = plot(handles.axes1,timeStampsMsec,rawDataChannel4,'LineWidth',0.25,'Color',[1 0 0]);
    end
    if(isChannel5Running)
        plotHandle5 = plot(handles.axes1,timeStampsMsec,rawDataChannel5,'LineWidth',0.25,'Color',[1 0 1]);
    end
    
    plotHandle6 = plot(handles.axes1,timeStampsMsec,timeJitterDiff,'LineWidth',0.25,'Color',[0 0 0]);
      
    AcqRunningGuiFormat(handles);
    
    timeIntervalUs = timeInterval * 10^6;
    timeJitterUs = 0;
    
     
    tic;
    timeSample = toc*10^6;
    
    % profile on
    while(actionButtonState && (toc <= sessionDuration) )
        
        
        while( ((toc*10^6) - timeSample) < (timeIntervalUs - timeJitterUs) )
            % disp('wasting time')
            pause(0);
        end
        
        count = count + 1;
        timeSample = toc*10^6;
               
        if(isChannel1Running)
            if(strcmp(channel1Type,'AnalogInput'))
                rawDataChannel1(count) = readVoltage(ard, channel1Pin) * (1023/5);
            elseif(strcmp(channel1Type,'DigitalInput'))
                rawDataChannel1(count) = (1 - readDigitalPin(ard,channel1Pin)) * (150) + dcBiasChannel1;
            end
        end
        
        if(isChannel2Running)
            if(strcmp(channel2Type,'AnalogInput'))
                rawDataChannel2(count) = readVoltage(ard, channel2Pin) * (1023/5);
            elseif(strcmp(channel2Type,'DigitalInput'))
                rawDataChannel2(count) = (1 - readDigitalPin(ard,channel2Pin)) * (150) + dcBiasChannel2;
            end
        end
        
        if(isChannel3Running)
            if(strcmp(channel3Type,'AnalogInput'))
                rawDataChannel3(count) = readVoltage(ard, channel3Pin) * (1023/5);
            elseif(strcmp(channel3Type,'DigitalInput'))
                rawDataChannel3(count) = (1 - readDigitalPin(ard,channel3Pin)) * (150) + dcBiasChannel3;
            end
        end
        
        if(isChannel4Running)
            if(strcmp(channel4Type,'AnalogInput'))
                rawDataChannel4(count) = readVoltage(ard, channel4Pin) * (1023/5);
            elseif(strcmp(channel4Type,'DigitalInput'))
                rawDataChannel4(count) = (1 - readDigitalPin(ard,channel4Pin)) * (150) + dcBiasChannel4;
            end
        end
        
        if(isChannel5Running)
            if(strcmp(channel5Type,'AnalogInput'))
                rawDataChannel5(count) = readVoltage(ard, channel5Pin) * (1023/5);
            elseif(strcmp(channel5Type,'DigitalInput'))
                rawDataChannel5(count) = (1 - readDigitalPin(ard,channel5Pin)) * (150) + dcBiasChannel5;
            end
        end
          
        
        %timeStampsMsec = timeSample/(10^3);
        timeSampleSec = timeSample/(10^6);
        
        % filling data in the correponding arrays
        sampleNumber(count) = count;
        timeStampsMsec(count) = timeSample/(10^3);
        
            
        % Calculating scaled data sample
        if(isDataScaling)
            scaledDataSampleChannel1 = eval(scalingFunction);
            scaledDataChannel1(count) = scaledDataSampleChannel1;
        end
        
        isYAxisAutoScale = getappdata(handles.figure1,'flags_isYAxisAutoScale');   
        yMinValue = getappdata(handles.figure1,'settings_yMinValue');
        yMaxValue = getappdata(handles.figure1,'settings_yMaxValue');
        
        
        % setting plot axes property
        if(timeSampleSec > scrollPlotWidth)
            lCount = lCount + 1;
            
            xMin = timeSampleSec-scrollPlotWidth;
            xMax = timeSampleSec+rightOffset;
            
            if(isYAxisAutoScale)
                if(isDataScaling)
                    yMin = min(scaledDataChannel1(lCount : count));
                    yMax = max(scaledDataChannel1(lCount : count));
                else
                    yMin = min(rawDataChannel1(lCount : count));
                    yMax = max(rawDataChannel1(lCount : count));
                end
            else
                yMin = yMinValue;
                yMax = yMaxValue;
            end
         
         
        else
            % timeSampleSec <= scrollPlotWidth
            
            xMin = 0;
            xMax = scrollPlotWidth+rightOffset;
            
            if(isYAxisAutoScale)
                if(isDataScaling)
                    yMin = min(scaledDataChannel1(1 : count));
                    yMax = max(scaledDataChannel1(1 : count));
                else
                    yMin = min(rawDataChannel1(1 : count));
                    yMax = max(rawDataChannel1(1 : count));
                end
            else
                yMin = yMinValue;
                yMax = yMaxValue;
            end
      
            
        end
        
        yMax = yMax + (0.01*yMax);
        yMin = yMin - (0.01*yMin);
        
        
        set(handles.axes1,'xlim',[xMin xMax],'ylim',[yMin yMax]);
        
      
        % Plotting data
    
        if(isChannel1Running)
            if(isDataScaling)
                set(plotHandle1,'YData',scaledDataChannel1,'XData',timeStampsMsec/1000);
            else
                set(plotHandle1,'YData',rawDataChannel1,'XData',timeStampsMsec/1000);
            end
        end
        if(isChannel2Running)
            set(plotHandle2,'YData',rawDataChannel2,'XData',timeStampsMsec/1000);
        end
        if(isChannel3Running)
            set(plotHandle3,'YData',rawDataChannel3,'XData',timeStampsMsec/1000);
        end
        if(isChannel4Running)
            set(plotHandle4,'YData',rawDataChannel4,'XData',timeStampsMsec/1000);
        end
        if(isChannel5Running)
            set(plotHandle5,'YData',rawDataChannel5,'XData',timeStampsMsec/1000);
        end
     
        
         % timeJitterDiff(count) = timeStampsMsec(count) - (count*(1000/samplingFrequency));
        if(count > 1)
             timeJitterDiff(count) = timeStampsMsec(count) - timeStampsMsec(count-1);
             set(plotHandle6,'YData',timeJitterDiff,'XData',timeStampsMsec/1000);
        end
        
       % oscsend(u,'/oscValue','i',rawDataChannel1(count));
      
             
       timeJitterUs = timeSample - (timeIntervalUs*(count));
       
       actionButtonState = get(hObject,'Value');
       drawnow;
       
    end
    
    
   %  profile viewer
    % Saving data in the application data handle
    
    recordedNumberOfSamples = count;
    
    %         assignin('base','data_sampleNumber',sampleNumber);
    %         assignin('base','data_timeStampsMsec',timeStampsMsec);
    %         assignin('base','data_rawDataChannel1',rawDataChannel1);
    
    
    sampleNumber = sampleNumber(1:recordedNumberOfSamples);
    timeStampsMsec = round(timeStampsMsec(1:recordedNumberOfSamples),0);
    
    setappdata(handles.figure1,'data_sampleNumber',sampleNumber);
    setappdata(handles.figure1,'data_timeStampsMsec',timeStampsMsec);
    setappdata(handles.figure1,'data_recordedNumberOfSamples',recordedNumberOfSamples);
    
    
    dcBias = 0;
        
    if(isChannel1Running)
        if(strcmp(channel1Type,'AnalogInput'))
          rawDataChannel1 = rawDataChannel1(1:recordedNumberOfSamples); 
          setappdata(handles.figure1,'data_rawDataChannel1',rawDataChannel1);
        elseif(strcmp(channel1Type,'DigitalInput'))
            dcBiasChannel1 = dcBias;
            dcBias = dcBias + 200;
            rawDataChannel1 = (rawDataChannel1 - dcBiasChannel1)/150;
            setappdata(handles.figure1,'data_rawDataChannel1',rawDataChannel1);
        end
    end
    if(isChannel2Running)
        if(strcmp(channel2Type,'AnalogInput'))
          rawDataChannel2 = rawDataChannel2(1:recordedNumberOfSamples); 
          setappdata(handles.figure1,'data_rawDataChannel2',rawDataChannel2);
        elseif(strcmp(channel2Type,'DigitalInput'))
            dcBiasChannel2 = dcBias;
            dcBias = dcBias + 200;
            rawDataChannel2 = (rawDataChannel2 - dcBiasChannel2)/150;
            setappdata(handles.figure1,'data_rawDataChannel2',rawDataChannel2);
        end
    end
    if(isChannel3Running)
        if(strcmp(channel3Type,'AnalogInput'))
           rawDataChannel3 = rawDataChannel3(1:recordedNumberOfSamples); 
           setappdata(handles.figure1,'data_rawDataChannel3',rawDataChannel3);
        elseif(strcmp(channel3Type,'DigitalInput'))
            dcBiasChannel3 = dcBias;
            dcBias = dcBias + 200;
            rawDataChannel3 = (rawDataChannel3 - dcBiasChannel3)/150;
            setappdata(handles.figure1,'data_rawDataChannel3',rawDataChannel3);
        end
    end
    if(isChannel4Running)
        if(strcmp(channel4Type,'AnalogInput'))
            rawDataChannel4 = rawDataChannel4(1:recordedNumberOfSamples); 
            setappdata(handles.figure1,'data_rawDataChannel4',rawDataChannel4);
        elseif(strcmp(channel4Type,'DigitalInput'))
            dcBiasChannel4 = dcBias;
            dcBias = dcBias + 200;
            rawDataChannel4 = (rawDataChannel4 - dcBiasChannel4)/150;
            setappdata(handles.figure1,'data_rawDataChannel4',rawDataChannel4);
        end
    end
    if(isChannel5Running)
        if(strcmp(channel5Type,'AnalogInput'))
            rawDataChannel5 = rawDataChannel5(1:recordedNumberOfSamples); 
            setappdata(handles.figure1,'data_rawDataChannel5',rawDataChannel5);
        elseif(strcmp(channel5Type,'DigitalInput'))
            dcBiasChannel5 = dcBias;
            rawDataChannel5 = (rawDataChannel5 - dcBiasChannel5)/150;
            setappdata(handles.figure1,'data_rawDataChannel5',rawDataChannel5);
        end
    end
    
    if(isDataScaling)
         scaledDataChannel1 = scaledDataChannel1(1:recordedNumberOfSamples);
         setappdata(handles.figure1,'data_scaledDataChannel1',scaledDataChannel1);
    end
    
 
    

%     assignin('base','data_timeStampsMsec',timeStampsMsec);
%     assignin('base','data_rawDataChannel1',rawDataChannel1);
%     assignin('base','data_rawDataChannel2',rawDataChannel2);
%     assignin('base','data_rawDataChannel3',rawDataChannel3);
%     assignin('base','data_rawDataChannel4',rawDataChannel4);
%     assignin('base','data_rawDataChannel5',rawDataChannel5);
%     assignin('base','data_scaledDataChannel1',scaledDataChannel1);
%     assignin('base','data_scaledDataChannel1',hrIBI);
    
    %figure
    %plot(diff(timeStampsMsec)-timeInterval)
    
    %   data = [sampleNumber; timeStampsMsec; rawData];
    %   data = data';
    
    AcqStoppedGuiFormat(handles);
    CalculateResults(handles)
    %profile viewer
end


% catch ME
%     disp(ME.identifier)
%     disp(ME)
%     disp('catch activated')
%
%     string = '!!!...ERROR...!!!';
%     color = [0.964, 0.243, 0.192];
%     set(handles.text_statusMsg, 'String', string);
%     set(handles.text_statusMsg, 'ForegroundColor', color);
%     switch ME.identifier
%         case {'MATLAB:arduinoio:general:invalidAddressType', 'MATLAB:arduinoio:general:invalidAddressPCMac' , 'MATLAB:arduinoio:general:invalidPort'}
%             disp(ME.identifier)
%
%         otherwise
%              disp(ME.identifier)
%              disp('Unknown error !!!');
%end





% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global ard rightOffset scrollWidth data;

%fclose(serial(ard.Port)); %Create a serial object with the port Arduino is connected to it and close it
%clear ard; %Remove the variable
clear global;
close all;

%clc;
%delete(instrfind);
disp('Session Terminated...');



function edit_samplingFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to edit_samplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_samplingFrequency as text
%        str2double(get(hObject,'String')) returns contents of edit_samplingFrequency as a double

samplingFrequency = str2double(get(handles.edit_samplingFrequency,'String'));
if(samplingFrequency<=0)
    set(handles.edit_samplingFrequency,'String',num2str(1));
elseif(samplingFrequency>50)
    set(handles.edit_samplingFrequency,'String',num2str(50));
end



% --- Executes during object creation, after setting all properties.
function edit_samplingFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_samplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_log.
function pushbutton_log_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

string = 'Data Logging - Initiated';
color = [0.94 0 0];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);
drawnow

serialPort = getappdata(handles.figure1,'settings_serialPort');
ardBoard = getappdata(handles.figure1,'settings_ardBoard');
customId = getappdata(handles.figure1,'settings_customId');
sessionId = getappdata(handles.figure1,'settings_sessionId');
sessionDate = getappdata(handles.figure1,'settings_sessionDate');
sessionTime = getappdata(handles.figure1,'settings_sessionTime');
sessionDuration = getappdata(handles.figure1,'settings_sessionDuration');
samplingFrequency = getappdata(handles.figure1,'settings_samplingFrequency');
samplingTimeInterval = round(getappdata(handles.figure1,'settings_samplingTimeInterval')*1000,0);
numberOfSamples = getappdata(handles.figure1,'settings_numberOfSamples');
scrollPlotWidth = getappdata(handles.figure1,'setting_scrollPlotWidth');
isDataScaling = getappdata(handles.figure1,'flags_isDataScaling');
if(isDataScaling)
    scalingFunction = getappdata(handles.figure1,'settings_scalingFunction');
else
    scalingFunction = 'Off';
end
numberOfChannels = getappdata(handles.figure1,'settings_numberOfChannels');

contents = cellstr(get(handles.popupmenu_channel1,'String'));
channel1 = contents{get(handles.popupmenu_channel1,'Value')};
contents = cellstr(get(handles.popupmenu_channel2,'String'));
channel2 = contents{get(handles.popupmenu_channel2,'Value')};
contents = cellstr(get(handles.popupmenu_channel3,'String'));
channel3 = contents{get(handles.popupmenu_channel3,'Value')};
contents = cellstr(get(handles.popupmenu_channel4,'String'));
channel4 = contents{get(handles.popupmenu_channel4,'Value')};
contents = cellstr(get(handles.popupmenu_channel5,'String'));
channel5 = contents{get(handles.popupmenu_channel5,'Value')};


DAQ_Settings = { serialPort,...
    ardBoard,...
    customId,...
    sessionId,...
    sessionDate,...
    sessionTime,...
    sessionDuration,...
    samplingFrequency,...
    samplingTimeInterval,...
    numberOfSamples,...
    scrollPlotWidth,...
    scalingFunction,...
    numberOfChannels,...
    channel1,...
    channel2,...
    channel3,...
    channel4,...
    channel5};

recordedSessionDuration = round(getappdata(handles.figure1,'data_recordedSessionDuration'),2);
recordedSamplingFrequency = round(getappdata(handles.figure1,'data_recordedSamplingFrequency'),2);
recordedNumberOfSamples = getappdata(handles.figure1,'data_recordedNumberOfSamples');
sessionRecordingPercentage = round((recordedSessionDuration/sessionDuration)*100,2);

DAQ_Results = { recordedSessionDuration,...
    recordedSamplingFrequency,...
    recordedNumberOfSamples,...
    sessionRecordingPercentage};


sampleNumber = getappdata(handles.figure1,'data_sampleNumber');
timeStampsMsec = getappdata(handles.figure1,'data_timeStampsMsec');
rawDataChannel1 = getappdata(handles.figure1,'data_rawDataChannel1');
rawDataChannel2 = getappdata(handles.figure1,'data_rawDataChannel2');
rawDataChannel3 = getappdata(handles.figure1,'data_rawDataChannel3');
rawDataChannel4 = getappdata(handles.figure1,'data_rawDataChannel4');
rawDataChannel5 = getappdata(handles.figure1,'data_rawDataChannel5');
scaledDataChannel1 = getappdata(handles.figure1,'data_scaledDataChannel1');

data = [sampleNumber' timeStampsMsec' rawDataChannel1' rawDataChannel2' rawDataChannel3' rawDataChannel4' rawDataChannel5' scaledDataChannel1'];
%dataCell = num2cell(data);
%dataCell(isnan(data)) ={'NaN'};

% B = num2cell(A);
% B(isnan(A)) ={'NaN'};



% if(exist('daq_1_channel_data.xlsx', 'file'))
%
%     t = xlsread('daq_1_channel_data.xlsx');
%     if ~isempty(t)
%         xlswrite('daq_1_channel_data.xlsx',zeros(size(t))*nan);
%     end
% end


col_header(1,3) = {'Arduino Serial Data Acquisition'};
col_header([3:21],1)={'DAQ Settings',...
    'Serial Port of Arduino',...
    'Arduino Model'...
    'Custom ID'...
    'Session ID'...
    'Session Date'...
    'Session Time'...
    'Session Duration (sec)'...
    'Sampling Frequency (Hz)'...
    'Sampling Time Interval (msec)'...
    'Number of Samples to be Recorded'...
    'Scroll Plot Width (sec)'...
    'Scaling Function',...
    'Number of Channels',...
    'Channel 1',...
    'Channel 2',...
    'Channel 3',...
    'Channel 4',...
    'Channel 5'};

col_header([3:7],4)={'DAQ Results',...
    'Recorded Session Duration (sec)',...
    'Recorded Sampling Frequency (Hz)'...
    'Recorded Number of Samples'...
    'Session recording %age'};
col_header(23,[1:8]) = {'Sample Number','Time Stamps (msec)','Raw Sensor Data - Channel 1','Raw Sensor Data - Channel 2','Raw Sensor Data - Channel 3','Raw Sensor Data - Channel 4','Raw Sensor Data - Channel 5','Scaled Sensor Data'};


[status, msg, msgID] = mkdir('LoggedData');


defname  = num2str(sessionId);

[FileName, PathName] = uiputfile({'*.xlsx';'*.xls'},'Log Data to File...',[defname '.xlsx']);

if FileName ~=0
    if exist([PathName FileName],'file')
        delete([PathName FileName ]);
    end
    
    xlswrite([PathName FileName],col_header,'Sheet1','A1');
    xlswrite([PathName FileName],DAQ_Settings','Sheet1','B4');     %Write data
    xlswrite([PathName FileName],DAQ_Results','Sheet1','E4');      %Write data
    xlswrite([PathName FileName],data,'Sheet1','A24');             %Write data
    xlsAutoFitCol([PathName FileName],'Sheet1','A:I');
    xlsfont([PathName FileName],'Sheet1','whole','font','Calibri','size',11);
    xlsalign([PathName FileName],'Sheet1','C1:E1','MergeCells',1);
    xlsborder([PathName FileName],'Sheet1','C1','Box',1,3,1);
    xlsfont([PathName FileName],'Sheet1','C1:E1','size',20,'fontstyle','bold');
    xlsfont([PathName FileName],'Sheet1','A3:D3','size',11,'fontstyle','bold');
    xlsfont([PathName FileName],'Sheet1','A23:I23','size',11,'fontstyle','bold');
    xlsalign([PathName FileName],'Sheet1','B4:B21','Horizontal',4);
    xlsalign([PathName FileName],'Sheet1','E4:E7','Horizontal',4);
    
    %xlswrite('daq_1_channel_data.xlsx',col_header,'Sheet1','A1');     %Write column header
    %xlswrite('daq_1_channel_data.xlsx',row_header,'Sheet1','A2');      %Write row header
    
    string = 'Data Logging - Completed';
    color = [0 0.38 0.11];
    set(handles.text_statusMsg, 'String', string);
    set(handles.text_statusMsg, 'ForegroundColor', color);
    
else
    
    string = 'Data Logging - Cancelled';
    color = [0 0.38 0.11];
    set(handles.text_statusMsg, 'String', string);
    set(handles.text_statusMsg, 'ForegroundColor', color);
    
end


drawnow

function edit_sessionDuration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sessionDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sessionDuration as text
%        str2double(get(hObject,'String')) returns contents of edit_sessionDuration as a double

sessionDuration = str2double(get(handles.edit_sessionDuration,'String'));
if(sessionDuration<=0)
    set(handles.edit_sessionDuration,'String',num2str(1));
end



% --- Executes during object creation, after setting all properties.
function edit_sessionDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sessionDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_snapshot.
function pushbutton_snapshot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% F = getframe(handles.output);
% Image = frame2im(F);
% imwrite(Image, 'daq_1_channel_data.png');


% GUI_fig_children=get(gcf,'children');
% Fig_Axes=findobj(GUI_fig_children,'type','Axes');
% fig=figure;ax=axes;clf;
% new_handle=copyobj(Fig_Axes,fig);
% set(gca,'ActivePositionProperty','outerposition')
% set(gca,'Units','normalized')
% set(gca,'OuterPosition',[0 0 1 1])
% set(gca,'position',[0.1300 0.1100 0.7750 0.8150])

%hgexport(handles.output,'-clipboard')
set(handles.output, 'PaperPositionMode', 'auto');
set(handles.output,'InvertHardcopy','off');

print -dmeta %-pdf

disp('Snapshot copied to clipboard...');



function edit_customId_Callback(hObject, eventdata, handles)
% hObject    handle to edit_customId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_customId as text
%        str2double(get(hObject,'String')) returns contents of edit_customId as a double

customId = get(handles.edit_customId,'String');
setappdata(handles.figure1,'settings_customId',customId);



% --- Executes during object creation, after setting all properties.
function edit_customId_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_customId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scrollPlotWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scrollPlotWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scrollPlotWidth as text
%        str2double(get(hObject,'String')) returns contents of edit_scrollPlotWidth as a double

scrollPlotWidth = str2double(get(handles.edit_scrollPlotWidth,'String'));

if(scrollPlotWidth<=0)
    set(handles.edit_sessionDuration,'String',num2str(1));
end


% --- Executes during object creation, after setting all properties.
function edit_scrollPlotWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scrollPlotWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_debug.
function pushbutton_debug_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Displaying status message
string = 'Debug called...!!!';
color = [0.607, 0.207, 0.050];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);
%disp('Debug called')
setappdata(handles.figure1,'flags_isBenchmarkRunning',true);
set(handles.togglebutton_action,'Value',1);
togglebutton_action_Callback(handles.togglebutton_action, eventdata,handles);

set(handles.edit_samplingFrequency,'String',num2str(20));
setappdata(handles.figure1,'flags_isBenchmarkRunning',true);
set(handles.togglebutton_action,'Value',1);
togglebutton_action_Callback(handles.togglebutton_action, eventdata,handles);


% hObj = get(findall(handles.figure1,'-property','FontUnits'),'FontUnits','normalized');
%
% callbackCell = get(hObject,'Callback');
%
% callbackCell{1}(hObject,[],callbackCell{2:end});

%callbackA = get(gcf, 'ButtonDownFcn');
%hgfeval(callbackA);



% --- Executes on selection change in listbox_serialPorts.
function listbox_serialPorts_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_serialPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_serialPorts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_serialPorts
listContents = cellstr(get(hObject,'String'));
portSelected = listContents{get(hObject,'Value')};

setappdata(handles.figure1,'settings_serialPort',portSelected);




% --- Executes during object creation, after setting all properties.
function listbox_serialPorts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_serialPorts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Displaying status message.
string = 'Establishing connection to Arduino. Wait....';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);
drawnow

Arduino(handles,'connect');



% --- Executes on button press in pushbutton_help.
function pushbutton_help_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Help
%
% filter = {'*.xlsx';'*.xls';'*.*'};
% [file, path] = uiputfile(filter,'test.xlsx');
%
% if isequal(file,0) || isequal(path,0)
%    disp('User clicked Cancel.')
% else
%    disp(['User selected ',fullfile(path,file),...
%          ' and then clicked Save.'])
% end




% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


evalin('base','clear');
clc

DefaultSettings(handles);
InitializeVariables(handles);
InitializeGui(eventdata,handles);
Arduino(handles,'initialize');

% Displaying status message
string = 'GUI reseted and Initialized...!!!';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);



function edit_debug_Callback(hObject, eventdata, handles)
% hObject    handle to edit_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_debug as text
%        str2double(get(hObject,'String')) returns contents of edit_debug as a double



% --- Executes during object creation, after setting all properties.
function edit_debug_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scalingFunction_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scalingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scalingFunction as text
%        str2double(get(hObject,'String')) returns contents of edit_scalingFunction as a double


% --- Executes during object creation, after setting all properties.
function edit_scalingFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scalingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_scalingFunction.
function checkbox_scalingFunction_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_scalingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_scalingFunction
value = get(hObject,'Value');
if (value)
    set(handles.edit_scalingFunction,'Enable','on');
    setappdata(handles.figure1,'flags_isDataScaling',true);
else
    set(handles.edit_scalingFunction,'Enable','off');
    setappdata(handles.figure1,'flags_isDataScaling',false);
    
end




function edit_yMaxValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yMaxValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yMaxValue as text
%        str2double(get(hObject,'String')) returns contents of edit_yMaxValue as a double


% --- Executes during object creation, after setting all properties.
function edit_yMaxValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yMaxValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_yMinValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yMinValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yMinValue as text
%        str2double(get(hObject,'String')) returns contents of edit_yMinValue as a double


% --- Executes during object creation, after setting all properties.
function edit_yMinValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yMinValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_yAxisReset.
function pushbutton_yAxisReset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yAxisReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit_yMinValue,'String',0);
set(handles.edit_yMaxValue,'String',1024);
setappdata(handles.figure1,'settings_yMinValue',0);
setappdata(handles.figure1,'settings_yMaxValue',1024);
set(handles.axes1,'ylim',[0 1024]);




% --- Executes on selection change in popupmenu_channel1.
function popupmenu_channel1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_channel1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel1

%contents = cellstr(get(hObject,'String'))
%contents{get(hObject,'Value')}

str = get(hObject, 'String');
val = get(hObject,'Value');


% Set current data to the selected data set.
switch val
    case 1
        setappdata(handles.figure1,'settings_channel1Type','Off');
        setappdata(handles.figure1,'settings_channel1Pin',[]);
        setappdata(handles.figure1,'flags_isChannel1Running',false);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
                   
    case 2
        setappdata(handles.figure1,'settings_channel1Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel1Pin','A0');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Enable','on');
    case 3
        setappdata(handles.figure1,'settings_channel1Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel1Pin','A1');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Enable','on');
    case 4
        setappdata(handles.figure1,'settings_channel1Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel1Pin','A2');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Enable','on');
    case 5
        setappdata(handles.figure1,'settings_channel1Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel1Pin','A3');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Enable','on');
    case 6
        setappdata(handles.figure1,'settings_channel1Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel1Pin','A4');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Enable','on');
    case 7
        setappdata(handles.figure1,'settings_channel1Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel1Pin','D2');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
    case 8
        setappdata(handles.figure1,'settings_channel1Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel1Pin','D3');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
    case 9
        setappdata(handles.figure1,'settings_channel1Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel1Pin','D4');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
    case 10
        setappdata(handles.figure1,'settings_channel1Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel1Pin','D5');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
    case 11
        setappdata(handles.figure1,'settings_channel1Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel1Pin','D6');
        setappdata(handles.figure1,'flags_isChannel1Running',true);
        set(handles.checkbox_scalingFunction,'Value',0);
        checkbox_scalingFunction_Callback(handles.checkbox_scalingFunction, eventdata, handles);
        set(handles.checkbox_scalingFunction,'Enable','off');
end


numberOfActiveChannels =  NumberOfActiveChannels(handles);
setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
if(isArduinoConnected && numberOfActiveChannels > 0)
    set(handles.togglebutton_action,'Enable','on');
else
    set(handles.togglebutton_action,'Enable','off');
end



% --- Executes during object creation, after setting all properties.
function popupmenu_channel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_channel2.
function popupmenu_channel2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_channel2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel2
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch val
    case 1
        setappdata(handles.figure1,'settings_channel2Type','Off');
        setappdata(handles.figure1,'settings_channel2Pin',[]);
        setappdata(handles.figure1,'flags_isChannel2Running',false);
    case 2
        setappdata(handles.figure1,'settings_channel2Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel2Pin','A0');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 3
        setappdata(handles.figure1,'settings_channel2Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel2Pin','A1');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 4
        setappdata(handles.figure1,'settings_channel2Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel2Pin','A2');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 5
        setappdata(handles.figure1,'settings_channel2Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel2Pin','A3');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 6
        setappdata(handles.figure1,'settings_channel2Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel2Pin','A4');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 7
        setappdata(handles.figure1,'settings_channel2Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel2Pin','D2');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 8
        setappdata(handles.figure1,'settings_channel2Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel2Pin','D3');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 9
        setappdata(handles.figure1,'settings_channel2Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel2Pin','D4');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 10
        setappdata(handles.figure1,'settings_channel2Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel2Pin','D5');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
    case 11
        setappdata(handles.figure1,'settings_channel2Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel2Pin','D6');
        setappdata(handles.figure1,'flags_isChannel2Running',true);
end

numberOfActiveChannels =  NumberOfActiveChannels(handles);
setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
if(isArduinoConnected && numberOfActiveChannels > 0)
    set(handles.togglebutton_action,'Enable','on');
else
    set(handles.togglebutton_action,'Enable','off');
end


% --- Executes during object creation, after setting all properties.
function popupmenu_channel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_channel3.
function popupmenu_channel3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_channel3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel3
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch val
    case 1
        setappdata(handles.figure1,'settings_channel3Type','Off');
        setappdata(handles.figure1,'settings_channel3Pin',[]);
        setappdata(handles.figure1,'flags_isChannel3Running',false);
    case 2
        setappdata(handles.figure1,'settings_channel3Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel3Pin','A0');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 3
        setappdata(handles.figure1,'settings_channel3Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel3Pin','A1');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 4
        setappdata(handles.figure1,'settings_channel3Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel3Pin','A2');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 5
        setappdata(handles.figure1,'settings_channel3Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel3Pin','A3');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 6
        setappdata(handles.figure1,'settings_channel3Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel3Pin','A4');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 7
        setappdata(handles.figure1,'settings_channel3Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel3Pin','D2');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 8
        setappdata(handles.figure1,'settings_channel3Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel3Pin','D3');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 9
        setappdata(handles.figure1,'settings_channel3Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel3Pin','D4');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 10
        setappdata(handles.figure1,'settings_channel3Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel3Pin','D5');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
    case 11
        setappdata(handles.figure1,'settings_channel3Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel3Pin','D6');
        setappdata(handles.figure1,'flags_isChannel3Running',true);
end

numberOfActiveChannels =  NumberOfActiveChannels(handles);
setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
if(isArduinoConnected && numberOfActiveChannels > 0)
    set(handles.togglebutton_action,'Enable','on');
else
    set(handles.togglebutton_action,'Enable','off');
end
% --- Executes during object creation, after setting all properties.
function popupmenu_channel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_channel4.
function popupmenu_channel4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_channel4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel4
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch val
    case 1
        setappdata(handles.figure1,'settings_channel4Type','Off');
        setappdata(handles.figure1,'settings_channel4Pin',[]);
        setappdata(handles.figure1,'flags_isChannel4Running',false);
    case 2
        setappdata(handles.figure1,'settings_channel4Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel4Pin','A0');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 3
        setappdata(handles.figure1,'settings_channel4Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel4Pin','A1');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 4
        setappdata(handles.figure1,'settings_channel4Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel4Pin','A2');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 5
        setappdata(handles.figure1,'settings_channel4Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel4Pin','A3');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 6
        setappdata(handles.figure1,'settings_channel4Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel4Pin','A4');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 7
        setappdata(handles.figure1,'settings_channel4Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel4Pin','D2');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 8
        setappdata(handles.figure1,'settings_channel4Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel4Pin','D3');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 9
        setappdata(handles.figure1,'settings_channel4Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel4Pin','D4');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 10
        setappdata(handles.figure1,'settings_channel4Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel4Pin','D5');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
    case 11
        setappdata(handles.figure1,'settings_channel4Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel4Pin','D6');
        setappdata(handles.figure1,'flags_isChannel4Running',true);
end

numberOfActiveChannels =  NumberOfActiveChannels(handles);
setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
if(isArduinoConnected && numberOfActiveChannels > 0)
    set(handles.togglebutton_action,'Enable','on');
else
    set(handles.togglebutton_action,'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_channel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_channel5.
function popupmenu_channel5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_channel5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_channel5
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch val
    case 1
        setappdata(handles.figure1,'settings_channel5Type','Off');
        setappdata(handles.figure1,'settings_channel5Pin',[]);
        setappdata(handles.figure1,'flags_isChannel5Running',false);
    case 2
        setappdata(handles.figure1,'settings_channel5Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel5Pin','A0');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 3
        setappdata(handles.figure1,'settings_channel5Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel5Pin','A1');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 4
        setappdata(handles.figure1,'settings_channel5Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel5Pin','A2');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 5
        setappdata(handles.figure1,'settings_channel5Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel5Pin','A3');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 6
        setappdata(handles.figure1,'settings_channel5Type','AnalogInput');
        setappdata(handles.figure1,'settings_channel5Pin','A4');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 7
        setappdata(handles.figure1,'settings_channel5Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel5Pin','D2');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 8
        setappdata(handles.figure1,'settings_channel5Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel5Pin','D3');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 9
        setappdata(handles.figure1,'settings_channel5Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel5Pin','D4');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 10
        setappdata(handles.figure1,'settings_channel5Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel5Pin','D5');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
    case 11
        setappdata(handles.figure1,'settings_channel5Type','DigitalInput');
        setappdata(handles.figure1,'settings_channel5Pin','D6');
        setappdata(handles.figure1,'flags_isChannel5Running',true);
end

numberOfActiveChannels =  NumberOfActiveChannels(handles);
setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
if(isArduinoConnected && numberOfActiveChannels > 0)
    set(handles.togglebutton_action,'Enable','on');
else
    set(handles.togglebutton_action,'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function popupmenu_channel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_channel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton_yAxisSet.
function pushbutton_yAxisSet_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_yAxisSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yMinValueOld = getappdata(handles.figure1,'settings_yMinValue');
yMaxValueOld = getappdata(handles.figure1,'settings_yMaxValue');

yMinValue = str2double(get(handles.edit_yMinValue,'String'));
yMaxValue = str2double(get(handles.edit_yMaxValue,'String'));

if(yMinValue < yMaxValue)
    setappdata(handles.figure1,'settings_yMinValue',yMinValue);
    setappdata(handles.figure1,'settings_yMaxValue',yMaxValue);
    set(handles.axes1,'ylim',[yMinValue yMaxValue]);
else
    string = 'Max Y must be greator than Min Y';
    color = [0.38 0 0.11];
    set(handles.text_statusMsg, 'String', string);
    set(handles.text_statusMsg, 'ForegroundColor', color);
    set(handles.edit_yMinValue,'String',num2str(yMinValueOld));
    set(handles.edit_yMaxValue,'String',num2str(yMaxValueOld));
    drawnow
end





% --- Executes on button press in checkbox_yAxisAutoScale.
function checkbox_yAxisAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_yAxisAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_yAxisAutoScale
value = get(hObject,'Value');
if (value)
 setappdata(handles.figure1,'flags_isYAxisAutoScale', true);   
 set(handles.edit_yMaxValue,'Enable','off');  
 set(handles.edit_yMinValue,'Enable','off');   
 set(handles.pushbutton_yAxisSet,'Enable','off');  
 set(handles.pushbutton_yAxisReset,'Enable','off');  
 
else
 setappdata(handles.figure1,'flags_isYAxisAutoScale', false);   
 set(handles.edit_yMaxValue,'Enable','on');  
 set(handles.edit_yMinValue,'Enable','on');  
 set(handles.pushbutton_yAxisSet,'Enable','on');  
 set(handles.pushbutton_yAxisReset,'Enable','on');   
end

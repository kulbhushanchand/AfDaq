function Arduino(handles,string)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


switch string
    case 'connect'
        try
            ard = arduino(getappdata(handles.figure1,'settings_serialPort'));
            setappdata(handles.figure1,'flags_isArduinoConnected',true);
            setappdata(handles.figure1,'settings_ard',ard);
            setappdata(handles.figure1,'settings_ardBoard',ard.Board);
            %set(handles.pushbutton_connect,'BackgroundColor',[0.94 0.94 0.94]);
            set(handles.pushbutton_connect, 'String', 'Connected');
            set(handles.pushbutton_connect,'Enable','off')
            
            numberOfActiveChannels =  NumberOfActiveChannels(handles);
            setappdata(handles.figure1,'settings_numberOfActiveChannels',numberOfActiveChannels);
            isArduinoConnected = getappdata(handles.figure1,'flags_isArduinoConnected');
            if(isArduinoConnected && numberOfActiveChannels > 0)
                set(handles.togglebutton_action,'Enable','on');
            else
                set(handles.togglebutton_action,'Enable','off');
            end
            
            % Displaying status message.
            string = 'Arduino Connected...';
            color = [0 0.38 0.11];
            set(handles.text_statusMsg, 'String', string);
            set(handles.text_statusMsg, 'ForegroundColor', color);
            
        catch ME
            switch ME.identifier
                case {'MATLAB:arduinoio:general:invalidAddressType', 'MATLAB:arduinoio:general:invalidAddressPCMac' , 'MATLAB:arduinoio:general:invalidPort'}
                    disp(ME.identifier)
                    disp('Select correct serial port');
                    % Displaying status message.
                    string = 'Select correct serial port';
                    color = [0 0.38 0.11];
                    set(handles.text_statusMsg, 'String', string);
                    set(handles.text_statusMsg, 'ForegroundColor', color);
                    drawnow
                    
                case 'MATLAB:arduinoio:general:connectionExists'
                    disp(ME.identifier)
                    disp('Connection to arduino already exists in MATLAB')
                    % Displaying status message.
                    string = 'Connection to arduino already exists in MATLAB';
                    color = [0 0.38 0.11];
                    set(handles.text_statusMsg, 'String', string);
                    set(handles.text_statusMsg, 'ForegroundColor', color);
                    drawnow
                    
                case 'MATLAB:arduinoio:general:openFailed'
                    disp(ME.identifier)
                    disp('Failed to open a connection at serial port')
                    % Displaying status message.
                    string = 'Failed to open a connection at serial port';
                    color = [0 0.38 0.11];
                    set(handles.text_statusMsg, 'String', string);
                    set(handles.text_statusMsg, 'ForegroundColor', color);
                    drawnow
                    
                    
                otherwise
                    disp(ME.identifier)
                    disp(ME)
                    disp('Unknown error !!!');
                    % Displaying status message.
                    string = 'Unknown error !!! Check command window for furthur details';
                    color = [0 0.38 0.11];
                    set(handles.text_statusMsg, 'String', string);
                    set(handles.text_statusMsg, 'ForegroundColor', color);
                    drawnow
            end
        end
        
    case 'initialize'
        % Arduino object (This will be filled when user presses connect button)
        setappdata(handles.figure1,'settings_ard',[]);
        
        % Serial Port on which arduino is connected (User selected)
        setappdata(handles.figure1,'settings_serialPort',[]);
        
        % Arduino Board Type
        setappdata(handles.figure1,'settings_ardBoard',[]);
        
        % Find serial port and populate the list
        serialPorts = instrhwinfo('serial');
        nPorts = length(serialPorts.SerialPorts);
        set(handles.listbox_serialPorts, 'String', [{'Select a port'} ; serialPorts.SerialPorts ]);
        set(handles.listbox_serialPorts, 'Value', 1);
end

end


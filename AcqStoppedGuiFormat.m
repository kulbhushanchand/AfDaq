function  AcqStoppedGuiFormat(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here




%% Setting panel properties.
set(findall(handles.uipanel_settings, '-property', 'Enable'), 'Enable', 'on');

value = get(handles.checkbox_scalingFunction,'Value');
if (value)
    set(handles.edit_scalingFunction,'Enable','on');
else
    set(handles.edit_scalingFunction,'Enable','off');
end



%% Setting button properties.

set(handles.togglebutton_action,'String','Start');
set(handles.togglebutton_action,'BackgroundColor',[0.94 0.94 0.94]);

 set(handles.pushbutton_reset,'Enable','on') 
 set(handles.pushbutton_snapshot,'Enable','on') 
 set(handles.pushbutton_log,'Enable','on') 

 

%% Initialize other properties.

set(handles.togglebutton_action,'Value',0);



%% Displaying status message.
string = 'Acquisition Finished';
color = [0 0.38 0.11];
set(handles.text_statusMsg, 'String', string);
set(handles.text_statusMsg, 'ForegroundColor', color);

drawnow

end


function numberOfActiveChannels = NumberOfActiveChannels(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


isChannel1Running = getappdata(handles.figure1,'flags_isChannel1Running');
isChannel2Running = getappdata(handles.figure1,'flags_isChannel2Running');
isChannel3Running = getappdata(handles.figure1,'flags_isChannel3Running');
isChannel4Running = getappdata(handles.figure1,'flags_isChannel4Running');
isChannel5Running = getappdata(handles.figure1,'flags_isChannel5Running');

numberOfActiveChannels =  0;

if(isChannel1Running)
    numberOfActiveChannels = numberOfActiveChannels + 1;
end
if(isChannel2Running)
    numberOfActiveChannels = numberOfActiveChannels + 1;
end
if(isChannel3Running)
    numberOfActiveChannels = numberOfActiveChannels + 1;
end
if(isChannel4Running)
    numberOfActiveChannels = numberOfActiveChannels + 1;
end
if(isChannel5Running)
    numberOfActiveChannels = numberOfActiveChannels + 1;
end

end


    

der = nan(1,numberOfSamples);
    derSmooth = nan(1,numberOfSamples);
    brSignal = zeros(1,numberOfSamples);
    brRate = zeros(1,numberOfSamples);
    brRateSmooth = zeros(1,numberOfSamples);
    hrRate = zeros(1,numberOfSamples);
    hrRateSmooth = zeros(1,numberOfSamples);
    hrRateEMA = zeros(1,numberOfSamples);
    hrIBI= zeros(1,numberOfSamples);
    hrv= zeros(1,numberOfSamples);
    
    brLag = 100;
    hrLag = 100;
    lag = 11;
    alpha = 0.1;
    
    filter = [2 2 4 6 10 20 10 6 4 2 2];
   % filter = [1 1 1 1 1 1 1 1 1 1 1];
  
    brSensorFlag = false;
    brSwitchFlag = false;
   
    hrSensorFlag = false;
    hrSwitchFlag = false;
    
    
    
    
    
    y = nan(1, numberOfSamples);
    signals = nan(1, numberOfSamples);
    smoothdata = nan(1, numberOfSamples);
    brThreshold = 0.2;
    plot_derSmooth = plot(handles.axes1,timeStampsMsec,derSmooth,'LineWidth',0.25,'Color',[0 0 1]);
    plot_brSignal = plot(handles.axes1,timeStampsMsec,brSignal,'LineWidth',0.25,'Color',[0 0 0]);
    plot_brRate = plot(handles.axes1,timeStampsMsec,brRate,'LineWidth',0.25,'Color',[0 1 0]);
    plot_brRateSmooth = plot(handles.axes1,timeStampsMsec,brRateSmooth,'LineWidth',0.25,'Color',[0 0 0]);
    plot_hrRate = plot(handles.axes1,timeStampsMsec,hrRate,'LineWidth',0.25,'Color',[1 0 0]);
    plot_hrRateSmooth = plot(handles.axes1,timeStampsMsec,hrRateSmooth,'LineWidth',0.25,'Color',[0 0 0]);
    plot_hrRateEMA = plot(handles.axes1,timeStampsMsec,hrRateEMA,'LineWidth',0.25,'Color',[0 0 0]);
    plot_hrIBI = plot(handles.axes1,timeStampsMsec,hrIBI,'LineWidth',0.25,'Color',[1 0 0]);
    plot_hrv = plot(handles.axes1,timeStampsMsec,hrv,'LineWidth',0.25,'Color',[0 0 1]);
    
    
    
      
        i = count;
        
        % BR algorithm
        if(i == 1)
            der(i)= 0;
            brTimeMarker = timeStampsMsec(i);
        else
            der(i) = (rawDataChannel1(i)-rawDataChannel1(i-1))./(timeStampsMsec(i)-timeStampsMsec(i-1));
        end
        
        if(i < lag)
            derSmooth(i) = 0;
        else
            derSmooth(i) =  (sum(der(i-lag+1:i).*filter)/lag);
        end
        
        if(derSmooth(i) > brThreshold)
            brSignal(i) = 1;
            brSensorFlag = true;
        end
        
        if(derSmooth(i) < -brThreshold)
            brSignal(i) = -1;
            brSensorFlag = false;
            brSwitchFlag = true;
        end
        
        if(brSensorFlag && brSwitchFlag)
            deltaTime = timeStampsMsec(i) - brTimeMarker;
            brTimeMarker = timeStampsMsec(i);
            brSwitchFlag = false;
            brRate(i) = 60000/deltaTime;
        else
            if(i > 1)
                brRate(i) = brRate(i-1);
            end
        end
        
      
        
        
        
        
        
        if(i < brLag)
            brRateSmooth(i) = 0;
        else
            brRateSmooth(i) =  sum(brRate(i-brLag+1:i))/brLag;
        end
            
        
        % HR algorithm
        
        if(i == 1)
           hrTimeMarker = timeStampsMsec(i);
        end
        
         if(rawDataChannel2(i) > 700)
           hrSensorFlag = true;
        end
        
        if(rawDataChannel2(i) < 300)
            hrSensorFlag = false;
            hrSwitchFlag = true;
        end
        
        if(hrSensorFlag && hrSwitchFlag)
            hrDeltaTime = timeStampsMsec(i) - hrTimeMarker;
            hrTimeMarker = timeStampsMsec(i);
            hrSwitchFlag = false;
            hrRate(i) = 60000/hrDeltaTime;
            hrIBI(i) = hrDeltaTime;
            hrv(i) = abs(hrIBI(i) - hrIBI(i-1));
            
        else
            if(i > 1)
                hrRate(i) = hrRate(i-1);
                hrIBI(i) = hrIBI(i-1);
                hrv(i) = hrv(i-1);
            end
        end
        
        
         if(i < hrLag)
            hrRateSmooth(i) = 0;
        else
            hrRateSmooth(i) =  sum(hrRate(i-hrLag+1:i))/hrLag;
        end
        
        if(hrRateSmooth(i) > 90)
           % beep 
        end
        
        
      % set(plot_derSmooth,'YData',(100.*derSmooth)+500,'XData',timeStampsMsec/1000);
      % set(plot_brSignal,'YData',(100.*brSignal)+500,'XData',timeStampsMsec/1000);
       % set(plot_brRate,'YData',10.*brRate,'XData',timeStampsMsec/1000);
        
      %  set(plot_brRateSmooth,'YData',10.*brRateSmooth,'XData',timeStampsMsec/1000);
                        
      %  set(plot_hrRate,'YData',10.*hrRate,'XData',timeStampsMsec/1000);
        
      %  set(plot_hrRateSmooth,'YData',10.*hrRateSmooth,'XData',timeStampsMsec/1000);
      %  set(plot_hrIBI,'YData',hrIBI,'XData',timeStampsMsec/1000);
      % set(plot_hrv,'YData',hrv,'XData',timeStampsMsec/1000);
        
      
      
      
                 
 % Breathing rate estimation starts from here
% if(count>30)
% y(count) = sum(rawDataChannel1(count-30:count))/31;
% else
% y(count) = 0;
% end

%y = smooth(y,11);
%smoothdata = y;
%y = y- mean(y);


% Settings
%lag = 0;
%threshold = 1;
%influence = 0.2;

% Get results
%[signals,avg,dev] = ThresholdingAlgo(y,lag,threshold,influence);


           
%  set(ph2,'YData',signals*rawDataSampleChannel1,'XData',timeStampsMsec/1000);    
     
%   set(ph3,'YData',y,'XData',timeStampsMsec/1000);



        if(isBenchmarkRunning && timeSampleSec >= 5)
            setappdata(handles.figure1,'flags_isBenchmarkRunning',false);
            set(handles.togglebutton_action,'Value',0);
            overruns
        end
        
        
        if(isBenchmarkRunning)
            b = (toc-a)*1000;
            
            if(b>=timeInterval)
                overruns = overruns + 1;
            end
            
        end
        
        
        
        
        
        
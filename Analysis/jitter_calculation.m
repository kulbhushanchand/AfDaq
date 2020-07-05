%%
clearvars
close all
clc

ard = arduino('COM4');

% Computing timing jitter for N samples of single instance of command

% Using pin A0 for analog read
% Using pin D2 for digital read
% Using pin D3 for digital write
% Using pin D5 for pwm voltage
configurePin(ard,'A0','AnalogInput');
configurePin(ard,'D2','DigitalInput');
configurePin(ard,'D2','pullup');
configurePin(ard,'D3','DigitalOutput');
configurePin(ard,'D5','PWM');

N = 100;
dataSample = NaN;
TJ_AR= NaN(1,N);
TJ_DR = NaN(1,N);
TJ_DW = NaN(1,N);
TJ_PS = NaN(1,N);

% Computing timing jitter for analog read
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   TJ_AR(i) = toc*1000;
end
T_AR = toc(tStart);

% Computing timing jitter for digital read
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readDigitalPin(ard,'D2');  
   TJ_DR(i) = toc*1000;
end
T_DR = toc(tStart);

% Computing timing jitter for digital write
tStart = tic;
for i =1:1:N
   tic;
   writeDigitalPin(ard,'D3',1);  
   TJ_DW(i) = toc*1000;
end
T_DW = toc(tStart);

% Computing timing jitter for PWM set
tStart = tic;
for i =1:1:N
   tic;
   writePWMVoltage(ard,'D5',2.5);  
   TJ_PS(i) = toc*1000;
end
T_PS = toc(tStart);

TJ_data = [TJ_AR; TJ_DR; TJ_DW; TJ_PS]';
T_cmd = round([T_AR T_DR T_DW T_PS]*1000);
Fs_cmd= round((N*1000)./T_cmd);
TJ_mean = mean(TJ_data);
TJ_median = median(TJ_data);
TJ_mode = mode(TJ_data);


T = table(TJ_mean', TJ_median', TJ_mode', T_cmd',Fs_cmd', 'VariableNames',{'Mean','Median','Mode','Time_Taken_ms','Max_Fs_Hz'})


plot(TJ_data)
set(gca,'xlim',[0 100],'ylim',[0 60]);
figure
boxplot(TJ_data)



%% Computing timing jitter for N samples of multiple instance of command

clearvars
close all
clc

ard = arduino('COM4');

% Using pin A0-A4 for analog read
configurePin(ard,'A0','AnalogInput');
configurePin(ard,'A1','AnalogInput');
configurePin(ard,'A2','AnalogInput');
configurePin(ard,'A3','AnalogInput');
configurePin(ard,'A4','AnalogInput');

N = 100;
dataSample = NaN;
TJ_AR_1 = NaN(1,N);
TJ_AR_2 = NaN(1,N);
TJ_AR_3 = NaN(1,N);
TJ_AR_4 = NaN(1,N);
TJ_AR_5 = NaN(1,N);

% Computing timing jitter for analog read - 1 channel
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   TJ_AR_1(i) = toc*1000;
end
T_AR_1 = toc(tStart);

% Computing timing jitter for analog read - 2 channels
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   dataSample = readVoltage(ard, 'A1') * (1023/5);  
   TJ_AR_2(i) = toc*1000;
end
T_AR_2 = toc(tStart);

% Computing timing jitter for analog read - 3 channels
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   dataSample = readVoltage(ard, 'A1') * (1023/5);  
   dataSample = readVoltage(ard, 'A2') * (1023/5); 
   TJ_AR_3(i) = toc*1000;
end
T_AR_3 = toc(tStart);

% Computing timing jitter for analog read - 4 channels
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   dataSample = readVoltage(ard, 'A1') * (1023/5);  
   dataSample = readVoltage(ard, 'A2') * (1023/5); 
   dataSample = readVoltage(ard, 'A3') * (1023/5); 
   TJ_AR_4(i) = toc*1000;
end
T_AR_4 = toc(tStart);

% Computing timing jitter for analog read - 5 channels
tStart = tic;
for i =1:1:N
   tic;
   dataSample = readVoltage(ard, 'A0') * (1023/5);  
   dataSample = readVoltage(ard, 'A1') * (1023/5);  
   dataSample = readVoltage(ard, 'A2') * (1023/5); 
   dataSample = readVoltage(ard, 'A3') * (1023/5); 
   dataSample = readVoltage(ard, 'A4') * (1023/5); 
   TJ_AR_5(i) = toc*1000;
end
T_AR_5 = toc(tStart);



TJ_data_M = [TJ_AR_1; TJ_AR_2; TJ_AR_3; TJ_AR_4; TJ_AR_5]';
T_cmd_M = round([T_AR_1 T_AR_2 T_AR_3 T_AR_4 T_AR_5]*1000);
Fs_cmd_M = round((N*1000)./T_cmd_M);
TJ_mean_M = mean(TJ_data_M);
TJ_median_M = median(TJ_data_M);
TJ_mode_M = mode(TJ_data_M);


T_M = table(TJ_mean_M', TJ_median_M', TJ_mode_M', T_cmd_M',Fs_cmd_M', 'VariableNames',{'Mean','Median','Mode','Time_Taken_ms','Max_Fs_Hz'})


plot(TJ_data_M)
set(gca,'ylim',[0 100]);
figure
boxplot(TJ_data_M)


%% Computing timing jitter for drawnow 
% Not used by me, instead the jitter in plotting performance is calculated
% in the AfDaq program

clearvars
close all
clc

ard = arduino('COM4');

% Using pin A0-A4 for analog read
configurePin(ard,'A0','AnalogInput');

N = 100;
dataSample = NaN;
TJ_plot = NaN(1,N);
count = 0;
figure()
set(gca,'xlim',[1 N],'ylim',[0 10]);
animatedlineHandle1 = animatedline(gca,'LineWidth',1.5,'Color',[0 0.4470 0.7410]);
animatedlineHandle2 = animatedline(gca,'LineWidth',1.5,'Color',[0 0.4470 0.7410]);
animatedlineHandle3 = animatedline(gca,'LineWidth',1.5,'Color',[0 0.4470 0.7410]);
animatedlineHandle4 = animatedline(gca,'LineWidth',1.5,'Color',[0 0.4470 0.7410]);
animatedlineHandle5 = animatedline(gca,'LineWidth',1.5,'Color',[0 0.4470 0.7410]);

drawnow
for i =1:1:N
    tic;
    count = count + 1;
    dataSample = readVoltage(ard, 'A0') * (1023/5);
    %dataSample = randi(1023);
    %addpoints(animatedlineHandle1, count, dataSample);
    % addpoints(animatedlineHandle2, count, dataSample*1.5);
    % addpoints(animatedlineHandle3, count, dataSample*2);
    % addpoints(animatedlineHandle4, count, dataSample*2.5);
    % addpoints(animatedlineHandle5, count, dataSample*3);
    tBen = tic; % benchmark
    drawnow 
    TJ_ben(count) = toc(tBen)*1000;
    addpoints(animatedlineHandle1, count, TJ_ben(count));
    
    
end

mean(TJ_ben)
median(TJ_ben)
mode(TJ_ben)
figure()
histogram(TJ_ben,count)
figure()
boxplot(TJ_ben)


%% Drawing performance calculations
% Used to estimate the maximum plotting performance of the system (MATLAB on given PC)

clearvars
close all
clc

h1 = animatedline;
h2 = animatedline;
h3 = animatedline;
h4 = animatedline;
h5 = animatedline;
axis([0,2*pi,-1,1])

x = linspace(0,2*pi,1000);
y1 = sin(x);
y2 = cos(x);
y3 = sin(x) + 0.5;
y4 = cos(x) + 0.5;
y5 = sin(x) - 0.5;

count = 0;
a = tic;
t_start = tic;

for k = 1:length(x)
    addpoints(h1,x(k),y1(k));
    addpoints(h2,x(k),y2(k));
    addpoints(h3,x(k),y3(k));
    addpoints(h4,x(k),y4(k));
    addpoints(h5,x(k),y5(k));
    b = toc(a); % check timer
    if b > (1/1000)
        drawnow % update screen every 1/30 seconds
        count = count + 1;
       a = tic; % reset timer after updating
    end
    
end
drawnow
count = count + 1;

count
t_final = toc(t_start)
fps = count/t_final



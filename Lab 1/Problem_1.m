clear; close all;
plotStyle()

pathToData = 'Time Domain Analysis Supporting Files';

% Getting the waveform
waveform = binfileload(pathToData,'ID',20,12);

% Creating the time array
fs = 96000;
dt = 1/fs;
t = 0:dt:(length(waveform) - 1)*dt;
t = t(:);

% Getting the running standard deviation
ns = fs/10;
[sigma,t_sigma] = runningstd(waveform,ns,fs);

figure()
plot(t,waveform)
hold on
plot(t_sigma,sigma,'LineWidth',2)
title('GEM-60 Static Fire Data')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
legend('Pressure Waveform','Pressure Standard Deviation','location','northwest')
grid on
xlim([20,t(end)])

savePlots('SavePath',pwd,'FileTypes',["png"])

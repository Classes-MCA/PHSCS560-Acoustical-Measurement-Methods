clear; close all;
plotStyle()

pathToData = 'Time Domain Analysis Supporting Files';

% Getting the waveform
waveform = binfileload(pathToData,'ID',20,12);

% Shortening the waveform
startTime = 35;
endTime = 40;
fs = 96000;
waveform = waveform(startTime*fs:endTime*fs);

[autocorrelation, t] = xcorr(waveform);
autocorrelation = autocorrelation ./ max(autocorrelation); % Normalzing
t = t(:); % Making into a column vector
dt = 1/fs;
t = t.*dt;

figure()
plot(t,autocorrelation,'LineWidth',2)
title('GEM-60 Static Fire Test Autocorrelation')
xlabel('Time (s)')
ylabel('Normalized Correlation Value (R_{xx})')
grid on
xlim([-50e-3, 50e-3])

figure()
plot(t,autocorrelation,'LineWidth',2)
yline(0.5,'r','LineWidth',2)
title('GEM-60 Static Fire Test Autocorrelation Zoomed View')
xlabel('Time (s)')
ylabel('Normalized Correlation Value (R_{xx})')
grid on
xlim([0, 50e-4])

%savePlots('SavePath',pwd,'FileTypes',["png"])

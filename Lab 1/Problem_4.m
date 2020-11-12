clear; close all;
plotStyle()

pathToData = 'Time Domain Analysis Supporting Files';

% Getting the waveforms
signalA = binfileload(pathToData,'ID',50,36);
signalB = binfileload(pathToData,'ID',50,37);

% Creating the time arrays
fs = 204800;
dt = 1/fs;
t = 0:dt:(length(signalA) - 1)*dt;

figure
plot(t,signalA,'LineWidth',2)
hold on
plot(t,signalB,'LineWidth',2)
title('Exploding Balloon Experiment Waveforms')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
xlim([2.85, 3])
grid on
legend('Channel 36 (7.62 m)','Channel 37 (22.9 m)')

%----- Channel 36 Autocorrelation
[autocorrelation, t] = xcorr(signalA);
autocorrelation = autocorrelation ./ max(autocorrelation); % Normalzing
t = t(:); % Making into a column vector
dt = 1/fs;
t = t.*dt;

figure()
plot(t,autocorrelation)
title('Channel 36 Autocorrelation')
xlabel('Time (s)')
ylabel('Normalized Correlation Value (R_{xx})')
xlim([-50e-3, 50e-3])
grid on


%----- Channel 37 Autocorrelation
[autocorrelation, t] = xcorr(signalB);
autocorrelation = autocorrelation ./ max(autocorrelation); % Normalzing
t = t(:); % Making into a column vector
dt = 1/fs;
t = t.*dt;

figure()
plot(t,autocorrelation)
title('Channel 37 Autocorrelation')
xlabel('Time (s)')
ylabel('Normalized Correlation Value (R_{xx})')
xlim([-50e-3, 50e-3])
grid on

%----- Channel 36-37 Cross Correlation
[crosscorrelation, t] = xcorr(signalA,signalB);
crosscorrelation = crosscorrelation ./ max(crosscorrelation); % Normalzing
t = t(:); % Making into a column vector
dt = 1/fs;
t = t.*dt;

figure()
plot(t,crosscorrelation)
title('Channel 36-37 Cross Correlation')
xlabel('Time (s)')
ylabel('Normalized Correlation Value (R_{xy})')
xlim([-100e-3, 50e-3])
grid on

%savePlots('SavePath',pwd,'FileTypes',["png"])

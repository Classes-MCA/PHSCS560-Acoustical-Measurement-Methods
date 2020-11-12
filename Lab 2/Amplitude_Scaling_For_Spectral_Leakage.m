clear; close all;
plotStyle()

fs = 51200;
dt = 1/fs;
ns = fs*2;
tone = 1000; % Hz
time = 100; % seconds

t = 0:dt:(time*fs - 1)*dt;

waveform = sin(2*pi*tone*t);

figure()
plot(t,waveform)
title('Original Waveform')
ylim([-2,2])
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

% Solving with a window
[Gxx,f,OASPL] = autospecMCA(waveform,fs,ns);
[Gxx_noWindow,f_noWindow,OASPL_noWindow] = autospecMCA(waveform,fs,ns,'Window',false);

ENBW_hann = mean(hann(ns))^2/mean(hann(ns).^2);

figure()
semilogx(f_noWindow,Gxx_noWindow,'LineWidth',10)
hold on
semilogx(f,Gxx./ENBW_hann,'LineWidth',5)
semilogx(f,Gxx,'LineWidth',2)
xlim([900,1100])
ylim([0,1.1])
title('Windowing Comparison')
xlabel('Frequency (Hz)')
ylabel('Amplitude (Pa^2/Hz)')
grid on
legend('Rectangular Window','Hann Window (Scaled)','Hann Window (Original)')

% Predicting tone amplitudes

% savePlots('SavePath',pwd,'FileTypes',["png"])
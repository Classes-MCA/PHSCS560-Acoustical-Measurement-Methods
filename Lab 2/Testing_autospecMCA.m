clear; close all;

clear; close all;
plotStyle()

pathToData = pwd;

% Getting the waveform
waveform = binfileload(pathToData,'ID',20,12);

% Shortening the waveform
startTime = 35;
endTime = 40;
fs = 96000;
waveform = waveform(startTime*fs:endTime*fs);

% Creating the time array
dt = 1/fs;
t = 0:dt:(length(waveform) - 1)*dt;
t = t(:);

%----- BROADBAND NOISE

% Calculating the autospectrum for various block sizes
ns = fs/2;
    
[Gxx,f,OASPL] = autospec(waveform,fs,ns);
[Gxx_MCA,f_MCA,OASPL_MCA] = autospecMCA(waveform,fs,ns);

figure()
semilogx(f,Gxx,'LineWidth',3)
hold on
semilogx(f_MCA,Gxx_MCA,'LineWidth',1)
title('Testing autospecMCA')
xlabel('Frequency (Hz)')
ylabel('Autospectral Density (Pa^2 / Hz)')
xlim([1e1,1e3])
legend('autospec Gee','autospec MCA')
grid on
hold on
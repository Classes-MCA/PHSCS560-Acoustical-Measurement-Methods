clear; close all;
plotStyle()

IDnum = 24;
CHnum = 0;
fs = 204.8e3;
ns = fs/2; % block size
numBins = 100; % for the pdf

% Getting and plotting the waveform
[waveform,t] = getTimeSeries('Data',IDnum,CHnum,fs,'PlotResult',true);
title('Quadcopter Waveform')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

% Getting and plotting the OASPL
[OASPL,rollingOASPL,t] = getOASPL(waveform,fs,'PlotResult',true);
title('Quadcopter OASPL')
xlabel('Time (s)')
ylabel('OASPL (dB re 20e-6 Pa)')
grid on

% Getting and plotting the autospectral density
[narrowbandSpectrum,frequencies,OASPL,Gxx] = getNarrowbandSpectrum(waveform,fs,'BlockSize',ns,'PlotResult',true);
title('Quadcopter Autospectral Density')
xlabel('Frequency (Hz)')
ylabel('Autospectral Density (dB re 20e-6 Pa)')
xlim([10,20e3])
grid on

% Calculating and plotting the probability density function
[values,bins] = pdfcalc(waveform,numBins);

figure()
plot(bins,values)
title('Quadcopter Probability Density')
xlabel('Pressure (Pa)')
ylabel('Probability')
grid on
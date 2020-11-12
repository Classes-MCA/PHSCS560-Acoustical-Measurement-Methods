clear; close all;
plotStyle()

%---------------------- Analyzing the Sine Wave --------------------------%
IDnums = [22,23,16,17];
CHnum  = 0;
fs = 204.8e3; % Hz
voltage = [0.05,0.25,0.50,1.00];
numBins = 100; % For the probability density function
blockSize = fs/2;
pref = 1e-10; % Volts

% Initializing variables
rmsVals_SineWave = zeros(length(IDnums),1);
OASPL_SineWave   = zeros(length(IDnums),1);
pdf_SineWave     = zeros(numBins,1);
bins_SineWave    = zeros(numBins,1);

for i = 1:length(IDnums)
    
    %----- Crunching the numbers
    
    % Extracting the waveform
    [waveform,t] = getTimeSeries('Data',IDnums(i),CHnum,fs);
    
    % Calculating the rms value
    rmsVals_SineWave(i) = rms(waveform);
    
    % Calculating the overall level
    [OASPL_SineWave(i),~] = getOASPL(waveform,fs,'ReferencePressure',pref); %reference is 1 volt
    
    % Calculating the probability density function
    [pdf_SineWave(:,i),bins_SineWave(:,i)] = pdfcalc(waveform,numBins);
    
    % Calculating the autospectral density
    [Gxx_SineWave(i,:),freq_SineWave(i,:),~] = autospec(waveform,fs,blockSize);
    spectrum_SineWave(i,:) = 20.*log10(Gxx_SineWave(i,:)./pref);
  
    %----- Creating the figures
    
    label = strcat("Voltage = ",num2str(voltage(i)));
    
    % Waveforms
    figure(1)
    subplot(2,2,i)
    plot(t,waveform)
    title(label)
    xlabel('Time (s)')
    ylabel('Voltage')
    xlim([5,5.1])
    ylim(1.2.*[-voltage(4),voltage(4)])
    grid on
    
    % Probability Density Functions
    figure(4)
    subplot(2,2,i)
    plot(bins_SineWave(:,i),pdf_SineWave(:,i))
    title(label)
    xlabel('Voltage')
    ylabel('Probability')
    grid on
    
    % Autospectral Densities
    figure(5)
    semilogx(freq_SineWave(i,:),spectrum_SineWave(i,:))
    hold on
    title('Sine Wave Autospectral Density')
    xlabel('Frequency (Hz)')
    ylabel(strcat("Autospectral Density (dB re ",num2str(pref)," Volts)"))
    xlim([20,20e3])
    grid on
    legendEntry(i) = label;
    legend(legendEntry)
    
end

%----- Creating figures for the rms and level values

% RMS
figure(2)
semilogx(voltage,rmsVals_SineWave,'Marker','*')
title('Sine Wave RMS Values')
xlabel('Voltage (V)')
ylabel('RMS Value (V)')
grid on

% Levels
figure(3)
semilogx(voltage,OASPL_SineWave,'Marker','*')
title('Sine Wave Level Values')
xlabel('Voltage (V)')
ylabel('Level (dB re 1 Volt)')
grid on

%---------------------- Analyzing the White Noise ------------------------%
clear;
IDnums = [18,19,20,21];
CHnum  = 0;
fs = 204.8e3; % Hz
std = [0.05,0.25,0.50,1.00];
numBins = 100; % For the probability density function
blockSize = fs/2;
pref = 1e-10; % Volts

% Initializing variables
rmsVals_WhiteNoise = zeros(length(IDnums),1);
OASPL_WhiteNoise   = zeros(length(IDnums),1);
pdf_WhiteNoise     = zeros(numBins,1);
bins_WhiteNoise    = zeros(numBins,1);

for i = 1:length(IDnums)
    
    %----- Crunching the numbers
    
    % Extracting the waveform
    [waveform,t] = getTimeSeries('Data',IDnums(i),CHnum,fs);
    
    % Calculating the rms value
    rmsVals_WhiteNoise(i) = rms(waveform);
    
    % Calculating the overall level
    [OASPL_WhiteNoise(i),~] = getOASPL(waveform,fs,'ReferencePressure',pref); %reference is 1 volt
    
    % Calculating the probability density function
    [pdf_WhiteNoise(:,i),bins_WhiteNoise(:,i)] = pdfcalc(waveform,numBins);
    
    % Calculating the autospectral density
    [Gxx_WhiteNoise(i,:),freq_WhiteNoise(i,:),~] = autospec(waveform,fs,blockSize);
    spectrum_WhiteNoise(i,:) = 20*log10(Gxx_WhiteNoise(i,:)./pref);
  
    %----- Creating the figures
    
    label = strcat("STD Voltage = ",num2str(std(i)));
    
    % Waveforms
    figure(6)
    subplot(2,2,i)
    plot(t,waveform)
    title(label)
    xlabel('Time (s)')
    ylabel('Voltage')
    xlim([5,5.005])
    ylim(1.2.*[-std(4),std(4)])
    grid on
    
    % Probability Density Functions
    figure(9)
    subplot(2,2,i)
    plot(bins_WhiteNoise(:,i),pdf_WhiteNoise(:,i))
    title(label)
    xlabel('Voltage')
    ylabel('Probability')
    grid on
    
    % Autospectral Densities
    figure(10)
    semilogx(freq_WhiteNoise(i,:),spectrum_WhiteNoise(i,:))
    hold on
    title('White Noise Autospectral Density')
    xlabel('Frequency (Hz)')
    ylabel(strcat("Autospectral Density (dB re ",num2str(pref)," Volts)"))
    xlim([20,20e3])
    grid on
    legendEntry(i) = label;
    legend(legendEntry)
    
end

%----- Creating figures for the rms and level values

% RMS
figure(7)
semilogx(std,rmsVals_WhiteNoise,'Marker','*')
title('White Noise RMS Values')
xlabel('Voltage (V)')
ylabel('RMS Value (V)')
grid on

% Levels
figure(8)
semilogx(std,OASPL_WhiteNoise,'Marker','*')
title('White Noise Level Values')
xlabel('Voltage (V)')
ylabel('Level (dB re 1 Volt)')
grid on
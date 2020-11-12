clear; close all;
plotStyle()

% Getting the high sampling frequency recording
IDnum = 1;
CHnum = 0;
fs = 204800;
[waveform_highfs,t] = getTimeSeries('Data',IDnum,CHnum,fs,'PlotResult',false);

waveform_highfs = waveform_highfs * 1000; % Converting to mV

figure(10)
plot(t,waveform_highfs)

% Getting the low sampling frequency recording
IDnum = 2;
CHnum = 0;
fs = 10000;
[waveform_lowfs,~] = getTimeSeries('Data',IDnum,CHnum,fs,'PlotResult',false);

waveform_lowfs = waveform_lowfs * 1000; % Converting to mV

% Calculate peak signal-to-noise ratio
maxVoltage = 10; % Volts
SNRpeak_highfs = 20 * log10(maxVoltage / rms(waveform_highfs))
SNRpeak_lowfs  = 20 * log10(maxVoltage / rms(waveform_lowfs))

% Create a PDF with different bin widths
totalBins = [25,50,200];
for i = 1:length(totalBins)
    
    % For the high sampling frequency
    [values,bins] = pdfcalc(waveform_highfs,totalBins(i));
    
    figure(1)
    plot(bins, values)
    hold on
    title('High Sampling Frequency')
    xlabel('Voltage (mV)')
    ylabel('Probability')
    grid on
    
    % For the low sampling frequency
    [values,bins] = pdfcalc(waveform_lowfs,totalBins(i));
    
    figure(2)
    plot(bins, values)
    hold on
    title('Low Sampling Frequency')
    xlabel('Voltage (mV)')
    ylabel('Probability')
    grid on
    
    % Adding to the legend
    legendEntry(i) = strcat(num2str(totalBins(i))," Bins");
    
end

% Adding the legend to the plots
figure(1)
legend(legendEntry)

figure(2)
legend(legendEntry)
    
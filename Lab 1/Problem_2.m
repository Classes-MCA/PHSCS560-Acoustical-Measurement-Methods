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

% Creating the time array
dt = 1/fs;
t = 0:dt:(length(waveform) - 1)*dt;
t = t(:);

%----- Calculating the crest factor'
pref = 20e-6;
peakLevel = 20 * log10(max(waveform)/pref);
rmsLevel = 20 * log10(rms(waveform)/pref);
crestFactor = peakLevel - rmsLevel;

%----- Calculating the probability density function (PDF)
numbins = 100;
[bins,vals] = pdfcalc(waveform,numbins);

% Verifying that the integral is equal to 1
binwidth = (max(bins) - min(bins)) / numbins;
total = sum(vals) * binwidth;

figure()
plot(bins,vals,'LineWidth',2)
title('Probability Density Function') % Between 35-40 seconds
xlabel('Pressure (Pa)')
ylabel('Probability Density')
xlim([-8000,8000])
grid on

%----- Checking for Gaussianity

% Using the mean and standard deviation
gem60mean = mean(waveform);
gem60std = std(waveform);
gaussianVals = normpdf(bins,gem60mean,gem60std);

figure()
plot(bins,vals,'LineWidth',2)
hold on
plot(bins,gaussianVals,'LineWidth',2)
title('Probability Density Function Comparison') % Between 35-40 seconds
xlabel('Pressure (Pa)')
ylabel('Probability Density')
xlim([-8000,8000])
grid on
legend('GEM-60 Motor Data','Gaussian Distribution')

% Comparing the Crest Factors
exampleWaveform = randn(length(waveform),1);
peakLevel = 20 * log10(max(exampleWaveform)/pref);
rmsLevel = 20 * log10(rms(exampleWaveform)/pref);
crestFactor = peakLevel - rmsLevel;

%savePlots('SavePath',pwd,'FileTypes',["png"])

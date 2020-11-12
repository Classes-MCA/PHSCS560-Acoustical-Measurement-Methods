clear; close all;
plotStyle()

% Gathering the data into an array
tubeArray = MicArray;
tubeArray.initializeArray(4)
CHnums = [0, 1, 2, 3];
fs = 51200;

%----- Sound Speed Measurement -----%
micLocations = [-11, -6, 6, 11] .* 0.050; % Converting to meters;
IDnum = 2;

% Gather in the data
for i = 1:length(tubeArray.Microphones)
    
    tubeArray.Microphones(i).Waveform = binfileload('Lab 9 Data','ID',IDnum,CHnums(i));
    tubeArray.Microphones(i).SamplingFrequency = 51200;
    tubeArray.Microphones(i).Location = [micLocations(i), 0, 0];
    
end

% Taking the cross-correlation between the first and last microphones in
% the array
crossCorrelation = xcorr(tubeArray.Microphones(1).Waveform,tubeArray.Microphones(4).Waveform);
crossCorrelation = crossCorrelation ./ max(crossCorrelation); % Normalizing to unity
dt = 1/fs;
tstart = -length(crossCorrelation)/2/fs;
tend = length(crossCorrelation)/2/fs;
t = tstart:dt:tend-dt;

figure()
plot(t,crossCorrelation)
title('Cross-Correlation Between Two Microphones')
xlabel('Time (s)')
ylabel('Normalized Magnitude')
xlim([-0.05,0.05])
ylim([-0.5,1.1])
grid on

% Calculating the sound speed
maxIndex = find(crossCorrelation == max(crossCorrelation));
delay = 0 - t(maxIndex);
distance = tubeArray.Microphones(4).Location(1) - tubeArray.Microphones(1).Location(1); % Just the x-components
velocity = distance / delay;
disp(strcat("Speed of Sound in Tube: ", num2str(velocity), " m/s."))

%----- Anechoic Assessment -----%
R = reflectionCoefficient(tubeArray.Microphones(1),tubeArray.Microphones(4))
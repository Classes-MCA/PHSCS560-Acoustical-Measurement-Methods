% ID001 - microphones spaced far apart, hole unplugged
% ID002 - microphones spaced far apart, hole plugged
% ID003 - microphones spaced far apart, plunger position 1
% ID004 - microphones spaced far apart, plunger position 1
% ID005 - microphones close together, hole plugged
% ID006 - microphones spaced far apart, plunger position 2
% ID007 - microphones spaced far apart, plunger position 3

clear; close all;
plotStyle()

% Gathering the data into an array
tubeArray = MicArray;
tubeArray.initializeArray(4)
CHnums = [0, 1, 2, 3];
fs = 51200;

%----- Sound Speed Measurement -----%
micLocations = [-7, -6, 6, 7] .* 0.050; % Converting to meters;
IDnum = 5;

% Gather in the data
for i = 1:length(tubeArray.Microphones)
    
    tubeArray.Microphones(i).Waveform = binfileload('Lab 9 Data','ID',IDnum,CHnums(i));
    tubeArray.Microphones(i).SamplingFrequency = 51200;
    tubeArray.Microphones(i).Location = [micLocations(i), 0, 0];
    tubeArray.Microphones(i).Name = strcat("Mic ",num2str(i));
    
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
soundSpeed = distance / delay;
uncertainty = (0.0127/2 / delay) * 2; % using half of the microphone diaphram
disp(strcat("Speed of Sound in Tube: ", num2str(soundSpeed)," +- ",num2str(uncertainty)," m/s."))

%----- Anechoic Assessment -----%
figure()
plotAbsorption(tubeArray.Microphones(1),tubeArray.Microphones(2),soundSpeed);
plotAbsorption(tubeArray.Microphones(1),tubeArray.Microphones(3),soundSpeed);
plotAbsorption(tubeArray.Microphones(1),tubeArray.Microphones(4),soundSpeed);
plotAbsorption(tubeArray.Microphones(2),tubeArray.Microphones(3),soundSpeed);
plotAbsorption(tubeArray.Microphones(2),tubeArray.Microphones(4),soundSpeed);
plotAbsorption(tubeArray.Microphones(3),tubeArray.Microphones(4),soundSpeed);
hold off

%----- Intensity -----%
figure()
intensity(tubeArray.Microphones(3),tubeArray.Microphones(4));
hold off

%----- Transmission Loss -----%
micLocations = [-11, -6, 6, 11] .* 0.050; % Converting to meters;

figure()
plotTL(tubeArray,micLocations,4,1,CHnums,soundSpeed)
plotTL(tubeArray,micLocations,6,2,CHnums,soundSpeed)
plotTL(tubeArray,micLocations,7,3,CHnums,soundSpeed)
hold off
set(gcf,'position',[0,0,12,16])

% Estimating the expected interference nulls
L_1 = 0.2975;
L_2 = 0.2050;
L_3 = 0.175;
a = 0.0509/2; % radius

f_1_17 = sideBranchNull(L_1,a,1.7,soundSpeed);
f_2_17 = sideBranchNull(L_2,a,1.7,soundSpeed);
f_3_17 = sideBranchNull(L_3,a,1.7,soundSpeed);

f_1_14 = sideBranchNull(L_1,a,1.4,soundSpeed);
f_2_14 = sideBranchNull(L_2,a,1.4,soundSpeed);
f_3_14 = sideBranchNull(L_3,a,1.4,soundSpeed);

f_1_x = sideBranchNull(L_1,a,0.6,soundSpeed);
f_2_x = sideBranchNull(L_2,a,0.6,soundSpeed);
f_3_x = sideBranchNull(L_3,a,0.6,soundSpeed);

f_1_0 = sideBranchNull(L_1,a,0.0,soundSpeed);
f_2_0 = sideBranchNull(L_2,a,0.0,soundSpeed);
f_3_0 = sideBranchNull(L_3,a,0.0,soundSpeed);

subplot(3,1,1)
xline(f_1_17,'b--','LineWidth',2,'DisplayName','Predicted: 1.7')
xline(f_1_14,'r--','LineWidth',2,'DisplayName','Predicted: 1.4')
xline(f_1_x,'k-','LineWidth',4,'DisplayName','Predicted: 0.6')
xline(f_1_0,'g--','LineWidth',2,'DisplayName','Predicted: 0.0')
legend('Show')

subplot(3,1,2)
xline(f_2_17,'b--','LineWidth',2,'DisplayName','Predicted: 1.7')
xline(f_2_14,'r--','LineWidth',2,'DisplayName','Predicted: 1.4')
xline(f_2_x,'k-','LineWidth',4,'DisplayName','Predicted: 0.6')
xline(f_2_0,'g--','LineWidth',2,'DisplayName','Predicted: 0.0')
legend('Show')

subplot(3,1,3)
xline(f_3_17,'b--','LineWidth',2,'DisplayName','Predicted: 1.7')
xline(f_3_14,'r--','LineWidth',2,'DisplayName','Predicted: 1.4')
xline(f_3_x,'k-','LineWidth',4,'DisplayName','Predicted: 0.6')
xline(f_3_0,'g--','LineWidth',2,'DisplayName','Predicted: 0.0')
legend('Show')

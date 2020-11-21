%clear; close all;
plotStyle()

% Defining some important information
DegreeStep = 10;
startAngle = 0;
endAngle = 350;
angles = startAngle:DegreeStep:endAngle;
numChannels = 6;
numMics = numChannels * length(angles);
fs = 51200;

% Defining the locations of each of the microphones in the X-Y plane.
% If you're standing at the door of the anechoic chamber, the x-axis points
% to the left, the y-axis points toward you (toward the door) and the
% z-axis points straight up toward the ceiling
microphoneLocations = [0 , 0, 46;
                       35, 0, 46;
                       80, 0, 33;
                       80, 0,  6;
                       80, 0,-26;
                       26, 0,-39]./100; % converting to meters
                   
% Defining the area represented by each microphone
area_ch0 = pi*0.175^2 / length(angles); % Area of a circle
area_ch1 = pi*(0.80^2 - 0.175^2) / length(angles); % Area of an annulus
area_ch2 = pi*1.60 * 0.265 / length(angles); % Area of a flat plate with the length equal to the circumference
area_ch3 = pi*1.60 * 0.295 / length(angles); % Same
area_ch4 = pi*1.60 * 0.290 / length(angles); % Same
area_ch5 = pi*0.80^2 / length(angles); % Area of a circle

% Testing the total area equals the area of a cylinder of diameter 160 cm
% and height 85 cm
perfectCylinder = pi*1.60*0.85 + 2*pi*0.80^2;
ourCylinder = (area_ch0 + area_ch1 + area_ch2 + area_ch3 + area_ch4 + ...
               area_ch5) * length(angles);
                   
%% ----- Importing the data -----%
micMesh = MicArray; % Creating an array object

% Going over each microphone
currentAngle = angles(1);
currentChannel = 0;
for i = 1:numMics
    
    % Add a microphone object to the array
    micMesh.Microphones(i) = Microphone;
    
    % Loading in acoustic data
    micMesh.Microphones(i).Waveform = binfileload('Lab 8 Anechoic Data',...
                                                  'ID',currentAngle/10 + 1,...
                                                  currentChannel);
    
    micMesh.Microphones(i).SamplingFrequency = fs;
                                              
    % Loading in name data
    micMesh.Microphones(i).Name = strcat("Angle: ",num2str(currentAngle),...
                                         ", Channel ",num2str(currentChannel));
                                              
    % Loading in position data
    position = microphoneLocations(currentChannel + 1,:);
    
    % Assuming the initial location is purely in the x-direction, we
    % can calculate the new x and y positions based on the angle we are
    % now at.
    micMesh.Microphones(i).Location = [position(1)*cosd(currentAngle),...
                                       position(1)*sind(currentAngle),...
                                       position(3)];
    
    % Preparing for next iteration
    currentChannel = currentChannel + 1;
    if currentChannel > 5
        currentChannel = 0;
        currentAngle = currentAngle + DegreeStep;
    end

end

%% ----- Generate Spectra -----%%
micMesh.generateSpectra('FrequencyRange',frequencyRange,'BlockSize',fs/2)

%% ----- Analysis -----%

frequencyRange = [200, 2000];
pref = 20e-6; % Pascals
rho = 1.225; % kg/m^3
c = 343; % m/s
area = [area_ch0, area_ch1, area_ch2, area_ch3, area_ch4, area_ch5];
frequencies = micMesh.Microphones(1).OTOFrequencies;
Iref = 10^-12;

% Going over each microphone
currentAngle = angles(1);
currentChannel = 0;
for i = 1:numMics
    
    disp(strcat("Angle: ",num2str(currentAngle)))
    
    for j = 1:length(frequencies)
        level = micMesh.Microphones(i).OTOSpectrum(j);
        p_squared = pref * exp(level / 10);
        intensity(i,j) = p_squared / (rho * c) * area(currentChannel + 1);
    end
    
    % Preparing for next iteration
    currentChannel = currentChannel + 1;
    if currentChannel > 5
        currentChannel = 0;
        currentAngle = currentAngle + DegreeStep;
    end

end

SoundPower_Anechoic = 10 .* log10(sum(intensity) / Iref); % Sums down columns

figure()
semilogx(frequencies,SoundPower_Anechoic,'r-o','LineWidth',2)
title('Intensity')
xlabel('Frequency (Hz)')
ylabel('Intensity (dB)')
grid on
xlim(frequencyRange)
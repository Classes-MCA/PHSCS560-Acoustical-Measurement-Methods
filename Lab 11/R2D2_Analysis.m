clear; close all;

usePackage GeneralSignalProcessing; plotStyle()
usePackage ArrayAnalysis
usePackage SourceModels

pathToData = '/Volumes/Mark Drive/Classes/Acoustical-Measurement-Methods/Lab 11/560 Lab 11 Data/R2D2Meas';

mics = MicArray;

% mics.Microphones(1) = Microphone; % FIXME: Why is it initialized with a dinosaur sound???

mics.initializeArray(61);

% Array Details
fs = 44.1e3;
range = 3.0; % How long the array is in meters
numMics = 61; % Number of microphones
targetFrequency = 1000; % Hz
angles = -90:1:90;
for i = 1:61
    
    disp(strcat("Reading Channel ",num2str(i)))
    
    filename = strcat(pathToData,filesep,"R2D2_Meas_M",num2str(i),".wav");
    
    mics.Microphones(i).Waveform = audioread(filename);
                                           
    mics.Microphones(i).SamplingFrequency = fs;
    
    mics.Microphones(i).Location = [-range/2 + (i-1)*range/(numMics-1), 0, 0];
    
    mics.Microphones(i).Location = -mics.Microphones(i).Location;
    
    mics.Microphones(i).Name = strcat("Channel ",num2str(i));
    
end

% Character Locations
characterLocations = [-80, 0;
                      -80,40;
                      -80,60;
                      -60,60;
                      -40,95;
                        0,80;
                       30,80;
                       60,95;
                       80,60;
                       75,10];
% scatter(characterLocations(:,1),characterLocations(:,2))
characterAngles = atan(characterLocations(:,1)./characterLocations(:,2)) * 180/pi;

% Getting the pattern
beamform(mics,angles,targetFrequency)
%%
% making the plot pretty
hold on
h = gcf;
h.Units = "Inches";
h.Position = [2,2,12,5];
ax = gca;
ax.Units = "Inches";
ax.Position = [1,0.5,7,4];
ax.Title.String = strcat("Cantina Directivity at ", num2str(targetFrequency), " Hz");
ax.Title.FontSize = 20;

for i = 1:length(characterAngles)
    
    theta = [characterAngles(i),characterAngles(i)];
    r = [-100,0];
    
    polarplot(theta*pi/180,r,'LineStyle','--','Color',[0.5,0.5,0.5])
    
end

hleg = legend({'Measured Directivity',['Map-based' newline 'Location Estimates']});
hleg.FontSize = 15;
hleg.Title.String = 'Legend';
hleg.Units = "Inches";
hleg.Position = [8.5,2,3,1.5];

%%
% Over-riding the angle calculations
characterAngles = [60, 44, -2, -21, -34, -49, -55, -83];

audioArray = MicArray;
audioArray.initializeArray(length(characterAngles));
%audioArray.Microphones(1) = Microphone; % FIXME: Why is it initialized with a dinosaur sound???
for i = 1:length(characterAngles)
    
    audioArray.Microphones(i).Waveform = getAudioAtAngle(mics,characterAngles(i));
    audioArray.Microphones(i).SamplingFrequency = fs;
    
end

% Results from using the trigonometry angles
% 1 - C3PO
% 2 - 
% 3 - Something about paying money when reaching orbit
% 4 - 
% 5 - "I don't like you!"
% 6 - Looking for Yoda
% 7 - "We don't serve their kind here"
% 8 - 
% 9 - "Han Solo"
% 10 - Just a bunch of music
% 
% Specific Angle Results
% -34: "Where is the Rebel Base?" <--- FOUND HIM!!!
soundsc(getAudioAtAngle(mics,34),fs)
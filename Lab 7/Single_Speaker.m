clear; close all;

% Add packages from 'packages.m'
packages

% Defining the default plot style
plotStyle()

% Defining array objects
farFieldArray = array;
nearFieldArray = array;

% Initializing the array objects with 18 microphones each
farFieldArray.initializeArray(18);
nearFieldArray.initializeArray(18);

% Information for loading all of the data
angles = -90:5:90;
IDnums = 1:1:37;
CH_nearField = 0;
CH_farField = 1;
pathToData = 'Our Data/One Speaker';
fs = 20000;
frequencyRange = [100, 8000];
r1 = 0.38; % meters from speaker to near-field mic
r2 = 1.55; % meters from speaker to far-field mic

% Loading the data
for i = 1:length(IDnums)
    
    % Getting the waveforms
    farFieldArray.Microphones(i).Waveform  = binfileload(pathToData,'ID',IDnums(i),CH_farField);
    nearFieldArray.Microphones(i).Waveform = binfileload(pathToData,'ID',IDnums(i),CH_nearField);
    
    % Inserting the sampling frequency
    farFieldArray.Microphones(i).SamplingFrequency  = fs;
    nearFieldArray.Microphones(i).SamplingFrequency = fs;
    
    % Specifying their locations
    farFieldArray.Microphones(i).Location  = [r2*cosd(angles(i)),r2*sind(angles(i)),0];
    nearFieldArray.Microphones(i).Location = [r1*cosd(angles(i)),r1*sind(angles(i)),0];
    
end

% Analyzing the coherence and transfer functions between the near and far fields
% -90 Degrees
gamma_90_90 = coherence(nearFieldArray.Microphones(1),farFieldArray.Microphones(1),'ShowPlot',true);
title('Single Speaker Coherence at -90 Degrees')
xlim([100,8000])
H_90_90 = transferFunction(nearFieldArray.Microphones(1),farFieldArray.Microphones(1),'ShowPlot',true);
title('Single Speaker Transfer Function at -90 Degrees')
xlim([100,8000])

% 0 Degrees
gamma_0_0 = coherence(nearFieldArray.Microphones(19),farFieldArray.Microphones(19),'ShowPlot',true);
title('Single Speaker Coherence at 0 Degrees')
xlim([100,8000])
H_0_0 = transferFunction(nearFieldArray.Microphones(19),farFieldArray.Microphones(19),'ShowPlot',true);
title('Single Speaker Transfer Function at 0 Degrees')
xlim([100,8000])

% Generating the autospectral densities and OTO spectra
disp('Autospectral Density Analysis')
analyzeSpectra(farFieldArray,frequencyRange,fs)
analyzeSpectra(nearFieldArray,frequencyRange,fs)

% Analyzing the directivity
disp('Directivity Analysis')
analyzeDirectivity_SingleSource(farFieldArray,angles,[100,1000,4000,8000]);
analyzeDirectivity_SingleSource(nearFieldArray,angles,[100,1000,4000,8000]);

save('farFieldArray_SingleSpeaker.mat','farFieldArray')
save('nearFieldArray_SingleSpeaker.mat','nearFieldArray')

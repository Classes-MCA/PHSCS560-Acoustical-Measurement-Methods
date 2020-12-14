usePackage GeneralSignalProcessing; plotStyle()
usePackage ArrayAnalysis
usePackage SourceModels

clear; close all; plotStyle()

pathToData = '/Volumes/Mark Drive/Classes/Acoustical-Measurement-Methods/Lab 11/560 Lab 11 Data';

mics = MicArray;

% Loading in the data
channels = 0:4;
fs = 51200;
range = 0.322; % How long the array is in meters
numMics = 5; % Number of microphone
angles = -90:1:90;
targetFrequency = 1000; % Hz
steerAngles = [-60,2,80];
IDnums = [2,1,3];
targetAngles = [-45,0,90];


h = figure();
for i = 1:length(IDnums)
    
    IDnum = IDnums(i);
    
    for j = 1:5
    
    mics.Microphones(j).Waveform = binfileload(pathToData,...
                                               'ID',...
                                               IDnum,...
                                               channels(j));
                                           
    mics.Microphones(j).SamplingFrequency = fs;
    
    mics.Microphones(j).Location = [-range/2 + (j-1)*range/(numMics-1), 0, 0];
    
    end
    
    subplot(2,2,i)
    beamform(mics,angles,targetFrequency)
    hold on
    
    H = linearArray(numMics,range/4,targetFrequency,angles,steerAngles(i));
    polarplot(angles*pi/180,20*log10(abs(H)),...
              'DisplayName',strcat("Calculated Directivity at ",num2str(steerAngles(i)),"\circ"),...
              'LineStyle','--',...
              'Color','k')
          
    ax = gca;
    ax.RLim = [-25,0];
    ax.Title.String = strcat(num2str(targetAngles(i)),"\circ");
    ax.Title.FontSize = 15;
          
          
    
end

%%

hleg = legend({"Measured",['Calculated for' newline 'Apparent Actual Angle']});
hleg.Title.String = 'Legend';
hleg.Units = "Inches";
hleg.Position = [5.8,0.7,3,1.5];
hleg.FontSize = 15;

h.Units = "Inches";
h.Position = [2,2,10,6];
hleg.FontSize = 15;

hstitle = sgtitle('Test Array Results');
hstitle.FontSize = 18;
hstitle.FontWeight = 'bold';
hstitle.FontName = 'Arial';
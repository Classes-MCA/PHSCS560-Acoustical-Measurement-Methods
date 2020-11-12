clear; close all; plotStyle();

packages

% Some important variables
numChannels = 6;
IDnum_SteadyState = 1;
IDnum_T60 = 2;
fs = 51200;
frequencyRange = [200, 2000];
turnoffTime = 10; % seconds

%----- Steady-state analaysis -----%

% Defining an array of microphones
setup_steadyState = array;
setup_steadyState.initializeArray(numChannels); % Initialized with 6 mics

%--- Loading the data
for i = 1:numChannels
    
    setup_steadyState.Microphones(i).Waveform = binfileload('Lab 8 Data','ID',...
                                                IDnum_SteadyState,i-1);
    
    setup_steadyState.Microphones(i).SamplingFrequency = fs;
    
    setup_steadyState.Microphones(i).Name = strcat("Channel ",num2str(i-1));
    
end

%--- Creating OTO spectra
setup_steadyState.generateSpectra('FrequencyRange',frequencyRange,'BlockSize',fs/2)
setup_steadyState.compareSpectra('SpectrumType','OTO','FrequencyRange',frequencyRange)

% Calculating the mean OTO spectrum
for i = 1:numChannels
        
    OTOvals(i,:) = setup_steadyState.Microphones(i).OTOSpectrum;
        
end
meanOTO = mean(OTOvals);


%----- Calculating the T-60 time -----%

% Defining an array of microphones
setup_T60 = array;
setup_T60.initializeArray(numChannels); % Initialized with 6 mics

%--- Loading the data
for i = 1:numChannels
    
    setup_T60.Microphones(i).Waveform = binfileload('Lab 8 Data','ID',...
                                                IDnum_T60,i-1);
    
    setup_T60.Microphones(i).SamplingFrequency = fs;
    
    setup_T60.Microphones(i).Name = strcat("Channel ",num2str(i-1));
    
end

figure(1)
setup_T60.compareWaveforms

%--- Iterating through each block and calculating the OTO spectral values
recordingLength = 20; % For the full recording, use '30'
blockTime = 1; % seconds
overlap = 0.95; % amount of overlap between blocks (0 = no overlap, 1 = full overlap)
numBlocks = recordingLength / (blockTime*(1-overlap)) - 1;

% Getting ready for the 60 dB down calculations
frequencies = setup_steadyState.Microphones(1).OTOFrequencies;
downTime = zeros(1,length(frequencies));

for i = 1:numBlocks
    
    % Load a new array with blocks for each channel
    setup_T60_blocks = array;
    
    % Getting the indices right
    lowerIndex = floor(fs*(i-1)*blockTime - fs*(i-1)*overlap*blockTime) + 1;
    upperIndex = floor(fs*(i)*blockTime - fs*(i-1)*overlap*blockTime) + 1;
    
    for j = 1:numChannels
        
        setup_T60_blocks.Microphones(j).Waveform = setup_T60.Microphones(j).Waveform(lowerIndex:upperIndex);
    
        setup_T60_blocks.Microphones(j).SamplingFrequency = fs;
    
        setup_T60_blocks.Microphones(j).Name = strcat("Channel ",num2str(j-1));
        
    end
    
    h = figure(2);
    setup_T60_blocks.generateSpectra('FrequencyRange',frequencyRange,'BlockSize',fs/10)
    setup_T60_blocks.compareSpectra('SpectrumType','OTO','FrequencyRange',frequencyRange)
    ylim([0,80])
    legend('Location','SouthEast')
    title(strcat("OTO Spectrum at T = ",num2str(mean([upperIndex-1,lowerIndex-1])/fs)," s"))
    
    % Calculating the mean OTO spectrum
    for j = 1:numChannels
        
        OTOvals(j,:) = setup_T60_blocks.Microphones(j).OTOSpectrum;
        
    end
    meanOTO_blocks = mean(OTOvals);
    hold on
    semilogx(setup_T60_blocks.Microphones(1).OTOFrequencies,meanOTO_blocks,'k--','LineWidth',3,'DisplayName','Average')
    legend()
    hold off
    drawnow
    
    % Write to the GIF File
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1
    imwrite(imind,cm,'cool.gif','gif', 'Loopcount',inf);
    else
    imwrite(imind,cm,'cool.gif','gif','WriteMode','append');
    end
    
    %--- See when the OTO bins reach -15dB relative to the steady state
    for j = 1:length(frequencies)
        
        difference = meanOTO(j) - meanOTO_blocks(j);
        
        % If the difference is 15 dB or greater AND a time has not yet been
        % specified
        if (difference >= 15) && (downTime(j) == 0)
            
            downTime(j) = mean([upperIndex-1,lowerIndex-1])/fs;
            
        end
        
    end
    
end

T60 = (downTime - turnoffTime) * 4; % https://www.prosoundtraining.com/2011/12/22/reverberation-time/

figure
semilogx(frequencies,T60,'k-o','LineWidth',2)
title('60dB-Down Time')
xlabel('Frequecy (Hz)')
ylabel('Time (s)')
xlim(frequencyRange)
grid on
function plotTL(tubeArray,micLocations,IDnum,plotNum,CHnums,soundSpeed)

% Gather in the data
for i = 1:length(tubeArray.Microphones)
    
    tubeArray.Microphones(i).Waveform = binfileload('Lab 9 Data','ID',IDnum,CHnums(i));
    tubeArray.Microphones(i).SamplingFrequency = 51200;
    tubeArray.Microphones(i).Location = [micLocations(i), 0, 0];
    tubeArray.Microphones(i).Name = strcat("Mic ",num2str(i));
    
end

subplot(3,1,plotNum)
transmissionLoss(tubeArray.Microphones(1),tubeArray.Microphones(3),soundSpeed)
transmissionLoss(tubeArray.Microphones(1),tubeArray.Microphones(4),soundSpeed)
transmissionLoss(tubeArray.Microphones(2),tubeArray.Microphones(3),soundSpeed)
transmissionLoss(tubeArray.Microphones(2),tubeArray.Microphones(4),soundSpeed)
hold off

end
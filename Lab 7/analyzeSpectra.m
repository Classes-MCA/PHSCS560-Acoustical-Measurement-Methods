function analyzeSpectra(micArray,frequencyRange,fs)

    micArray.generateSpectra('FrequencyRange',frequencyRange,'BlockSize',fs/2);
    
    figure()
    micArray.compareSpectra()
    xlim(frequencyRange)
    legend('off')

end
function transmissionLoss(mic1,mic2,soundSpeed)
    
    pu = autospec(mic1.Waveform,mic1.SamplingFrequency,'BlockSize',mic1.SamplingFrequency/1,'Output','Autospectral Density');
    pd = autospec(mic2.Waveform,mic2.SamplingFrequency,'BlockSize',mic2.SamplingFrequency/1,'Output','Autospectral Density');
    
    d = norm(mic1.Location - mic2.Location);
    
    [Ru,Rd,~,f] = reflectionCoefficient(mic1,mic2,5.00,soundSpeed);
    
    tau = (pu./pd).^2 .* abs(1+Ru).^2 ./ abs(1+Rd).^2; % CHECKME: the math (see Leishman notes)
    
    TL = 10.*log10(1./tau);
    
    semilogx(f,TL,'LineWidth',4,'DisplayName',strcat(mic1.Name," and ",mic2.Name,", d = ",num2str(d)," m"))
    hold on
    title('Transmission Loss')
    xlabel('Frequency (Hz)')
    ylabel('TL (dB)')
    grid on
    legend('Show','Location','SouthWest')
    xlim([50,1500])

end
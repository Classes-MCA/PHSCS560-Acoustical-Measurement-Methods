function I_PAGE = intensity(mic1,mic2)

    fs = mic1.SamplingFrequency;
    d = norm(mic1.Location - mic2.Location);
    Iref = 10^-12;
    rho = 1.225;

    [G11,f,~] = autospec(mic1.Waveform,fs,'BlockSize',fs/2);
    [G22,~,~] = autospec(mic2.Waveform,fs,'BlockSize',fs/2);
    [G12,~]   = crossspec(mic1.Waveform,mic2.Waveform,fs,fs/2);
    
    omega = 2*pi.*f;
    
    % Using the traditional Method
    I_traditional = imag(G12) ./ (2*d*omega*rho);
    I_traditional = 10.*log10(I_traditional./Iref);
    
    % Using the PAGE Method
    I_PAGE = - (sqrt(G11) + sqrt(G22)).^2 ./ (8*d*omega*rho) .* angle(G12);
    I_PAGE = 10.*log10(I_PAGE./Iref);
    
    semilogx(f,I_traditional,'LineWidth',2,'DisplayName','Traditional Method')
    hold on
    semilogx(f,I_PAGE,'LineWidth',2,'DisplayName','PAGE Method')
%     title(strcat("Intentsity Calculated Between ",string(mic1.Name)," and ",string(mic2.Name)," (d is ",num2str(d)," m)"))
    title(strcat("Intentsity Calculated Between ",string(mic1.Name)," and ",string(mic2.Name)))
    xlabel('Frequency (Hz)')
    ylabel('Intensity')
    grid on
    xlim([50,1500])
    legend('Show')

end
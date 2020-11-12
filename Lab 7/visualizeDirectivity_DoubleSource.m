function visualizeDirectivity_DoubleSource(micArray,angles,frequency)
    
    k = 2*pi*frequency ./ micArray.SpeedOfSound;
    a = 0.05; % meters (about 2 inches)
    d = 0.18;
    rlimits = [-40,5];
    N = 2;
    
    for j = 1:length(angles)

        SPLs(j) = interp1(micArray.Microphones(j).NarrowbandFrequencies,...
                          micArray.Microphones(j).NarrowbandSpectrum,...
                          frequency);

        H_ideal(j) = 1/N * abs(sin((N/2 * k * d * sind(angles(j)))) / cos((1/2 * k * d * sind(angles(j)))));

    end
    
    SPLs = SPLs - max(SPLs);
    
    
    polarplot(angles.*pi/180,SPLs)
    hold on
    polarplot(angles.*pi/180,20*log10(H_ideal))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequency)," Hz"))
    hold off

end
function visualizeDirectivity_SingleSource(micArray,angles,frequency)
    
    k = 2*pi*frequency ./ micArray.SpeedOfSound;
    a = 0.05; % meters (about 2 inches)
    rlimits = [-40,5];
    
    for j = 1:length(angles)

        SPLs(j) = interp1(micArray.Microphones(j).NarrowbandFrequencies,...
                          micArray.Microphones(j).NarrowbandSpectrum,...
                          frequency);

        H_ideal(j) = abs(besselj(1,k*a*sind(angles(j))) / sin((0.5 * k * a * sind(angles(j))))); % FIXME: check the math

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
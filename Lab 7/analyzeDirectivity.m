function analyzeDirectivity_SingleSource(micArray,angles,frequencies)
    
    k = 2*pi*frequencies ./ micArray.SpeedOfSound;
    a = 0.05; % meters (about 2 inches)
    rlimits = [-40,0];
    
    for i = 1:length(frequencies)
        for j = 1:length(angles)

            SPLs(i,j) = interp1(micArray.Microphones(j).NarrowbandFrequencies,...
                              micArray.Microphones(j).NarrowbandSpectrum,...
                              frequencies(i));

            H_ideal(i,j) = abs(besselj(1,k(i)*a*sind(angles(j))) / (0.5 * k(i) * a * sind(angles(j)))); % FIXME: check the math

        end
    end
    
    for i = 1:length(frequencies)
        SPLs(i,:) = SPLs(i,:) - max(SPLs(i,:));
    end
    
    figure()
    subplot(2,2,1)
    polarplot(angles.*pi/180,SPLs(1,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_ideal(1,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(1))," Hz"))
    
    subplot(2,2,2)
    polarplot(angles.*pi/180,SPLs(2,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_ideal(2,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(2))," Hz"))
    
    subplot(2,2,3)
    polarplot(angles.*pi/180,SPLs(3,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_ideal(3,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(3))," Hz"))
    
    subplot(2,2,4)
    polarplot(angles.*pi/180,SPLs(4,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_ideal(4,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(4))," Hz"))

end
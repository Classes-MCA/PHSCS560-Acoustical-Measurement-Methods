function analyzeDirectivity_DoubleSource(micArray,angles,frequencies,location)
    
    k = 2*pi*frequencies ./ micArray.SpeedOfSound;
    a = 0.025; % meters (about 2 inches)
    d = 0.18; % meters (about 7 inches center to center)
    rlimits = [-40,0];
    N = 2;
    
    % Loading in the single speaker data
    if location == "Near"
        SingleSpeaker = load('nearFieldArray_SingleSpeaker.mat');
        SingleSpeaker = SingleSpeaker.nearFieldArray;
    elseif location == "Far"
        SingleSpeaker = load('farFieldArray_SingleSpeaker.mat');
        SingleSpeaker = SingleSpeaker.farFieldArray;
    end
    
    for i = 1:length(frequencies)
        for j = 1:length(angles)
            
            % Actual SPL values from the double speaker setup
            SPLs(i,j) = interp1(micArray.Microphones(j).NarrowbandFrequencies,...
                              micArray.Microphones(j).NarrowbandSpectrum,...
                              frequencies(i));
            
            % Ideal dipole
            H_dipole(i,j) = dipole(d,frequencies(i),angles(j)); % FIXME: check the math
            
            % Ideal baffled circular piston
            H_bcp(i,j) = baffledCircularPiston(a,frequencies(i),angles(j));
            
            % Actual SPL values from the single speaker setup
            SPLs_SingleSpeaker(i,j) = interp1(SingleSpeaker.Microphones(j).NarrowbandFrequencies,...
                                              SingleSpeaker.Microphones(j).NarrowbandSpectrum,...
                                              frequencies(i));
            
        end
    end
    
    for i = 1:length(frequencies)
        SPLs(i,:) = SPLs(i,:) - max(SPLs(i,:));
        SPLs_SingleSpeaker(i,:) = SPLs_SingleSpeaker(i,:) - max(SPLs_SingleSpeaker(i,:));
    end
    
    figure()
    subplot(2,2,1)
    polarplot(angles.*pi/180,SPLs(1,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_dipole(1,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(1))," Hz"))
    
    subplot(2,2,2)
    polarplot(angles.*pi/180,SPLs(2,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_dipole(2,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(2))," Hz"))
    
    subplot(2,2,3)
    polarplot(angles.*pi/180,SPLs(3,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_dipole(3,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(3))," Hz"))
    
    subplot(2,2,4)
    polarplot(angles.*pi/180,SPLs(4,:))
    hold on
    polarplot(angles.*pi/180,20*log10(H_dipole(4,:)))
    rlim(rlimits)
    set(gca,'ThetaZeroLocation','top')
    thetalim([-90 90])
    rticks(-40:10:0)
    title(strcat(num2str(frequencies(4))," Hz"))
    
    
    % Including the product rule with the ideal baffled circular piston
    subplot(2,2,1)
    polarplot(angles.*pi/180,20*log10(H_dipole(1,:).*H_bcp(1,:)))
    
    subplot(2,2,2)
    polarplot(angles.*pi/180,20*log10(H_dipole(2,:).*H_bcp(2,:)))
    
    subplot(2,2,3)
    polarplot(angles.*pi/180,20*log10(H_dipole(3,:).*H_bcp(3,:)))
    
    subplot(2,2,4)
    polarplot(angles.*pi/180,20*log10(H_dipole(4,:).*H_bcp(4,:)))
    
    % Including the product rule with the calculated single speaker
    % directivity
    subplot(2,2,1)
    polarplot(angles.*pi/180,20*log10(H_dipole(1,:))+SPLs_SingleSpeaker(1,:))
    
    subplot(2,2,2)
    polarplot(angles.*pi/180,20*log10(H_dipole(2,:))+SPLs_SingleSpeaker(2,:))
    
    subplot(2,2,3)
    polarplot(angles.*pi/180,20*log10(H_dipole(3,:))+SPLs_SingleSpeaker(3,:))
    
    subplot(2,2,4)
    polarplot(angles.*pi/180,20*log10(H_dipole(4,:))+SPLs_SingleSpeaker(4,:))

end
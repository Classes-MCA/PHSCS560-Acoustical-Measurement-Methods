clear; close all;
plotStyle()

% No Wind Screen
[coherence_none,~] = compareAandB(1,0,1,1,'No Wind Screen');

% Windscreen #1
[coherence_black,f] = compareAandB(2,0,2,1,'Standard Black Screen');

% Windscreen #2
[coherence_blue,~] = compareAandB(3,0,3,1,'Small Blue Screen');

% Windscreen #3
[coherence_red,~] = compareAandB(4,0,4,1,'Medium Red Screen');

% Windscreen #4
[coherence_yellow,~] = compareAandB(5,0,5,1,'Large Yellow Screen');

figure()
semilogx(f,coherence_none,'g','LineWidth',2)
hold on
semilogx(f,coherence_black,'k','Linewidth',2)
semilogx(f,coherence_blue,'b','Linewidth',2)
semilogx(f,coherence_red,'r','Linewidth',2)
semilogx(f,coherence_yellow,'y','Linewidth',2)
title('Wind Screen Coherence')
xlabel('Frequency (Hz)')
ylabel('\gamma^2')
xlim([200,50e3])
ylim([0.92,1.02])
legend('Non Wind Screen','Standard Black','Small Blue','Medium Red','Large Yellow','Location','SouthWest')
grid on

function [gamma_squared,f] = compareAandB(IDnum_micA_with_screen,CHnum_micA_with_screen,...
                      IDnum_micB,CHnum_micB,...
                      screenType)
    %----- Important variables
    fs = 102400;
    path = 'Data';
    ns = fs/10;

    %----- Load waveforms

    % mic A With Windscreen
    IDnum = IDnum_micA_with_screen;
    CHnum = CHnum_micA_with_screen;

    [micA_with_screen,~] = getTimeSeries(path,IDnum,CHnum,fs);

    % mic B
    IDnum = IDnum_micB;
    CHnum = CHnum_micB;

    [micB,~] = getTimeSeries(path,IDnum,CHnum,fs);

    %----- Calculate autospectra
    
    % mic A With Windscreen
    [Gaa,~,~] = autospec(micA_with_screen,fs,ns);
    
    % mic B (No Windscreen)
    [Gbb,~,~] = autospec(micB,fs,ns);
    
    %----- Calculate Cross Spectrum
    [Gab,f] = crossspec(micA_with_screen,micB,fs,ns);
    
    %----- Calculate Coherence
    mag_squared = real(Gab).^2 + imag(Gab).^2;
    gamma_squared = mag_squared ./ (Gaa.*Gbb);
    
%     figure()
%     semilogx(f,gamma_squared)
%     title(strcat(screenType," Coherence"))
%     xlabel('Frequency (Hz)')
%     ylabel('Transfer Function')
%     xlim(xlimits)
%     legend('Coherence')
    

end

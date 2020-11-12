clear; close all;
plotStyle()

% No Windscreen
[H_none,~] = compareAandB(1,0,1,1,'No Wind Screen');

% Windscreen #1
[H_black,f] = compareAandB(2,0,2,1,'Standard Black Screen');

% Windscreen #2
[H_blue,~] = compareAandB(3,0,3,1,'Small Blue Screen');

% Windscreen #3
[H_red,~] = compareAandB(4,0,4,1,'Medium Red Screen');

% Windscreen #4
[H_yellow,~] = compareAandB(5,0,5,1,'Large Yellow Screen');

figure()
semilogx(f,20.*log10(abs(H_yellow)),'yellow','Linewidth',2)
hold on
semilogx(f,20.*log10(abs(H_red)),'r','Linewidth',2)
semilogx(f,20.*log10(abs(H_blue)),'b','Linewidth',2)
semilogx(f,20.*log10(abs(H_black)),'k','Linewidth',2)
semilogx(f,20.*log10(abs(H_none)),'g','Linewidth',2)
title('Transfer Function Amplitude')
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
grid on
xlim([200,50e3])
legend('Large Yellow','Medium Red','Small Blue','Standard Black','No Wind Screen','Location','NorthWest')

figure()
semilogx(f,angle(H_yellow),'yellow','Linewidth',2)
hold on
semilogx(f,angle(H_red),'r','Linewidth',2)
semilogx(f,angle(H_blue),'b','Linewidth',2)
semilogx(f,angle(H_black),'k','Linewidth',2)
semilogx(f,angle(H_none),'g','Linewidth',2)
title('Transfer Function Phase')
xlabel('Frequency (Hz)')
ylabel('Phase Difference (radians)')
grid on
xlim([200,50e3])
ylim([-1.1*pi,1.1*pi])
legend('Large Yellow','Medium Red','Small Blue','Standard Black','No Wind Screen','Location','NorthWest')

function [Hab,f] = compareAandB(IDnum_micA_with_screen,CHnum_micA_with_screen,...
                      IDnum_micB,CHnum_micB,...
                      screenType)
    %----- Important variables
    fs = 102400;
    path = 'Data';
    ns = fs/10;
    xlimits = [200,50e3];

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
    
    %----- Calculate transfer function
    Hab = Gab./Gaa;
    
    figure()
    semilogx(f,abs(Hab))
    hold on
    semilogx(f,angle(Hab))
    title(strcat(screenType," Transfer Function"))
    xlabel('Frequency (Hz)')
    ylabel('Transfer Function')
    xlim(xlimits)
    legend('Amplitude','Phase')
    

end

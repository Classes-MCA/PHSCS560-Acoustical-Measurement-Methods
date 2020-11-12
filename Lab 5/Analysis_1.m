clear; close all;
plotStyle()

% Windscreen #1
[spectrum_none, ~, ~, ~] = compareAandB(1,0,1,0,2,1,'No Wind Screen');

% Windscreen #1
[spectrum_black, loss_black, spectrum_B_black, f] = compareAandB(1,0,2,0,2,1,'Standard Black Screen');

% Windscreen #2
[spectrum_blue, loss_blue, spectrum_B_blue, ~] = compareAandB(1,0,3,0,3,1,'Small Blue Screen');

% Windscreen #3
[spectrum_red, loss_red, spectrum_B_red, ~] = compareAandB(1,0,4,0,4,1,'Medium Red Screen');

% Windscreen #4
[spectrum_yellow, loss_yellow, spectrum_B_yellow, ~] = compareAandB(1,0,5,0,5,1,'Large Yellow Screen');

figure()
semilogx(f,spectrum_none,'g','LineWidth',2)
hold on
semilogx(f,spectrum_black,'k','Linewidth',2)
semilogx(f,spectrum_blue,'b','Linewidth',2)
semilogx(f,spectrum_red,'r','Linewidth',2)
semilogx(f,spectrum_yellow,'y','Linewidth',2)
title('Wind Screen Autospectral Density')
xlabel('Frequency (Hz)')
ylabel('Autospectral Density (dB)')
xlim([200,50e3])
grid on
legend('No Wind Screen','Standard Black','Small Blue','Medium Red','Large Yellow','Location','SouthWest')

figure()
semilogx(f,loss_black,'k','Linewidth',2)
hold on
semilogx(f,loss_blue,'b','Linewidth',2)
semilogx(f,loss_red,'r','Linewidth',2)
semilogx(f,loss_yellow,'y','Linewidth',2)
title('Wind Screen Insertion Loss')
xlabel('Frequency (Hz)')
ylabel('Insertion Loss (dB)')
xlim([200,50e3])
grid on
legend('Standard Black','Small Blue','Medium Red','Large Yellow','Location','NorthWest')

figure()
semilogx(f,spectrum_B_black,'k','Linewidth',2)
hold on
semilogx(f,spectrum_B_blue,'b','Linewidth',2)
semilogx(f,spectrum_B_red,'r','Linewidth',2)
semilogx(f,spectrum_B_yellow,'y','Linewidth',2)
title('Microphone B Consistency Test')
xlabel('Frequency (Hz)')
ylabel('Autospectral Density')
xlim([200,50e3])
grid on
legend('Standard Black','Small Blue','Medium Red','Large Yellow','Location','SouthWest')

function [Gxx_A_with_screen_dB, insertionLoss, Gxx_B_dB, f] = ...
                      compareAandB(IDnum_micA_no_screen,CHnum_micA_no_screen,...
                      IDnum_micA_with_screen,CHnum_micA_with_screen,...
                      IDnum_micB,CHnum_micB,...
                      screenType)
    %----- Important variables
    fs = 102400; % FIXME: wrong value for actual data
    path = 'Data';
    ns = fs/2;
    xlimits = [200,50e3];

    %----- Load waveforms
    % mic A No Windscreen
    IDnum = IDnum_micA_no_screen;
    CHnum = CHnum_micA_no_screen;

    [micA_no_screen,~] = getTimeSeries(path,IDnum,CHnum,fs);

    % mic A With Windscreen
    IDnum = IDnum_micA_with_screen;
    CHnum = CHnum_micA_with_screen;

    [micA_with_screen,~] = getTimeSeries(path,IDnum,CHnum,fs);

    % mic B
    IDnum = IDnum_micB;
    CHnum = CHnum_micB;

    [micB,~] = getTimeSeries(path,IDnum,CHnum,fs);

    %----- Calculate autospectra

    % mic A No Windscreen
    [Gxx_A_no_screen,~,~] = autospec(micA_no_screen,fs,ns);
    Gxx_A_no_screen_dB = convertToDB(Gxx_A_no_screen,'Squared',true);

    % mic A With Windscreen
    [Gxx_A_with_screen,~,~] = autospec(micA_with_screen,fs,ns);
    Gxx_A_with_screen_dB = convertToDB(Gxx_A_with_screen,'Squared',true);

    % mic B
    [Gxx_B,f,~] = autospec(micB,fs,ns);
    Gxx_B_dB = convertToDB(Gxx_B,'Squared',true);

    % Plotting
    figure()
    semilogx(f,Gxx_A_no_screen_dB)
    hold on
    semilogx(f,Gxx_A_with_screen_dB)
    semilogx(f,Gxx_B_dB)
    title(strcat(screenType," Comparison"))
    xlabel('Frequency (Hz)')
    ylabel('Autospectral Density (dB re 20\muPa)')
    grid on
    legend('Mic A No Screen','Mic A With Screen','Mic B (No Screen)')
    xlim(xlimits)

    %----- Calculate insertion loss
    insertionLoss = Gxx_A_no_screen_dB - Gxx_A_with_screen_dB;

    % Plotting
    figure()
    semilogx(f,insertionLoss)
    title(strcat(screenType," Insertion Loss"))
    xlabel('Frequency')
    ylabel('Insertion Loss (dB)')
    grid on
    xlim(xlimits)

end
clear; close all;

%----- IMPLUSE RESPONSE -----%

% No Wind Screen
[IR_none,~] = getImpulseResponse(1,0,1,1,'No Wind Screen');

% Windscreen #1
[IR_black,t] = getImpulseResponse(2,0,2,1,'Standard Black Screen');

% Windscreen #2
[IR_blue,~] = getImpulseResponse(3,0,3,1,'Small Blue Screen');

% Windscreen #3
[IR_red,~] = getImpulseResponse(4,0,4,1,'Medium Red Screen');

% Windscreen #4
[IR_yellow,~] = getImpulseResponse(5,0,5,1,'Large Yellow Screen');

% Plotting the impulse responses
figure()
plot(t,IR_yellow,'y')
hold on
plot(t,IR_red,'r')
plot(t,IR_blue,'b')
plot(t,IR_black,'k')
plot(t,IR_none,'g')
grid on
title('Wind Screen Impulse Response')
legend('Large Yellow','Medium Red','Small Blue','Standard Black','No Wind Screen','Location','NorthEast')
xlabel('Time (s)')
ylabel('Amplitude')

fs = 102400;
figure()
subplot(2,2,1)
plot(t,IR_black,'k')
title('Standard Black')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(2,2,2)
plot(t,IR_blue,'b')
title('Small Blue')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(2,2,3)
plot(t,IR_red,'r')
title('Medium Red')
xlabel('Time (s)')
ylabel('Amplitude')

subplot(2,2,4)
plot(t,IR_yellow,'y')
title('Large Yellow')
xlabel('Time (s)')
ylabel('Amplitude')

%----- ROCKET DATA -----%

% Pulling in the rocket data
IDnum = 20;
CHnum = 13;
fs = 96000;
[waveform, t] = getTimeSeries('Data', IDnum, CHnum, fs);

% Chopping it to an interesting part
waveform = waveform(fs*35:fs*45);
t = t(fs*35:fs*45);

figure()
plot(t, waveform)
title('GEM-60 Rocket Data')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

%----- CONVOLVING THE TWO -----%
newWaveform_none = convolveIR(IR_none,waveform); disp('Done with no screen')
newWaveform_black = convolveIR(IR_black,waveform); disp('Done with black')
newWaveform_blue = convolveIR(IR_blue,waveform); disp('Done with blue')
newWaveform_red = convolveIR(IR_red,waveform); disp('Done with red')
newWaveform_yellow = convolveIR(IR_yellow,waveform); disp('Done with yellow')

% Plotting the convolved waveforms
figure()
plot(t,waveform)
hold on
plot(t,newWaveform_none,'g')
plot(t,newWaveform_black,'k')
plot(t,newWaveform_blue,'b')
plot(t,newWaveform_red,'r')
plot(t,newWaveform_yellow,'y')
grid on
title('Convolved Waveforms')
legend('Original','No Wind Screen','Standard Black','Small Blue','Medium Red','Large Yellow','Location','NorthWest')
xlabel('Time (s)')
ylabel('Pressure (Pa)')

%----- LISTENING -----%
disp(strcat("Now Playing: Original (dSk = ",num2str(skewness(diff(waveform))),")"))
soundsc(waveform,fs); pause(11)

disp(strcat("Now Playing: No Screen (dSk = ",num2str(skewness(diff(newWaveform_none))),")"))
soundsc(newWaveform_none,fs); pause(11)

disp(strcat("Now Playing: Black (dSk = ",num2str(skewness(diff(newWaveform_black))),")"))
soundsc(newWaveform_black,fs); pause(11)

disp(strcat("Now Playing: Blue (dSk = ",num2str(skewness(diff(newWaveform_blue))),")"))
soundsc(newWaveform_blue,fs); pause(11)

disp(strcat("Now Playing: Red (dSk = ",num2str(skewness(diff(newWaveform_red))),")"))
soundsc(newWaveform_red,fs); pause(11)

disp(strcat("Now Playing: Yellow (dSk = ",num2str(skewness(abs(newWaveform_yellow))),")"))
soundsc(newWaveform_yellow,fs); pause(11)

function [impulseResponse,t] = getImpulseResponse(IDnum_micA_with_screen,CHnum_micA_with_screen,...
                               IDnum_micB,CHnum_micB,...
                               screenType)
                  
    %----- Important variables
    fs = 102400;
    dt = 1/fs;
    path = 'Data';
    ns = fs/1;

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
    
    Hab_double = [fliplr(conj(Hab)) Hab];
    
    impulseResponse = ifft(ifftshift(Hab_double),fs,'symmetric'); % Outputs a double-sided waveform?
    impulseResponse = impulseResponse(1:fs/2); % Removing second half
    %impulseResponse = impulseResponse./max(impulseResponse); % normalizing to 1
    t = 0:dt:(length(impulseResponse) - 1)*dt;
    
    figure()
    plot(t,impulseResponse)
    title(strcat(screenType," Impulse Response"))
    xlabel('Time (s)')
    ylabel('Amplitude')
    grid on
                  
end

function [newWaveform] = convolveIR(impulseResponse,waveform)
    
    impulseResponse = resample(impulseResponse,96000,102400);
    newWaveform = conv(waveform,impulseResponse./max(impulseResponse), 'same');

end
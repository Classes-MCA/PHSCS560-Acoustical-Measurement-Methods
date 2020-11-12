clear; close all;
plotStyle()

pathToData = pwd;

% Getting the waveform
waveform = binfileload(pathToData,'ID',20,12);

% Shortening the waveform
startTime = 35;
endTime = 40;
fs = 96000;
waveform = waveform(startTime*fs:endTime*fs);

% Creating the time array
dt = 1/fs;
t = 0:dt:(length(waveform) - 1)*dt;
t = t(:);

%----- BROADBAND NOISE

% Calculating the autospectrum for various block sizes
blockSizes = [fs/1,fs/2,fs/5];
figure()
for i = 1:3
    
    [Gxx,f,OASPL] = autospecMCA(waveform,fs,blockSizes(i));
    
    disp(strcat('Integrated OASPL = ',num2str(OASPL)))
    
    [OASPL_time,~,~] = getOASPL(waveform,fs);
    
    disp(strcat('Waveform OASPL = ',num2str(OASPL_time)))
    
    legendValues(i) = strcat("Block Size = ",num2str(blockSizes(i)),". OASPL Frequency Domain: ",num2str(OASPL),". OASPL Time Domain: ",num2str(OASPL_time),".")
    
    semilogx(f,Gxx,'LineWidth',2)
    title('Autospectral Density Block Size Comparison (Broadband Noise)')
    xlabel('Frequency (Hz)')
    ylabel('Autospectral Density (Pa^2 / Hz)')
    xlim([1e1,1e3])
    ylim([0,14000])
    legend(legendValues)
    grid on
    hold on
    
end
hold off


%----- TONAL NOISE

fs=204800;
dt=1/fs;
T=5; 
t=0:dt:(T-dt);
[B,A]=butter(2,[500,5000]/(fs/2));
waveform=sin(2*pi*4000*t)+3*filter(B,A,randn(1,length(t)));

figure()
plot(t,waveform)
title('Simulated Tonal Noise Waveform')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

blockSizes = [fs/1,fs/2,fs/5];
figure()
for i = 1:3
    
    [Gxx,f,OASPL] = autospecMCA(waveform,fs,blockSizes(i));
    
    disp(strcat('Integrated OASPL = ',num2str(OASPL)))
    
    [OASPL,~,~] = getOASPL(waveform,fs);
    
    disp(strcat('Waveform OASPL = ',num2str(OASPL)))
    
    % Calculating the tone mean-square pressure
    prms = max(Gxx)/(f(2)-f(1));
    disp(strcat('Tone Mean-square Pressure: ',num2str(prms)))
    
    semilogx(f,Gxx,'LineWidth',2)
    title('Autospectral Density Block Size Comparison (Tonal Noise)')
    xlabel('Frequency (Hz)')
    ylabel('Autospectral Density (Pa^2 / Hz)')
    xlim([1e2,2e4])
    legend('Block Size = fs/1','Block Size = fs/2','Block Size = fs/5')
    grid on
    hold on
    
end
hold off

savePlots('SavePath',pwd,'FileType',["png"])
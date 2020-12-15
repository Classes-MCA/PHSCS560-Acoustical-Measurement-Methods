usePackage GeneralSignalProcessing
usePackage ArrayAnalysis
set(0,'DefaultAxesLineStyleOrder',{'-','--'});  %plots all solid lines, and then dashed

clear; close all; plotStyle()

% Some general parameters
fs = 102400;
angles = -90:22.5:90;
FocusChannel = 2;
pathToData = '/Volumes/Mark Drive/Classes/Acoustical Measurement Methods/Final Project/Final Project/';

% Analysis Block
tstart = 12;
tend = 15;
lowerFrequency = 65;
upperFrequency = 10000;

%% Getting the data from a recording

IDnum = 16;
mics = MicArray;
mics.initializeArray(length(angles));

% Acoustical Data
for i = 1:length(angles)
    
    mics.Microphones(i).Name = num2str(angles(i));
    
    mics.Microphones(i).SamplingFrequency = fs;
    
    mics.Microphones(i).Waveform = binfileload(...
        strcat(pathToData,'/Raw Data/Acoustical Data'),...
        'ID',IDnum,i-1);
    
end

% Thrust Data
RCdata = readtable(strcat(pathToData,'RCBenchmarkData/Thrust_2020-12-03_092214.csv'));

time = RCdata{:,1};
thrust = -RCdata{:,10} .* 9.807; % Converting to Newtons from kgf

%% Creating a pretty plot for the time-ordered data

dt = 1/fs;
t = 0:dt:(length(mics.Microphones(FocusChannel+1).Waveform) - 1)*dt;

windowSize = 0.5;
[~,OASPL,t_OASPL] = getOASPL(mics.Microphones(FocusChannel+1).Waveform,fs,...
                             'TimeWindow',windowSize);
t_OASPL = t_OASPL + windowSize;

h = figure();

subplot(3,1,1)
plot(time + 9,thrust,'k-')
title('Thrust')
xlabel('Time (s)')
ylabel('Thrust (N)')
ylim([0.5,3])
xlim([0,50])
xline(tstart,'r--')
xline(tend,'r--')

subplot(3,1,2)
plot(t,mics.Microphones(FocusChannel+1).Waveform,'k-')
title('Waveform')
ylabel('Pressure (Pa)')
xline(tstart,'r--')
xline(tend,'r--')

subplot(3,1,3)
plot(t_OASPL,OASPL,'k-')
title('OASPL')
ylabel('OASPL (dB)')
xline(tstart,'r--')
xline(tend,'r--')
ylim([min(OASPL) - 5, max(OASPL) + 5])

hstitle = sgtitle(strcat("Time Data at ",num2str(angles(FocusChannel+1)),"^\circ"));
hstitle.FontSize = 18;
hstitle.FontWeight = 'Bold';

%% Creating a spectrogram for the chosen angle

[Gxx,t,f,~] = specgram(mics.Microphones(FocusChannel+1).Waveform,...
                       fs,...
                       fs/2,... Block size
                       50); % Percent overlap
h = figure();
[T,F] = meshgrid(t,f);
spectrum = convertToDB(Gxx,'Squared',true);
pcolor(T',F',spectrum)
colormap jet
shading interp
set(gca,'yscale','log','ytick',[100,1000,10000])
ylim([lowerFrequency,upperFrequency])
ylabel('Frequency (Hz)')
xlabel('Time (s)')
title(strcat("Spectrogram at ",num2str(angles(FocusChannel+1)),"^\circ"))
colorbar('EastOutside')

%% Chopping the waveforms to the shorter values

for i = 1:length(angles)
    
    mics.Microphones(i).Waveform = mics.Microphones(i).Waveform(tstart*fs:tend*fs);
    
end

%% Analyzing the Spectra

h = figure();
mics.generateSpectra('BlockSize',fs/2,'Output','Autospectral Density')
mics.compareSpectra()

ax = gca;
ax.XLim = [lowerFrequency,upperFrequency];
ax.Title.FontSize = 18;
ax.Title.String = 'Autospectral Density at All Angles';
hleg = legend();
hleg.Location = 'EastOutside';
hleg.Title.String = 'Angle (Degrees)';
hleg.FontSize = 16;

h.Units = "Inches";
h.Position = [2,2,10,5];

% Now doing just 45 degrees and comparing with NASA
motorWaveform = binfileload(...
        strcat(pathToData,'/Raw Data/Acoustical Data'),...
        'ID',18,FocusChannel+1);

motorWaveform = motorWaveform(tstart*fs:tend*fs);
    
[Gxx_motor, f_motor, ~] = autospec(motorWaveform,...
                                   fs,...
                                   'BlockSize',fs/2,...
                                   'Output','Autospectral Density');
[Gxx_total, f_total, ~] = autospec(mics.Microphones(FocusChannel+1).Waveform,...
                                   fs,...
                                   'BlockSize',fs/2,...
                                   'Output','Autospectral Density');

motorSpectrum = convertToDB(Gxx_motor,'Squared',true);
totalSpectrum = convertToDB(Gxx_total,'Squared',true);
                               
h = figure();
semilogx(f_total,totalSpectrum,'b-')
hold on
semilogx(f_motor,motorSpectrum,'k--')
xlim([lowerFrequency,upperFrequency])
%ylim([0,50])
xlabel('Frequency (Hz)')
ylabel('SPL (dB)')
title(strcat("Autospectral Density at ",num2str(angles(FocusChannel+1)),"^\circ"))
grid on
hleg = legend('Propeller + Motor','Motor Only','Location','EastOutside');
hleg.Title.String = 'Angle (Degrees)';
hleg.FontSize = 16;
h.Units = "Inches";
h.Position = [2,2,10,5];

% Comparing our spectra with NASA's spectra
NASAdata = readtable(strcat(pathToData,'NASA DJI Data.csv'));
freq_NASA = NASAdata{:,1};
spec_NASA = NASAdata{:,2};

h = figure();
semilogx(f_total,totalSpectrum,'b-')
hold on
semilogx(freq_NASA,spec_NASA,'g--')
xlim([lowerFrequency,upperFrequency])
xlabel('Frequency (Hz)')
ylabel('SPL (dB)')
title(strcat("Autospectral Density Comparison"))
grid on
hleg = legend('Our Data','NASA Data','Location','EastOutside');
hleg.Title.String = 'Dataset';
hleg.FontSize = 16;
h.Units = "Inches";
h.Position = [2,2,10,5];

%% Directivity Comparison

% Getting the data

% From WebPlotDigitizer
OASPL_NASA = [62.5, 59.0, 53.4, 57.8, 61.2];
OASPL_NASA_A = [58.8, 54.4, 48.4, 53.8, 58.0];
angles_NASA = [-45, -22.5, 0, 22.5, 45];

% Weighting
[W,Gain] = weighting(mics.Microphones(1).NarrowbandFrequencies,'A');

% From the array
for i = 1:length(angles)
    
    OASPL_BYU(i) = mics.Microphones(i).OASPL;
    OASPL_BYU_A(i) = addDecibels(mics.Microphones(i).NarrowbandSpectrum + Gain);
    
end

h = figure();
subplot(1,3,1)
polarplot(angles.*pi/180,OASPL_BYU,'b-o','MarkerSize',10)
hold on
polarplot(angles_NASA.*pi/180,OASPL_NASA,'g-o','MarkerSize',10)
ax = gca;
ax.ThetaLim = [-90,90];
ax.RLim = [0,90];
ax.Title.String = 'OASPL';
ax.Title.FontSize = 20;
ax.ThetaZeroLocation = 'left';
ax.ThetaDir = 'clockwise';

subplot(1,3,2)
polarplot(angles.*pi/180,OASPL_BYU_A,'b-o','MarkerSize',10)
hold on
polarplot(angles_NASA.*pi/180,OASPL_NASA_A,'g-o','MarkerSize',10)
ax = gca;
ax.ThetaLim = [-90,90];
ax.RLim = [0,90];
ax.Title.String = 'OASPL-A';
ax.Title.FontSize = 20;
ax.ThetaZeroLocation = 'right';
ax.ThetaDir = 'counterclockwise';

hleg = legend('Our Data','NASA Data');
hleg.FontSize = 18;
hleg.Title.String = 'Dataset';
hleg.Position = [0.70 0.45 0.1833 0.1478];

h.Position = [2,2,10,5.5];
clear; close all; plotStyle()

Sound_Power_Reverberation_Room;
Sound_Power_Anechoic_Chamber;

%% Final calculations
figure()
semilogx(frequencies,SoundPower_Reverb,'b-o','LineWidth',2,'DisplayName','Reverberation Chamber')
hold on
semilogx(frequencies,SoundPower_Anechoic,'r-o','LineWidth',2,'DisplayName','Anechoic Chamber')
title('Blender Sound Power')
xlabel('OTO Band Center Frequency (Hz)')
ylabel('Sound Power (dB)')
grid on
legend('Location','SouthEast')

% Calculating the total sound powers
pressure_reverb = Iref.*10.^(SoundPower_Reverb ./ 10);
pressure_anechoic = Iref.*10.^(SoundPower_Anechoic ./ 10);

TotalSoundPower_Reverb = 10 * log10(sum(pressure_reverb)/Iref)
TotalSoundPower_Anechoic = 10 * log10(sum(pressure_anechoic)/Iref)
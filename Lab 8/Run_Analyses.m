clear; close all; plotStyle()

Sound_Power_Reverberation_Room;
Sound_Power_Anechoic_Chamber;

figure(); hold on;
semilogx(frequencies,SoundPower_Reverb,'b-o','LineWidth',2,'DisplayName','Reverberation Chamber')
semilogx(frequencies,SoundPower_Anechoic,'r-o','LineWidth',2,'DisplayName','Anechoic Chamber')
title('Blender Sound Power')
xlabel('OTO Frequency (Hz)')
ylabel('Sound Power (dB)')
grid on
legend()
clear; close all;
plotStyle()

%----- Part A

% Signal components
amplitude = [2, 3, 1.5, 2.5];
phase = [0, pi/4, 2*pi/3, pi];
frequency = [31.25, 125.0, 187.5, 375.0];

% Time information
dt = 0.1e-3;
t = 0:dt:1.024;
t = t(:);

% Calculating the voltage quantization
bits = 24;
Vpp = 18;
quantizationLevels = 2^bits;
quantizationVoltage = Vpp / quantizationLevels;
disp(strcat("Quantization Voltage = ",num2str(quantizationVoltage)))

% Constructing the signal
signal = zeros(length(t),1);
for j = 1:length(amplitude)
    
    % Important: 'j' refers to an imaginary number
    
    a = amplitude(j);
    phi = phase(j);
    w = 2*pi*frequency(j);
    e = 2.71828;
    
    signal = signal + real(a * e^(1i*phi) .* e.^(1i.*w.*t));
    
end

% Resampling the signal
fs = 1000;
dt_data = 1/fs;
t_data = 0:dt_data:1.024;

tsin = timeseries(signal,t);
tsout = resample(tsin,t_data);
data = tsout.Data;

% figure()
% plot(t,signal)
% hold on
% stem(t_data,data,'filled')
% title('Sampling the Waveform Over All Blocks')
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% grid on

figure()
plot(t,signal)
hold on
stem(t_data,data,'filled','Color','green')
title(strcat("Sampling the Waveform Over One Block (",num2str(bits)," Bits)"))
xlabel('Time (s)')
ylabel('Voltage (V)')
xlim([0,31e-3])
grid on
legend('Physical Waveform','Ideal Time-Sampled Waveform','location','NorthWest')

%----- Part B

% Rounding each value in the measured time series to the nearest
% quantization voltage
quantizations = -Vpp/2:quantizationVoltage:Vpp/2;
quantizedData = interp1(quantizations,quantizations,data,'nearest');

% figure()
% plot(t,signal)
% hold on
% stem(t_data,data,'filled')
% stem(t_data,quantizedData,'*')
% title('Quantizing the Waveform Over All Blocks')
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% grid on

figure()
plot(t,signal)
hold on
stem(t_data,data,'filled','Color','green')
stem(t_data,quantizedData,'filled','Color','red')
title(strcat("Quantizing the Waveform Over One Block (",num2str(bits)," Bits)"))
xlabel('Time (s)')
ylabel('Voltage (V)')
xlim([0,31e-3])
grid on
legend('Physical Waveform','Ideal Time-Sampled Waveform','Quantized Time-Sampled Waveform','location','NorthWest')

%----- Part C

noise = data - quantizedData;

% figure()
% plot(t,signal)
% hold on
% stem(t_data,data,'filled')
% stem(t_data,noise,'o')
% title('Quantizing the Waveform Over All Blocks')
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% grid on

figure()
plot(t,signal)
hold on
stem(t_data,data,'filled','Color','green')
stem(t_data,noise,'o','Color','black')
title(strcat("Noise Over One Block (",num2str(bits)," Bits)"))
xlabel('Time (s)')
ylabel('Voltage (V)')
xlim([0,31e-3])
grid on
legend('Physical Waveform','Ideal Time-Sampled Waveform','Quantization Noise','location','NorthWest')

%----- Part D

rms_data = rms(data);
rms_noise = rms(noise);
reference = 1;
SNR = 20*log10(rms_data/reference) - 20*log10(rms_noise/reference);
disp(strcat("SNR = ",num2str(SNR)))
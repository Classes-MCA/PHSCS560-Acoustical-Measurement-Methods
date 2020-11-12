clear; close all;
plotStyle()
addpath('Time Domain Analysis Supporting Files')

% Part A - Creating a shock waveform
fs = 44.1e3;
dt = 1/fs;
time = 1; % seconds
t = 0:dt:time;

[waveform,t] = friedlander(4000,0.01,t,0);

figure()
plot(t,waveform)
title('Ideal Friedlander Waveform')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

% Part B - Creating an impulse response

delay = 20e-3;
firstAmplitude = 1;
numPulse = 0;
impulseResponse = zeros(length(t),1);

for i = 1:length(t)
    
    if mod(t(i),delay) < 1e-8
        impulseResponse(i) = 0.7071^numPulse;
        numPulse = numPulse + 1;
    end
    
end

figure()
plot(t,impulseResponse)
title('Simulated Impulse Response')
xlabel('Time (s)')
ylabel('Amplitude')
grid on

% Part C - Convolving the Shock and Impulse Reponse

sound = conv(waveform,impulseResponse,'same');

figure()
plot(t,sound)
title('Resulting Sound Inside Room')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

% Part D - Using a Real Impulse Response

HillImpulseResponse = audioread('Hill_Range_IR.wav');
t_Hill = 0:dt:(length(HillImpulseResponse) - 1)*dt;

figure()
plot(t_Hill,HillImpulseResponse)
title('Hill Impulse Response')
xlabel('Time (s)')
ylabel('Amplitude')
grid on

% Convolving the Friedlander with the Hill Impulse Response
HillSound = conv(waveform,HillImpulseResponse,'same');

figure()
plot(t,HillSound)
title('Resulting Sound Inside Hill AFB Room')
xlabel('Time (s)')
ylabel('Pressure (Pa)')
grid on

% savePlots('SavePath',pwd,'FileTypes',["png"])
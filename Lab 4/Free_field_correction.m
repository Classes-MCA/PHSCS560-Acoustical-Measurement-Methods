clear; close all;
plotStyle()

%----- Pulling in the data

% Both oriented skyward
fs = 102400;
ns = fs/10;

% Quarter Inch
[waveform_quarterinch_sky1,~] = getTimeSeries('Data',7,0,fs,'PlotResult',false);

% Half Inch
[waveform_halfinch_sky,~] = getTimeSeries('Data',7,1,fs);

% Quarter inch skyward, half inch source

% Quarter Inch
[waveform_quarterinch_sky2,~] = getTimeSeries('Data',8,0,fs);

% Half Inch
[waveform_halfinch_source,~] = getTimeSeries('Data',8,1,fs);

% Filtering
% 
% waveform_quarterinch_sky1 = resample(waveform_quarterinch_sky1,10e3,fs);
% waveform_quarterinch_sky2 = resample(waveform_quarterinch_sky2,10e3,fs);
% waveform_halfinch_sky = resample(waveform_halfinch_sky,10e3,fs);
% waveform_halfinch_source = resample(waveform_halfinch_source,10e3,fs);

% fs = 10e3;

[Gxx_quarter_sky2,~,~] = autospec(waveform_quarterinch_sky2,fs,ns);
[Gxx_half_source,f,~]  = autospec(waveform_halfinch_source,fs,ns);

Gxx_quarter_sky2_dB = convertToDB(Gxx_quarter_sky2);
Gxx_half_source_dB  = convertToDB(Gxx_half_source);

correction_1 = Gxx_quarter_sky2_dB - Gxx_half_source_dB;

[Gxx_quarter_sky1,~,~] = autospec(waveform_quarterinch_sky1,fs,ns);
[Gxx_half_sky,f,~]  = autospec(waveform_halfinch_sky,fs,ns);

Gxx_quarter_sky1_dB = convertToDB(Gxx_quarter_sky1);
Gxx_half_sky_dB  = convertToDB(Gxx_half_sky);

correction_2 = Gxx_quarter_sky1_dB - Gxx_half_sky_dB;

figure()
semilogx(f,correction_1 - correction_2)
title('GRAS 40AE Free-field Correction')
xlabel('Frequency (Hz)')
ylabel('Correction (dB)')
grid on
xlim([50,5e3])

% figure()
% semilogx(f,Gxx_quarter_sky2_dB)
% title('GRAS 40BE Autospectrum')
% xlabel('Frequency (Hz)')
% ylabel('Correction (dB)')
% grid on
% xlim([50,25e3])
% ylim([-100,40])
% 
% figure()
% semilogx(f,Gxx_half_source_dB)
% title('GRAS 40AE Autospectrum')
% xlabel('Frequency (Hz)')
% ylabel('Correction (dB)')
% grid on
% xlim([50,25e3])
% ylim([-100,40])

% sky = fft(waveform_halfinch_sky);
% source = fft(waveform_halfinch_source);
% 
% figure()
% loglog(conj(sky).*sky)
% 
% figure()
% loglog(conj(source).*source)
% 
% transferFunction = sky./source;
% 
% transferFunction = transferFunction(1:length(transferFunction)/2);
% transferFunction = (conj(transferFunction).*transferFunction);
% transferFunction = convertToDB(transferFunction,'ReferencePressure',1);
% 
% fmax = fs/2; %s since fs is even
% fmax = 10e3/2;
% t = 20;
% df = 1/t; % just memorize this
% f = 0:df:(fmax-df);
% 
% figure()
% semilogx(f,transferFunction)
% xlim([50,5e3])
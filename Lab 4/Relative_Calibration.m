clear; close all;

fs = 102400;
ns = fs/2;

%----- Getting the first values before switching places
IDnum = 1;

% First Mic SN: 63617 --> This one is our 'x'
[x,~] = getTimeSeries('Data',IDnum,0,fs,'PlotResult',false);

% Second Mic SN: 57432 --> This one is our 'y'
[y,~] = getTimeSeries('Data',IDnum,1,fs,'PlotResult',false);

% Getting the auto spectrum of x
[Gxx,~,~] = autospec(x,fs,ns);

% Getting the cross spectrum of x and y
[Gxy,~] = crossspec(x,y,fs,ns);

% Calculating the transfer function H
Hxy_first = Gxy ./ Gxx;


%----- Getting the second values after switching places
IDnum = 4;

% First Mic SN: 63617 --> This one is our 'x'
[x,t_firstMic] = getTimeSeries('Data',IDnum,0,fs,'PlotResult',false);

% Second Mic SN: 57432 --> This one is our 'y'
[y,t_secondMic] = getTimeSeries('Data',IDnum,1,fs,'PlotResult',false);

% Getting the auto spectrum of x
[Gxx,~,~] = autospec(x,fs,ns);

% Getting the cross spectrum of x and y
[Gxy,f] = crossspec(x,y,fs,ns);

% Calculating the transfer function H
Hxy_second = Gxy ./ Gxx;


%----- Averaging the two transfer functions

Hxy = sqrt(Hxy_first .* Hxy_second);

figure()
semilogx(f,real(Hxy_first),'LineWidth',2)
hold on
semilogx(f,angle(Hxy_first),'LineWidth',2)
semilogx(f,real(Hxy_second),'LineWidth',2)
semilogx(f,angle(Hxy_second),'LineWidth',2)
title('Transfer Function Between Half-inch Microphones (Both Calibrations)')
xlabel('Frequency (Hz)')
ylabel('Hxy')
xlim([0,20e3])
grid on
legend('First Cal (amp)','First Cal (phase)','Second Cal (amp)','Second Cal (phase)')

figure()
semilogx(f,real(Hxy),'LineWidth',2)
hold on
semilogx(f,angle(Hxy),'LineWidth',2)
title('Transfer Function Between Half-inch Microphones')
xlabel('Frequency (Hz)')
ylabel('Hxy')
xlim([0,20e3])
grid on
legend('Amplitude','Phase','Location','northwest')


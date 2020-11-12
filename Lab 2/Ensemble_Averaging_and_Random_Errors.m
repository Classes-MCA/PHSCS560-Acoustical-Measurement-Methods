clear; close all;
plotStyle()

fs = 51200;
dt = 1/fs;
tone = 500; % Hz
time = 2; % seconds

t = 0:dt:(time*fs - 1)*dt;

waveform = sin(2*pi*tone*t);

ns = 10:10:100;

numBlocks = flip(length(waveform)./ns);

for i = 1:length(ns)
    
    disp(strcat('Block Size:',num2str(ns(i))))
    [~,~,OASPL(i)] = autospec(waveform,fs,ns(i));
    
end

[OASPL_time,~,~] = getOASPL(waveform,fs);

theory = (max(OASPL) - min(OASPL)) ./ sqrt(ns);

figure()
semilogx(numBlocks, OASPL - OASPL_time)
hold on
semilogx(numBlocks,theory)
title('Random Error')
xlabel('Number of Blocks')
ylabel('Frequency-domain OASPL - time-domain OASPL')
grid on

% savePlots('SavePath',pwd,'FileTypes',["png"])
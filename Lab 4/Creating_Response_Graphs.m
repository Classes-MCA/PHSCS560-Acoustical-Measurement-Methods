clear; close all;
plotStyle()

halfInchOne = readtable('Data/40AE mic, PRM426 preamp0350.txt');
halfInchTwo = readtable('Data/40AE mic, PRM426 preamp0374.txt');
quarterInch = readtable('Data/40BE mic, 26CB preamp61085.txt');

names = ["40AE (0350)","40AE (0374)","40BE (61085)"];

dBDown = -2;

for i = 1:length(names)
    
    % Pulling the correct data
    switch i
        case 1
            data = halfInchOne;
        case 2
            data = halfInchTwo;
        case 3
            data = quarterInch;
    end
    
    % Getting the frequencies
    frequencies = table2array(data(1:90,1)); % last 3 values (91-93) are NaN in both arrays
    calibration = table2array(data(1:90,3));
    
    figure(1)
    semilogx(frequencies,calibration,'LineWidth',2)
    title('Absolute Calibration Values')
    xlabel('Frequency (Hz)')
    ylabel('Calibration (dB)')
    grid on
    hold on
    
    % Calculate dB-down points
    for j = 1:length(calibration)-1
        
        firstValue = calibration(j);
        secondValue = calibration(j+1);
        
        if dBDown >= firstValue && dBDown <= secondValue
            if abs(dBDown - firstValue) <= abs(secondValue - dBDown)
                disp(strcat(names(i),": ",num2str(frequencies(j))))
            else
                disp(strcat(names(i),": ",num2str(frequencies(j+1))))
            end
        end
        
        if dBDown >= secondValue && dBDown <= firstValue
            if abs(dBDown - firstValue) <= abs(secondValue - dBDown)
                disp(strcat(names(i),": ",num2str(frequencies(j))))
            else
                disp(strcat(names(i),": ",num2str(frequencies(j+1))))
            end
        end
        
    end
    
end

% Adding pretty things to the plot
yline(dBDown)
legend([names,strcat(num2str(dBDown)," dB")],'Location','southwest')
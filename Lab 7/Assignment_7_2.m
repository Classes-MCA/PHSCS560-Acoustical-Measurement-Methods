clear; close all;

diameter = 0.1;
frequencies = [100,4000];
angles = -90:0.1:90;
distance = 0.2;
rlimits = [-40,1];

%----- Baffled Circular Piston
% Low Frequency
subplot(3,2,1)
H = baffledCircularPiston(diameter, frequencies(1), angles);
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("BCP: ",num2str(frequencies(1))," Hz"))

% High Frequency
subplot(3,2,2)
H = baffledCircularPiston(diameter, frequencies(2), angles);
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("BCP: ",num2str(frequencies(2))," Hz"))

%----- Dipole
% Low Frequency
subplot(3,2,3)
H = dipole(distance, frequencies(1), angles);
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("Dipole: ",num2str(frequencies(1))," Hz"))

% High Frequency
subplot(3,2,4)
H = dipole(distance, frequencies(2), angles);
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("Dipole: ",num2str(frequencies(2))," Hz"))

%----- Two Out-of-Phase Baffled Circular Pistons
% Low Frequency
subplot(3,2,5)
H_bcp = baffledCircularPiston(diameter, frequencies(1), angles);
H_dipole = dipole(distance, frequencies(1), angles);
H = H_dipole .* H_bcp;
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("Two Pistons: ",num2str(frequencies(1))," Hz"))

% High Frequency
subplot(3,2,6)
H_bcp = baffledCircularPiston(diameter, frequencies(2), angles);
H_dipole = dipole(distance, frequencies(2), angles);
H = H_dipole .* H_bcp;
polarplot(angles*pi/180, 20*log10(H))
set(gca,'ThetaZeroLocation','top')
thetalim([-90 90])
rlim(rlimits)
title(strcat("Two Pistons: ",num2str(frequencies(2))," Hz"))
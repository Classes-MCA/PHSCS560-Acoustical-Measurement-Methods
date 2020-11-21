clear; close all;
plotStyle()

% Defining some important information
DegreeStep = 10;
startAngle = 0;
endAngle = 360;
angles = startAngle:DegreeStep:endAngle;
numChannels = 6;
numMics = numChannels * length(angles);

% Defining the locations of each of the microphones in the X-Y plane.
% If you're standing at the door of the anechoic chamber, the x-axis points
% to the left, the y-axis points toward you (toward the door) and the
% z-axis points straight up toward the ceiling
microphoneLocations = [0 , 0, 46;
                       35, 0, 46;
                       80, 0, 33;
                       80, 0,  6;
                       80, 0,-26;
                       26, 0,-39]./100; % converting to meters
                   
%% ----- Importing the data -----%
micMesh = MicArray; % Creating an array object

% Going over each microphone
currentAngle = angles(1);
currentChannel = 0;
for i = 1:numMics
    
    % Add a microphone object to the array
    micMesh.Microphones(i) = Microphone;
    
    % Loading in acoustic data
    micMesh.Microphones(i).Waveform = binfileload('Lab 8 Anechoic Data',...
                                                  'ID',currentAngle/10 + 1,...
                                                  currentChannel);
    
    micMesh.Microphones(i).SamplingFrequency = 51200;
                                              
    % Loading in name data
    micMesh.Microphones(i).Name = strcat("Angle: ",num2str(currentAngle),...
                                         ", Channel ",num2str(currentChannel));
                                              
    % Loading in position data
    position = microphoneLocations(currentChannel + 1,:);
    
    % Assuming the initial location is purely in the x-direction, we
    % can calculate the new x and y positions based on the angle we are
    % now at.
    micMesh.Microphones(i).Location = [position(1)*cosd(currentAngle),...
                                       position(1)*sind(currentAngle),...
                                       position(3)];
    
    % Preparing for next iteration
    currentChannel = currentChannel + 1;
    if currentChannel > 5
        currentChannel = 0;
        currentAngle = currentAngle + DegreeStep;
    end

end

%% ----- Initial Analysis -----%
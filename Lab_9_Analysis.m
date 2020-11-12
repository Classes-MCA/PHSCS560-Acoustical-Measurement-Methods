clear; close all;

% Gathering the data into an array
tubeArray = MicArray;
tubeArray.initializeArray(4)
CHnums = [0, 1, 2, 3];

%----- Sound Speed Measurement -----%
micLocations = [-11, -6, 6, 11];

% Gather in the data
for i = 1:length(
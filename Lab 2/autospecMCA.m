function [Gxx,f,OASPL] = autospecMCA(x,fs,ns,varargin)

    p = inputParser;
    p.addRequired('x');
    p.addRequired('fs');
    p.addRequired('ns');
    p.addParameter('Window',true);
    p.parse(x,fs,ns,varargin{:});
    Window = p.Results.Window;

    x = x(:); % Makes x into a column vector
    numBlocks = floor(length(x)/ns);
    averageSpectrum = zeros(ns,1);
    for i = 1:numBlocks
        
        % Divide the waveform x into equally-sized blocks of length ns, 
        % with a 50% overlap
        block = x((i-1)*ns+1:i*ns); % FIXME: Need a 50% overlap
        
        % Window each block
        if Window
            windowedBlock = hann(ns).*block;
        else
            windowedBlock = block;
        end
        
        % Calculate the magnitude squared of the Fourier transform of each
        % block and average over the blocks
        spectrum = fft(windowedBlock,ns);
        spectrum = conj(spectrum).*spectrum;
        
        averageSpectrum = averageSpectrum + spectrum;
        
    end
    
    % Averaging the spectrum
    averageSpectrum = averageSpectrum ./ numBlocks;
    
    % Only retain positive components
    spectrum = averageSpectrum(1:length(averageSpectrum)/2);

    % Multiply by correct factor to retain energy
    % UNDERSTANDME: These next three lines are taken straight from Dr.
    % Gee's autospec() function
    if Window
        ww = hann(ns);
        W = mean(ww.*conj(ww)); %Used to scale the ASD for energy conservation. 
                                %'W' is the mean-squared value of the window
        Scale = 2/ns/fs/W;
    else
        ww = ones(ns,1);
        W = mean(ww.*conj(ww)); %Used to scale the ASD for energy conservation. 
                                %'W' is the mean-squared value of the window
        Scale = 2/ns/fs/W;
    end

    Gxx = Scale*spectrum;
    
    % Calculate the frequencies
    % UNDERSTANDME: This next line is straight from Dr. Gee's autspec()
    % function
    f = fs*(0:ns/2-1)/ns;
    
    % Setting OASPL
    % UNDERSTANDME: This is basically just taken from Dr. Gee's autospec()
    OASPL = 20*log10(sqrt(sum(Gxx))/20e-6);

end
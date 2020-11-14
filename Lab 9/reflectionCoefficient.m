function [R1, R2, RWall,f] = reflectionCoefficient(mic1,mic2,WallLocation,soundSpeed)

    d = norm(mic1.Location - mic2.Location);
    L = WallLocation;
    fs = 51200;

    [H12,f] = transferFunction(mic1,mic2,'BlockSize',fs/1,'ShowPlot',false);
    
    k = 2*pi.*f ./ soundSpeed;
    
    R1 = (H12 - exp(-1i*k*d)) ./ (H12 - exp(1i*k*d));
    
    R2 = - R1 .* exp(2*1i*k*d);
    
    RWall = - R1 .* exp(2*1i*k*(d+L));

end
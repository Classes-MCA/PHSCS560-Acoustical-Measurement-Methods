function R = reflectionCoefficient(mic1,mic2)

    e = 2.718; % constant

    H12 = transferFunction(mic1,mic2);
    
    R = (H12 - e^(-j*k*d)) / (H12 - e^(j*k*d));

end
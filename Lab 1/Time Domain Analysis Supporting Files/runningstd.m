function [sigma,t] = runningstd( x,ns,fs )
%function [sigma,t] = runningstd( x,ns,fs )
%  Calculates the running standard deviation, sigma, for block size, ns.
%  If fs is supplied, it will return a relative time array, t, corresponding to the
%  time value at the beginning of each block.  If fs is not supplied, t is
%  simply an array from 1 to the number of blocks.
%  KLG, 11/14/13u

numblocks=floor(length(x)/ns);

for n=1:numblocks
    sigma(n)=std(x(1+(n-1)*ns:n*ns));
end

if nargin<3
    t=1:numblocks;
else
    dt=ns/fs;
    t=0:dt:(numblocks-1)*dt;
end


end


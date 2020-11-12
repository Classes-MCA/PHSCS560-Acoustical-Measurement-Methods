function [ vals,bins ] = pdfcalc( x,numbins )
%[ bins,vals ] = pdfcalc( x,numbins )
%   This function calculates an estimate of the probability density
%   function using MATLAB's hist command, evaluated at numbins (contained
%   in the bins array.
% KLG, 11/14/13

[vals,bins]=hist(x,numbins);

dx=min(diff(bins));
N=length(x);

vals=vals/dx/N;

end


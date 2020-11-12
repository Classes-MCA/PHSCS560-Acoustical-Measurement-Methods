function [ p,t ] = friedlander( Psh,tau,t,padopt)
%This function calculates a modified Friedlander waveform at time values
%defined by t using the peak overpressure, Psh, and characteristic time
%scale, tau.  The waveform peak occurs at t(1).  If padopt=1, then 10% zero
%padding is added prior to the shock.  
%   Detailed explanation goes here


if nargin<4
    padopt=0;
end

dimt=size(t);
if dimt(1)>1
    t=t.';
end

if padopt==1
    dt=min(diff(t));
    tmin=min(t);
    tmax=max(t);
    T=length(t);
    Tpad=round(T/10);
    tpad=tmin-Tpad*dt:dt:tmin-dt;
    ppad=zeros(size(tpad));
else
    tpad=[];
    ppad=[];
end
    
tscale=t/tau;
p=Psh*exp(-tscale).*(1-tscale);

t=[tpad,t];
p=[ppad,p];

end


function f = sideBranchNull(Length,radius,correctionFactor,soundSpeed)

    L_eff = Length + correctionFactor*radius;
    
    f = soundSpeed / (4*L_eff);

end
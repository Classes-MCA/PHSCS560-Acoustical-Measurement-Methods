function alpha = plotAbsorption(mic1,mic2,soundSpeed)

    [R1,R2,RWall,f] = reflectionCoefficient(mic1,mic2,5.00,soundSpeed);
    alpha = 1 - abs(R1).^2;
    d = norm(mic1.Location - mic2.Location);
    
    semilogx(f,alpha,'LineWidth',4,'DisplayName',strcat(mic1.Name," and ",mic2.Name,", d = ",num2str(d)," m"))
    hold on
    ylim([0.95,1])
    xlim([50,1500])
    grid on
    title('Absorption Coefficient')
    xlabel('Frequency (Hz)')
    ylabel('\alpha')
    legend('Show','Location','SouthWest')

end
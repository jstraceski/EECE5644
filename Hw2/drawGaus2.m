function drawGaus2(samples, mus, sigmas, priors, label)
    [data,cData,iData] = classGausGen(samples, 2, mus, sigmas, priors);

    subplot(2,2,1);
    hold on

    muA = sprintf('[%.1f; %.1f]', mus(:, 1));
    muB = sprintf('[%.1f; %.1f]', mus(:, 2));

    sigmaA = sprintf('[%.1f,%.1f; %.1f,%.1f]', sigmas(:, 1:2));
    sigmaB = sprintf('[%.1f,%.1f; %.1f,%.1f]', sigmas(:, 3:4));

    l1 = sprintf('Class A ($\\mu=%s, \\sigma=%s, prior=%.2f$)', ...
        muA, sigmaA, priors(1));
    l2 = sprintf('Class B ($\\mu=%s, \\sigma=%s, prior=%.2f$)', ...
        muB, sigmaB, priors(2));

    scatter(data(1, cData == 1), data(2, cData == 1), 'green');
    scatter(data(1, cData == 2), data(2, cData == 2), 'blue');
    legend(l1, l2, 'Interpreter', 'latex');
    
    tString = sprintf('Generated Gaussian Distribution, Question %s', label);
    
    title(tString,'Interpreter','latex');
    ylabel('$y$','Interpreter','latex');
    xlabel('$x$','Interpreter','latex');

    subplot(2,2,2);
    hold on

    class1 = (iData == 1) & (iData == cData);
    class2 = (iData == 2) & (iData == cData);
    error1 = (iData ~= cData);
    errors = sum(error1);

    scatter(data(1, class1), data(2, class1), 'green');
    scatter(data(1, class2), data(2, class2), 'blue');
    scatter(data(1, error1), data(2, error1), 'red');
    
    legend('Valid Class A' , 'Valid Class B', 'Classification Errors', 'Interpreter', 'latex');
    
    errorRate = errors/samples;
    t2String = sprintf( ...
        'Inferred Gaussian Distribution\nErrors=%d, P(Error)=%.4f', ...
        errors, errorRate);
    title(t2String,'Interpreter','latex');
    legend('Valid Class A' , 'Valid Class B', 'Classification Errors', 'Interpreter', 'latex');
    ylabel('$y$','Interpreter','latex');
    xlabel('$x$','Interpreter','latex');
    
    subplot(2,2,3);
    hold on
    X1 = data(:, cData == 1);
    X2 = data(:, cData == 2);
    
    Mu1 = mean(X1, 2);
    Mu2 = mean(X2, 2);
    
    S1 = (X1 - Mu1) * (X1 - Mu1)';
    S2 = (X2 - Mu2) * (X2 - Mu2)';
    
    SW = S1 + S2;
    SB = (Mu1 - Mu2) * (Mu1 - Mu2)';
    
    V = (inv(SW) * SB);
    W = V(:, 1);
    
    
    scales = (-5:0.1:5) * 25;
    
    scatter(data(1, cData == 1), data(2, cData == 1), 'green');
    scatter(data(1, cData == 2), data(2, cData == 2), 'blue');
    wplot = scales.*W + (Mu1 + Mu2) * 0.5;
    plot(wplot(1, :), wplot(2, :), 'black');
    
    title('LDA Vector Visualization','Interpreter','latex');
    legend('Generated Class A' , 'Generated Class B', 'LDA vector', 'Interpreter', 'latex');
    ylabel('$y$','Interpreter','latex');
    xlabel('$x$','Interpreter','latex');
    
    subplot(2,2,4);
    hold on
    fisher1 = W' * X1;
    fisher2 = W' * X2;
    
    scatter(fisher1, fisher1.^0 + 1, 'green');
    scatter(fisher2, fisher2.^0, 'blue');
    title('LDA Linear Seperation Visualization','Interpreter','latex');
    legend('Class A' , 'Class B', 'Interpreter', 'latex');
    
    ylabel('class seperation','Interpreter','latex');
    xlabel('LDA vector projection value','Interpreter','latex');
end
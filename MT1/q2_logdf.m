function [z,X,Y] = q2_logdf(ranges, landmarks, sig, n_sig)    
    % generate a grid of x and y values to test the density function
    space = 100;
    [X,Y] = meshgrid(linspace(-2,2,space));
    z = meshgrid(linspace(-2,2,space));
    
    for xC = 1:space
        for yC = 1:space
            % form a test point with linespace coordinates
            t = [X(xC,yC); Y(xC,yC)];
            
            % simplified log density function
            z(xC,yC) = -(t'*sig*eye(2)*t) ...
                -(1/n_sig)*sum((ranges - vecnorm(t - landmarks)).^2);
        end
    end
end
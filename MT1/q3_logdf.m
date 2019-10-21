function tMax = q3_logdf(x, y, sig, gamma)
    % bounded by y values 
    fmin = -min(y);
    fmax = max(y);
    div = (fmax - fmin)/15;
    
    pMax = NaN;
    
    % very dirty method to find the map parameters (dont look at it for too
    % long)
    for a = fmin:div:fmax
        for b = fmin:div:fmax
            for c = fmin:div:fmax
                for d = fmin:div:fmax
                    t = [a;b;c;d];
					p = -1/sig * sum((y' - t' * x').^2) ... 
                        -gamma * (t' * t);
                    
                    if isnan(pMax) || p > pMax
                        pMax = p;
                        tMax = t;
                    end
                end
            end
        end
    end
end
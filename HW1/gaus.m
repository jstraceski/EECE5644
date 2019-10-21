function out = gaus(mu, sigs, x) 
    out = (1/sqrt(2*pi*sigs)) * exp((x - mu).^2 * -(1.0/(2.0*sigs)));
end
function out = gausPdf(x, mu, sigma)
    out = (1/(2 * pi * (det(sigma)^0.5))) ...
        * exp(-(1/2) * diag((x - mu)' * inv(sigma) * (x - mu)));
end
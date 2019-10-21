function out = q1_logdf(x, mu, sigma, prior)
    out = -log(2 * pi * (det(sigma)^0.5)) ...
        -(1/2) * diag((x - mu)' * inv(sigma) * (x - mu)) + log(prior);
end
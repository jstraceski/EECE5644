function out = gausGen(N, n, mu, sigma)
    x = normrnd(0,1,n,N);
    out = sigma^(0.5) * x + repmat(mu, [1.0,N]);
end
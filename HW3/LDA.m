function [W, b] = LDA(data, d)
    X1 = data(:, d == 1);
    X2 = data(:, d == 2);

    Mu1 = mean(X1, 2);
    Mu2 = mean(X2, 2);

    S1 = (X1 - Mu1) * (X1 - Mu1)';
    S2 = (X2 - Mu2) * (X2 - Mu2)';

    SW = S1 + S2;
    SB = (Mu1 - Mu2) * (Mu1 - Mu2)';

    V = (inv(SW) * SB);
    W = V(:, 1);
    
    o1 = W' * X1;
    o2 = W' * X2;
    
    if mean(o1) < mean(o2)
        b = (max(o1) + min(o2))/2;
    else
        b = (min(o1) + max(o2))/2;
end
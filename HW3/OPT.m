function val = OPT(W, b, x)
    v = 1./(1 + exp((W' * x) + b));
    val = 1 - (max(v) - min(v));
    % optimize for seperation
end
clf
figure(1)
sig = 0.25; % object sigma
obj = mvnrnd([0;0], eye(2)*sig, 1)'; % object
for f = 1:4
    subplot(2,2,f);
    rangeTest(obj, sig, f);
    t = sprintf("Localization test K=%d", f);
    title(t);
end
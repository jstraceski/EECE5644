clf
% Generator Variables
sig = 0.25;
N = 10;
ex = 101;
B = 3;
gammaCount = 6;
report = zeros(gammaCount*2,5);
gammas = zeros(gammaCount*2,1);
index = 1;

% loop through gammaCount*2 different gamma values
for gammaIndex = -gammaCount:1:gammaCount
    if gammaIndex == 0 % skip over gamma of 0
        continue
    end
    
    index = index + 1;
    gamma = 10^gammaIndex;
    gammas(index) = gammaIndex;
    
    L = zeros(ex,1);
    % generate x, v, and y values as well as calculate the map
    for n = 1:ex
        x = rand(N,1) * 2 - 1;
        v = mvnrnd(0, sig, N);
        xmat = [x.^3 x.^2 x.^1 x.^0];
        w = mvnrnd([0; 0; 0; 0], eye(4)*gamma, 1)';
        y = xmat * w + v;
        out = q3_logdf(xmat, y, sig, gamma);
        L(n) = norm(xmat-out');
    end
    
    report(index, :) = [min(L), prctile(L,25), ...
        prctile(L,50), prctile(L,75), max(L)];
end

% display the data
hold on
plot(gammas(:), report(:,1), 'r')
plot(gammas(:), report(:,2), 'g')
plot(gammas(:), report(:,3), 'b')
plot(gammas(:), report(:,4), 'm')
plot(gammas(:), report(:,5), 'y')

ylabel('$L_2$ Error', 'Interpreter', 'Latex');
xlabel('$\gamma=10^x$', 'Interpreter', 'Latex');
title('Error rates over 100 trials');
legend('minimum', '25%', 'median', '75%', 'maximum');

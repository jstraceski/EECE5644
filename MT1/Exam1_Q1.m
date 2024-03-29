m(:,1) = [-1;0]; Sigma(:,:,1) = 0.1*[10 -4;-4,5]; % mean and covariance of data pdf conditioned on label 3
m(:,2) = [1;0]; Sigma(:,:,2) = 0.1*[5 0;0,2]; % mean and covariance of data pdf conditioned on label 2
m(:,3) = [0;1]; Sigma(:,:,3) = 0.1*eye(2); % mean and covariance of data pdf conditioned on label 1
classPriors = [0.15,0.35,0.5]; thr = [0,cumsum(classPriors)];
N = 10000; u = rand(1,N); L = zeros(1,N); x = zeros(2,N);

%% Decision matrix initalization
p = ones(1,N) * -10000; % probability matrix initalized to a negative value below the bounds of the pdf
d = zeros(1,N); % prob descision matrix 

%% Calculating distribution data
for l = 1:3
    indices = find(thr(l)<=u & u<thr(l+1)); % if u happens to be precisely 1, that sample will get omitted - needs to be fixed
    L(1,indices) = l*ones(1,length(indices));
    x(:,indices) = mvnrnd(m(:,l), Sigma(:,:,l), length(indices))';
end

%% Generating the descision matrix and error data
for l = 1:3 
    out = q1_logdf(x, m(:,l), Sigma(:,:,l), classPriors(l))';
    disp(out)
    d(out > p) = l;
    p = max(out, p);
end
totalE = length(L(L ~= d));

%% Plotting the generated data
figure(1), clf, colorList = 'rbg'; markerList = 'x+.';
axis equal, hold on;
for l1 = 1:3 
    for l2 = 1:3 
        scatter(x(1,L == l1 & d == l2),x(2, L == l1 & d == l2), ...
            'Marker', markerList(l2), 'MarkerEdgeColor', colorList(l1), ...
            'MarkerFaceColor', colorList(l1));
    end
end
%% Labels for plot 
l1 = sprintf('c = 1, r = 1, (N = %d)', length(L(L == 1 & d == 1)));
l2 = sprintf('c = 1, r = 2, (N = %d)', length(L(L == 1 & d == 2)));
l3 = sprintf('c = 1, r = 3, (N = %d)', length(L(L == 1 & d == 3)));
l4 = sprintf('c = 2, r = 1, (N = %d)', length(L(L == 2 & d == 1)));
l5 = sprintf('c = 2, r = 2, (N = %d)', length(L(L == 2 & d == 2)));
l6 = sprintf('c = 2, r = 3, (N = %d)', length(L(L == 2 & d == 3)));
l7 = sprintf('c = 3, r = 1, (N = %d)', length(L(L == 3 & d == 1)));
l8 = sprintf('c = 3, r = 2, (N = %d)', length(L(L == 3 & d == 2)));
l9 = sprintf('c = 3, r = 3, (N = %d)', length(L(L == 3 & d == 3)));


t  = sprintf('Classified Data\nClass Sizes (L=1: %d, L=2: %d, L=3: %d)\nTotal Misclassified=%d, Error Probability Estimate=%0.4f\nLegend Key (c=generated class, r=decided class)', ...
    length(L(L == 1)), length(L(L == 2)), length(L(L == 3)), totalE, totalE/N);

title(t,'Interpreter','latex');
legend(l1, l2, l3, l4, l5, l6, l7, l8, l9, 'Interpreter', 'latex');

%% Generating the confusion matrix
conf = zeros(3);
for actualL = 1:3
    for calcL = 1:3
        out = length(L(d == calcL & L == actualL));
        conf(calcL, actualL) = out;
    end
end

disp(conf)



clf
hold on

Mu = [-1 -1; 3 4];

Sig(:, :, 1) = [1.8, -1; -1, 0.8];
Sig(:, :, 2) = [0.8, 0.5; 0.5, 2];

P = [0.3 0.7];

gmm = gmdistribution(Mu, Sig, P);

[X, D] = random(gmm, 10000);

X = X';
D = D';

trainX = X(:, 1:(length(X)*0.6));
trainD = D(:, 1:(length(X)*0.6));

testX = X(:, (length(X)*0.6 + 1):end);
testD = D(:, (length(X)*0.6 + 1):end);

subplot(2,2,1);
hold on
scatter(X(1, D == 1), X(2, D == 1), 'green');
scatter(X(1, D == 2), X(2, D == 2), 'blue');
title('Distribution Visualization','Interpreter','latex');
legend('Class +' , 'Class -', 'Interpreter', 'latex');


subplot(2,2,2);
hold on
[W, b] = LDA(trainX, trainD);

nOPT = @(s)OPT(W * s, b * s, trainX);
x = fminsearch(nOPT, 1);
% since the midpoint is already at y(x) = 0.5 an the W vector already
% separates the data all we need to optimize is the scale of W and b.

f = @(xd)1./(1 + exp(((W * x)' * xd) + b));

hold on

c1 = testX(:, testD == 1);
c2 = testX(:, testD == 2);

trueV1 = f(c1) > 0.5;
trueV2 = f(c2) < 0.5;
falseV1 = f(c1) < 0.5;
falseV2 = f(c2) > 0.5;

fisher1 = W' * c1(:, trueV1);
fisher2 = W' * c2(:, trueV2);
fisherE1 = W' * c1(:, falseV1);
fisherE2 = W' * c2(:, falseV2);

scatter(fisher1, f(c1(:, trueV1)), 'green');
scatter(fisher2, f(c2(:, trueV2)), 'blue');
scatter(fisherE1, f(c1(:, falseV1)), 'red');
scatter(fisherE2, f(c2(:, falseV2)), 'red');

ec = sum(falseV1) + sum(falseV2);
er = ec / length(testX);

t = sprintf('Result of the trained LDA classifier on test data\nError count: %d, Error rate %.3f', ec, er);
title(t,'Interpreter','latex');
legend('Class +' , 'Class -', 'Error', 'Interpreter', 'latex');
xlabel('Class seperation along the LDA vector', 'Interpreter', 'latex');
ylabel('$y(x)$ probability', 'Interpreter', 'latex');

subplot(2,2,3);
hold on

[W2, b2] = LDA(trainX, trainD);

c1 = testX(:, testD == 1);
c2 = testX(:, testD == 2);

fd = W2' * testX + b2;

cf1 = fd < 0 & testD == 1 ;
cf2 = fd > 0 & testD == 2 ;

ff1 = fd >= 0 & testD == 1;
ff2 = fd <= 0 & testD == 2;

scatter(fd(cf1), fd(cf1).^0 + 1, 'green');
scatter(fd(cf2), fd(cf2).^0, 'blue');
scatter(fd(ff2), fd(ff2).^0 + 1, 'red');
scatter(fd(ff1), fd(ff1).^0, 'red');

ec2 = sum(ff1) + sum(ff2);
er2 = ec2 / length(testX);

t = sprintf('Basic LDA Linear Seperation Visualization\nError count: %d, Error rate %.3f', ec2, er2);
title(t,'Interpreter','latex');
legend('Class +' , 'Class -', 'Error', 'Interpreter', 'latex');

subplot(2,2,4);
hold on

% matlab map classifier using all avalible data
[idx,nlogL,P] = cluster(gmm, testX');
idx = idx';

map1 = (idx == testD) & (testD == 1);
map2 = (idx == testD) & (testD == 2);

falseMap1 = idx ~= testD;

scatter(testX(1, map1), testX(2, map1), 'green');
scatter(testX(1, map2), testX(2, map2), 'blue');
scatter(testX(1, falseMap1), testX(2, falseMap1), 'red');

ec3 = sum(falseMap1);
er3 = ec3 / length(testX);

t = sprintf('Map Estimation Visualization\nError count: %d, Error rate %.4f', ec3, er3);
title(t,'Interpreter','latex');
legend('Class +' , 'Class -', 'Error', 'Interpreter', 'latex');



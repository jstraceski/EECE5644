
%% Case 1

clf
figure(1);
identity = eye(2);
drawGaus2(400, [[0;0], [3;3]], [identity, identity], [0.5, 0.5], '2.1');

figure(2);
cv = [3,1;1,0.8];
drawGaus2(400, [[0;0], [3;3]], [cv, cv], [0.5, 0.5], '2.2');

figure(3);
drawGaus2(400, [[0;0], [2;2]], [[2,0.5;0.5,1], [2,-1.9;-1.9,5]], ...
    [0.5, 0.5], '2.3');

figure(4);
priors = [0.05, 0.95];
drawGaus2(400, [[0;0], [3;3]], [identity, identity], priors, '2.4');

figure(5);
cv = [3,1;1,0.8];
drawGaus2(400, [[0;0], [3;3]], [cv, cv], priors, '2.5');

figure(6);
drawGaus2(400, [[0;0], [2;2]], [[2,0.5;0.5,1], [2,-1.9;-1.9,5]], ...
    priors, '2.6');
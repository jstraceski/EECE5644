x = [-10:0.01:10];

mu = 1;
sigs = 2;

f1 = gaus(0, 1, x);
f2 = gaus(mu, sigs, x);

l = sqrt(sigs) * exp(1/2 * (((x - mu).^2 / sigs) - x.^2)) >= 1;
fc = f1 + f2;

rev1 = f1./fc; % for f1 the p(L = 1) = 1  
rev2 = f2./fc; % then we divide by the total probability of x
% dividing by the total works because the priors are equal and the x values
% are combined.

% find the point at which the classification changes
d = (l - circshift(l, -1)) > 0;
d = d * 0.5;

clf
hold on
plot(x, f1, 'red');
plot(x, f2, 'green');
plot(x, d, 'blue');
plot(x, rev1, 'yellow');
plot(x, rev2, 'black');

grid on
grid minor
legend('$p(x|L=1)$','$p(x|L=2)$','descision boundary','$p(L=1|x)$','$p(L=2|x)$','Interpreter','latex')
title('Probabilities of input $x$ for Question 4.2','Interpreter','latex');
ylabel('probability','Interpreter','latex');
xlabel('$x$','Interpreter','latex');
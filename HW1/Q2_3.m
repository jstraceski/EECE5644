a1 = 0;
b1 = 1;
a2 = 1;
b2 = 2;

x = (-5:0.01:5);
f = (abs(x - a2)/b2) - (abs(x - a1)/b1);

plot(x, f);
ylim([-5 5])
grid on
grid minor
title('log-likelihood-ratio on input $x$ for Question 2.3','Interpreter','latex');
ylabel('$\ell$(x)','Interpreter','latex');
xlabel('$x$','Interpreter','latex');
clf
f = @(a)100*(a(2) - a(1)^2)^2 + (1 - a(1))^2;
hold on
for x = 0:0.05:1
   for y = 0:0.05:1
       c = f([x, y]);
       scatter3(x, y, c);
   end
end

x = fminsearch(f, [0, 0]);

scatter3(x(1), x(2), 50)
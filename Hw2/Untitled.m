
clf
hold on

v = [0; 1];
p = [0; 0];

dline(p, (p + (v * 190)));
p = p + (v * 190);

disp(p);

v = [1; 0]; %right
dline(p, p + (v * 0.8 * 5280));
p = p + (v * 0.8* 5280);

v = [0; -1]; %down
dline(p, p + (v * 0.2* 5280));
p = p + (v * 0.2* 5280);
% 
v = [1; 0]; %right
dline(p, p + (v * 276));
p = p + (v * 276);

v = [0; 1]; %up
dline(p, p + (v * 75));
p = p + (v * 75);

v = [1; 0]; %right
dline(p, p + (v * 26));
p = p + (v * 26);

v = [0; 1]; %up
dline(p, p + (v * 95));
p = p + (v * 95);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v = [0; 1];
p = [0; 0];


dline(p, (p + (v * 190)));
p = p + (v * 190);

v = [-1; 0]; %left
dline(p, p + (v * 1.2* 5280));
p = p + (v * 1.2* 5280);

v = [0; 1]; %up
dline(p, p + (v * 404));
p = p + (v * 404);
% 
v = [1; 0]; %right
dline(p, p + (v * 482));
p = p + (v * 482);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v = [0; 1];
p = [0; 0];


dline(p, (p + (v * 190)));
p = p + (v * 190);

v = [1; 0]; %right
dline(p, p + (v * 0.4* 5280));
p = p + (v * 0.4);

v = [0; -1]; %down
dline(p, p + (v * 0.5* 5280));
p = p + (v * 0.5);
% 
v = [1; 0]; %right
dline(p, p + (v * 0.2* 5280));
p = p + (v * 0.2);

v = [0; -1]; %down
dline(p, p + (v * 0.2* 5280));
p = p + (v * 0.2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v = [0; 1];
p = [0; 0];


dline(p, (p + (v * 190)));
p = p + (v * 190);

v = [1; 0]; %right
dline(p, p + (v * 0.4* 5280));
p = p + (v * 0.4);

v = [0; -1]; %down
dline(p, p + (v * 0.5* 5280));
p = p + (v * 0.5);
% 
v = [1; 0]; %right
dline(p, p + (v * 0.2* 5280));
p = p + (v * 0.2);

v = [0; -1]; %down
dline(p, p + (v * 0.3* 5280));
p = p + (v * 0.3);

v = [1; 0]; %right
dline(p, p + (v * 161));
p = p + (v * 161);

v = [0; -1]; %right
dline(p, p + (v * 194));
p = p + (v * 194);
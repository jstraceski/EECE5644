function rangeTest(obj, sig, k)
r = 2; % unit circle radius
n_sig = 0.1; % noise sigma

landmarks = zeros(2, k);
ranges = zeros(1,k);

% generate k landmarks and k range measurements
angle = 0;
for n = 1:k
    % equidistant points on a circle
    landmarks(1:2, n) = [r * cos(angle); r * sin(angle)]; 
    angle = angle + (2*pi/k); 
    
    ranges(n) = -1; % make sure the range is positive
    while ranges(n) < 1
        dti = vecnorm(obj - landmarks(1:2, n));
        ranges(n) = dti + mvnrnd(0, n_sig, 1);
    end
end
 
% generate x y and contour data for the log density function
[Z,X,Y] = q2_logdf(ranges, landmarks, sig, n_sig);

% contour calculations
zmin = min(Z(:));
zmax = max(Z(:));
zinc = (zmax - zmin) / 20;
zlevs = zmin:zinc:zmax;

hold on
grid on;
axis equal;
% draw data
contour(X,Y,Z, zlevs)
scatter(landmarks(1, :), landmarks(2, :), 'o');
scatter(obj(1, :), obj(2, :), 'x');
end


clf
dataTrain = xlsread('Q2train.csv');
dataTest = xlsread('Q2test.csv');

figure(1);
plot(dataTrain(:, 2), dataTrain(:, 3), 'b--o')
title('noisy path')

T = 2;

K = det(cov(y'));
S = det(cov(y'));
% 
% o1 = kalman(dataTrain, K, S, T);
% o2 = estimate2(dataTest, T);

e = zeros(3, 3);
delim = 0.1;

for kv = 1:3
   for sv = 1:3 
       etot = 0;
       for off = 0:9
           train = dataTrain((1 + (off * 10)):((off + 1) * 10), :);
           test = dataTest((1 + (off * 10)):((off + 1) * 10), :);
           etot = etot + tFunc(train, test, K + kv * delim, S + sv * delim, off);
       end
       e(kv, sv) = etot/10;
   end
end
figure(2);
hold on
mesh(e);
xlabel('K')
ylabel('S')
disp(K + 3 * delim)
disp(S + 1 * delim)

figure(3);
hold on
o1 = kalman(dataTrain, K + 3 * delim, S + 1 * delim, T);
plot(dataTrain(:, 2), dataTrain(:, 3), 'bo')
legend('raw data', 'predicted path')
plot(o1(1, :), o1(2, :), 'r--o')

function err = tFunc(train, test, K, S, d)
    T = 2;
    o1 = kalman(train, K, S, T);
    o2 = estimate2(test, T);
    err = comp(o1, o2, d);
end

function err = comp(d1, d2, d)
    errs = 0;
    for t = 2:19
        errs = errs + norm(d1(:, t) - d2(:, t));
    end
    err = errs/18;
end

%% kalman method
function ye = kalman(data, K, S, T)

    % The A matrix is designed to preform two acceleration state
    % calculations for the two position values in the data.
    A = [[1, T, 1/2 * T^2, 0, 0, 0]; [0, 1, T, 0, 0, 0]; [0, 0, 1, 0, 0, 0]; [0, 0, 0, 1, T, 0.5*T^2]; [0, 0, 0, 0, 1, T]; [0,0,0,0,0,1]];
    % The C matrix is formatted to extract on the position data from the
    % overall data matrix
    C = [[1,0,0,0,0,0]; [0,0,0,1,0,0]];

    x = zeros(length(data), 6)';
    ye = zeros(length(data)*T - 1, 2)';
    y = data(:, 2:3)';

    % set the first element to just be the starting position
    x(:,1) = C'*y(:, 1);
    % initalize p to the identity matrix
    P=eye(length(x(:, 1)));
    
    % Q and R have to follow the dimensions of thier respective data sets
    Q = eye(length(x(:, 1))) * K;
    R = eye(length(y(:, 1))) * S;

    for i = 1:(length(data) - 1)
        x(:, i + 1) = A*x(:, i); % preform motion calculations 
        P = A*P*A' + Q; % adjust the priori factor based on the covariance matrix and physics matrix

        G = P*C'/(C*P*C'+R); % calculate the kalman gain factor
        % estimate the next state based on the gain and observed position
        x(:, i + 1) = x(:, i + 1) + G*(y(:, i + 1)-C*x(:, i + 1));  % x[n+1|n]
        P = P-G*C*P; % re-evaluate the priori based on the gain 
    end
    
    % estimate the total data based on the fitted values.
    ye = estimate(x, data, C, T);
end

%% helper methods
function ye = estimate2(data, T)
    ye = zeros(length(data(:, 1))*T - 1, 2)';
    
    y = data(:, 2:3)';
    
    offset = min(data(:, 1));
    lastV = max(data(:, 1));

    for n = 2:(lastV - offset)
        xi = floor(n/2);
        if mod(n, 2) == 0
            ye(:, n) = y(:, xi);
        else
            p1 = y(:, xi);
            p2 = y(:, xi + 1);
            ye(:, n) = (p1 + p2) / 2;
        end
    end
end

function ye = estimate(x, data, C, T)
    ye = zeros(length(data(:, 1))*T - 1, 2)';
    
    offset = min(data(:, 1));
    lastV = max(data(:, 1));
    
    for n = 1:(lastV - offset)
        xi = floor(n/2);
        if mod(n, 2) == 1
            ye(:, n) = C*x(:, xi + 1);
        else
            p1 = C*x(:, xi);
            p2 = C*x(:, xi + 1);
            ye(:, n) = (p1 + p2) / 2;
        end
    end
end
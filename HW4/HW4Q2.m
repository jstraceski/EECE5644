clf

%% Generate test data
n = 1000;
priors = [0.35, 0.65];
[tData, tClass] = genData(1000, priors);

disp('generated test data');

%% Plot test data
figure(1);
hold on
scatter(tData(tClass == '1', 1), tData(tClass == '1', 2), 'red');
scatter(tData(tClass == '-1', 1), tData(tClass == '-1', 2), 'blue');
hold off
title('Generated Test Data');
legend('class +1', 'class -1');

%% Train Linear Classifier
cMax = 3;
vals = cMax * 2 + 1;
eArr = zeros(vals, 1);
cArr = zeros(vals, 1);

eArr2 = zeros(vals, vals);
cArr2 = zeros(vals, vals);
sArr2 = zeros(vals, vals);

for pVal = -cMax:cMax
    C = 10.^(pVal);
    
    ind = pVal + cMax + 1;
    cArr(ind) = C;
    
    LinearSVM = fitcsvm(tData, tClass, 'ClassNames', {'-1','1'}, 'Solver', 'ISDA', 'boxconstraint', C);
    kloss = kfoldLoss(crossval(LinearSVM));
    eArr(ind) = kloss;
end

disp('calculated min linear SVM');

%% Plot Linear classifier progress
figure(2);
scatter(cArr, eArr);
[mVal, mInd] = min(eArr);
set(gca, 'XScale', 'log')
xlabel('Box Constraint (C)');
ylabel('Estimated Error');
title(sprintf('Crossval Graph\nMinimum Error: %d\nC = %f', mVal, cArr(mInd)));

%% Train Gausian classifier
for pVal = -cMax:cMax
    for sVal = -cMax:cMax
        C = 10.^(pVal);
        sig = 10.^(sVal);

        ind1 = pVal + cMax + 1;
        ind2 = sVal + cMax + 1;

        GausianSVM = fitcsvm(tData, tClass, 'ClassNames', {'-1','1'}, 'KernelFunction', 'rbf', 'KernelScale', sig, 'boxconstraint', C);% 'OptimizeHyperparameters', {'BoxConstraint'});
        kloss = kfoldLoss(crossval(GausianSVM));

        eArr2(ind1, ind2) = kloss;
        cArr2(ind1, ind2) = C;
        sArr2(ind1, ind2) = sig;
    end
end

disp('calculated min gausian SVM');

%% Plot Gausian Training Data
figure(3);
mesh(cArr2, sArr2, eArr2, 'FaceAlpha','0.5');
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('Box Constraint (C)');
ylabel('Kernel Scale (sigma)');
zlabel('Estimated Error');

[mVal2, mInd2] = min(eArr2, [], 'all', 'linear');
title(sprintf('Crossval Graph\nMinimum Error: %f\n C = %f, sig = %f', mVal2, cArr2(mInd2), sArr2(mInd2)));

%% Create final classifiers with optimized values
MinLinearSVM = fitcsvm(tData, tClass, 'Solver', 'ISDA', 'boxconstraint', cArr(mInd), 'ClassNames',{'-1','1'});
MinGausianSVM = fitcsvm(tData, tClass, 'KernelFunction', 'rbf', 'KernelScale', sArr2(mInd2), 'boxconstraint', cArr2(mInd2), 'ClassNames',{'-1','1'});
  
%% Plot Linear classifier on test data
figure(4);
subplot(1, 2, 1);

mtc = string(predict(MinLinearSVM, tData));

hold on
scatter(tData(mtc == '1', 1), tData(mtc == '1', 2), 'red');
scatter(tData(mtc == '-1', 1), tData(mtc == '-1', 2), 'blue');
mis = sum(mtc ~= tClass');
error = mis/length(mtc);

title(sprintf('Linear Classified Test Data\nMissclassified = %f, Error = %f', mis, error));
legend('class +1', 'class -1');

%% Plot Gausian classifier on test data

subplot(1, 2, 2);

mtc2 = string(predict(MinGausianSVM, tData));

hold on
scatter(tData(mtc2 == '1', 1), tData(mtc2 == '1', 2), 'red');
scatter(tData(mtc2 == '-1', 1), tData(mtc2 == '-1', 2), 'blue');

mis2 = sum(mtc2 ~= tClass');
error2 = mis2/length(mtc2);
title(sprintf('Gausian Classified Test Data\nMissclassified = %f, Error = %f', mis2, error2));
legend('class +1', 'class -1');

%% generate new data 
[nData, nClass] = genData(1000, priors);

%% classify new data using trained svm's
figure(5);
subplot(1, 2, 1);

mnc = string(predict(MinLinearSVM, nData));

hold on
scatter(nData(mnc == '1', 1), nData(mnc == '1', 2), 'red');
scatter(nData(mnc == '-1', 1), nData(mnc == '-1', 2), 'blue');
nmis = sum(mnc ~= nClass');
nerror = nmis/length(mnc);

title(sprintf('Linear Classified New Data\nMissclassified = %f, Error = %f', nmis, nerror));
legend('class +1', 'class -1');


subplot(1, 2, 2);

mnc2 = string(predict(MinGausianSVM, nData));

hold on
scatter(nData(mnc2 == '1', 1), nData(mnc2 == '1', 2), 'red');
scatter(nData(mnc2 == '-1', 1), nData(mnc2 == '-1', 2), 'blue');

nmis2 = sum(mnc2 ~= nClass');
nerror2 = nmis2/length(mnc2);
title(sprintf('Gausian Classified New Data\nMissclassified = %f, Error = %f', nmis2, nerror2));
legend('class +1', 'class -1');

%% data generation function
function [data, class] = genData(n, priors)
    data = zeros(n, 2);
    class = strings(1, n);

    for i = 1:n
        d = rand();

        if d > priors(1)
            class(i) = '1';

            a = ((rand() * 2) - 1) * pi;
            r = rand() + 2;

            [x, y] = pol2cart(a, r);
            data(i, :) = [x, y];
        else
            class(i) = '-1';
            data(i, :) = mvnrnd([0; 0], eye(2));
        end
    end
end
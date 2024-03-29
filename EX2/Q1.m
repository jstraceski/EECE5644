clf
syms x y f

T = xlsread('Q1.csv');

%partA(T);
partB(T);
partC(T);
%partD(T);


function partA(T)
    figure(1);
    hold on
    grid on
    axis square
    
    neg = T(T(:, 3) == -1, 1:2);
    pos = T(T(:, 3) == 1, 1:2);
    
    scatter(neg(:, 1), neg(:, 2), 'red', 'o');
    scatter(pos(:, 1), pos(:, 2), 'black', 'x');
    legend('-1', '1');
end

function partB(T)
    
    len = length(T);
    testT = T(1:floor(len*0.1), :);
    trainT = T((floor(len*0.1) + 1):end, :);
    
    tests = {@(x,y,f)x > f, @(x,y,f)y > f,};
    o = genTree([-1 1], trainT, tests);

    figure(2);
    hold on
    
    drawTree(o);

    c = classify(o, testT);
    disp(genConf(o, testT, c));
    
    figure(3);
    hold on
    grid on
    axis square

    c = classify(o, T);
    L = T(:, 3);

    neg = T(c == -1 & L == -1, 1:2);
    pos = T(c == 1 & L == 1, 1:2);
    err = T(c ~= L, 1:2);

    scatter(neg(:, 1), neg(:, 2), 'red', 'o');
    scatter(pos(:, 1), pos(:, 2), 'black', 'x');
    scatter(err(:, 1), err(:, 2), 'green', '.');
    legend('-1', '1', 'mislabeled');

    drawBounds(o, [-4, 4], [-4, 4]);
end

function partC(T)
    len = length(T);
    testT = T(1:floor(len*0.1), :);
    tests = {@(x,y,f)x > f, @(x,y,f)y > f};
    
    roots = cell(7);
    errs = zeros(7, 1);

    for n = 1:7
        trainT = T((floor(len*0.1) + 1):end, :);
        samp = datasample(trainT, length(trainT(:, 1)));
        root = genTree([-1 1], samp, tests);
        
        c = classify(root, samp);
        err = sum(c ~= samp(:, 3)) / length(samp);
        
        roots{n} = root;
        errs(n) = err;
    end
    [~, idx] = min(errs);
    
    root = roots{idx};
    
    c = classify(root, testT);
    genConf(root, testT, c)
    
    c = classify(root, T);
    L = T(:, 3);

    neg = T(c == -1 & L == -1, 1:2);
    pos = T(c == 1 & L == 1, 1:2);
    err = T(c ~= L, 1:2);
    
    figure(4);
    hold on
    grid on
    axis square
    
    scatter(neg(:, 1), neg(:, 2), 'red', 'o');
    scatter(pos(:, 1), pos(:, 2), 'black', 'x');
    scatter(err(:, 1), err(:, 2), 'green', '.');
    legend('-1', '1', 'mislabeled');

    drawBounds(root, [-4, 4], [-4, 4]);
end

function partD(T)
    classes = [-1 1];
    len = length(T);
    testT = T(1:floor(len*0.1), :);
    trainT = T((floor(len*0.1) + 1):end, :);
    tests = {@(x,y,f)x > f, @(x,y,f)y > f};
    
    roots = cell(7);
    errs = zeros(7, 1);
    ams = zeros(7, 1);
    obvs = ones(length(trainT), 1); %* 1/length(trainT(:, 1));

    for n = 1:7
        
        [samp, idxs] = datasample(trainT, length(trainT(:, 1)), 'Weights', obvs);
        root = genTree(classes, samp, tests);
        
        c = classify(root, samp);
        
        errs2 = zeros(length(idxs), 1);
        wts = zeros(length(idxs), 1);
        
        for i = 1:length(idxs)
            idx = idxs(i);
            errs2(i) = (c(i) ~= samp(i, 3)) * obvs(idx);
            wts(i) = obvs(idx);
        end
        
        err = sum(errs2)/sum(wts);
        
        am = 0;
        if (err ~= 0)
            am = 0.01 * log((1 - err)/err);
        end
        
        for i = 1:length(idxs)
            idx = idxs(i);
            obvs(idx) = obvs(idx) * exp(am * (c(i) ~= samp(i, 3)));
        end
        
        for i = 1:length(obvs)
            obvs(i) = obvs(i)/sum(obvs);
        end
        
        ams(n) = am;
        roots{n} = root;
        errs(n) = err;
    end
    [~, idx] = min(errs);
    
    disp(errs);
    
    root = roots{idx};
    
    c = zeros(length(testT), 1);
    c1 = zeros(length(testT), 1);
    c2 = zeros(length(testT), 1);
    for n = 1:7
        d = classify(roots{idx}, testT);
        c1 = c1 + (d == 1) * ams(n);
        c2 = c2 + (d == -1) * ams(n);
    end
    
    c(c1 >= c2) = 1;
    c(c1 < c2) = -1;
    
    genConf(root, testT, c)
    
    c = classify(root, T);
    L = T(:, 3);

    neg = T(c == -1 & L == -1, 1:2);
    pos = T(c == 1 & L == 1, 1:2);
    err = T(c ~= L, 1:2);
    
    figure(5);
    hold on
    grid on
    axis square
    
    scatter(neg(:, 1), neg(:, 2), 'red', 'o');
    scatter(pos(:, 1), pos(:, 2), 'black', 'x');
    scatter(err(:, 1), err(:, 2), 'green', '.');
    legend('-1', '1', 'mislabeled');

    drawBounds(root, [-4, 4], [-4, 4]);
end

function conf = genConf(root, data, c)
    L = data(:, 3);
    conf = zeros(2);

    for aL = 1:2
        for cL = 1:2
            aC = root.classes(aL);
            cC = root.classes(cL);

            conf(cL, aL) = length(data(c == aC & L == cC, 1));
        end
    end
end

function error(root)
    syms x y f
    [nodes, labels] = gNodes(root, 1);

    nodes = [0, nodes];
    labels = [sprintf('%s, f=%f', ...
        root.test(x, y, f), root.value), labels];
    
    treeplot(nodes);
    [x, y] = treelayout(nodes);

    for i=1:length(x)
        text(x(i),y(i), labels{i})
    end
end

function drawTree(root)
    syms x y f
    [nodes, labels] = gNodes(root, 1);

    nodes = [0, nodes];
    labels = [sprintf('%s, f=%f', ...
        root.test(x, y, f), root.value), labels];
    
    treeplot(nodes);
    [x, y] = treelayout(nodes);

    for i=1:length(x)
        text(x(i),y(i), labels{i})
    end
end

function drawBounds(tree, xc, yc)
    v = tree.value;
    if (tree.tIdx == 1)
        line([v v],  yc)
    elseif (tree.tIdx == 2)
        line(xc, [v v])
    end
    
    if (~isempty(tree.left))
        drawBounds(tree.left, xc, yc)
        drawBounds(tree.right, xc, yc)
    end
end

function o = classify(tree, data)
    o = ones(length(data(:, 1)), 1);
    if (~isempty(tree.left))
        d = tree.test(data(:, 1), data(:, 2), o * tree.value);
        o(d == 1) = classify(tree.left, data(d == 1, :));
        o(d == 0) = classify(tree.right, data(d == 0, :));
    else 
        o = o * tree.class;
    end
end

function [nodes, labels] = gNodes(tree, parent)
    syms x y f
    
    nodes = [];
    labels = {};
    
    if (~isempty(tree.left))
        nodes = [nodes, parent];
        [nodesA, labelA] = gNodes(tree.left, parent + 1);
        nodes = [nodes, nodesA];
        
        if (~isempty(tree.left.test))
            labels = [labels sprintf('%s, f=%f', ...
                tree.left.test(x, y, f), tree.left.value) labelA];
        else
            labels = [labels sprintf('%d', tree.left.class) labelA];
        end
        
        
        nodes = [nodes, parent];
        shift = length(nodes) - 1;
        
        [nodesB, labelB] = gNodes(tree.right, parent + 1);
        nodesB = nodesB + shift;
        nodes = [nodes, nodesB];
        
        if (~isempty(tree.right.test))
            labels = [labels sprintf('%s, f=%f', ...
                tree.right.test(x, y, f), tree.right.value) labelB];
        else
            labels = [labels sprintf('%d', tree.right.class) labelB];
        end
    end 
end

function [tOut] = genTree(classes, data, tests)
    root = tree;
    impurity = 1;
    nodes = 1;
    leaf = root;
    leaf.classes = classes;
    
    while nodes < 11
        e = entropy(classes, data);
        leaf.data = data;
        leaf.num = e;
        
        [oData, fData] = gain(e, classes, data, tests);
        [mval, idx] = max(oData, [], [1 2], 'linear');

        tIdx = 1 + floor((idx - 1) / length(oData));
        vIdx = 1 + mod((idx - 1), length(oData));

        cTest = tests{tIdx};
        cVal = fData(vIdx, tIdx);

        d = cTest(data(:, 1), data(:, 2), cVal * ones(length(data(:,1)), 1));

        leaf.test = cTest;
        leaf.tIdx = tIdx;
        leaf.value = cVal;
        leaf.num = mval;
        
        leaf.left = tree;
        leaf.left.data = data(d == 1, :);
        leaf.left.parent = leaf;
        leaf.left.class = mode(data(d == 1, 3));
        
        leaf.right = tree;
        leaf.right.data = data(d == 0, :);
        leaf.right.parent = leaf;
        leaf.right.class = mode(data(d == 0, 3));
        
        nodes = nodes + 2;
        
        [leafs, impurity] = fLeafs(root, classes);
        [m, idx] = max(impurity);
        
        leaf = leafs(idx);
        data = leaf.data;
        
    end
    tOut = root;
end

function [leafs, imps] = fLeafs(tree, classes)
    leafs = [];
    imps = [];
    
    if (~isempty(tree.left))
        [leafA, impsA] = fLeafs(tree.left, classes);
        [leafB, impsB] = fLeafs(tree.right, classes);
        
        leafs = [leafs, leafA, leafB];
        imps = [imps, impsA, impsB];
    else
        gini = 0;
        for class = classes
            p = (sum(tree.data(:, 3) == class) / length(tree.data(:,1)));
            gini = gini + (p * (1 - p));
        end
        tree.o = gini;
        leafs = [tree];
        imps = [gini];
    end
end

function [m, out] = findLeaf(root, classes)
    leafs = [];
    impurity = [];
    
    node = root;
    left = true;
    
    while ~isempty(node)
        if ~isempty(node.left)
            if (left)
                node = node.left;
            else
                node = node.right;
                left = true;
            end
        else
            gini = 0;
            for class = classes
                p = (sum(node.data(:, 3) == class) ...
                    / length(node.data(:,1)));
                
                gini = gini + (p * (1 - p));
            end
            
            leafs = [leafs node];
            impurity = [impurity gini];
            
            if left
                node = node.parent;
                left = false;
            else
                node = node.parent;
                if ~isempty(node)
                    node = node.parent;
                end
            end
        end
    end
    
    [m, idx] = max(impurity);
    out = leafs(idx);
end

function [o, v] = gain(e, classes, data, tests)
    syms x y f 
    
    divs = 400;
    
    sVal = min(data(:, 1:2), [], [1 2]);
    eVal = max(data(:, 1:2), [], [1 2]);
    delim = (eVal - sVal)/divs;
    
    gVal = zeros(divs, length(tests));
    vVal = zeros(divs, length(tests));
    
    dLen = length(data(:, 1));
    
    for item = 1:divs
        val = sVal + item * delim;
        
        for index = 1:length(tests)
            d = tests{index};
            l = d(data(:, 1), data(:, 2), val * ones(dLen, 1));
            total = 0;
            
            if (~isempty(data(l == 1)))
                nRatio1 = length(data(l == 1, 1))/dLen;
                total = total + nRatio1 * entropy(classes, data(l==1, :));
            end
            
            if (~isempty(data(l == 0)))
                nRatio2 = length(data(l == 0, 1))/dLen;
                total = total + nRatio2 * entropy(classes, data(l==0, :));
            end
            
            gVal(item, index) = e - total;
            vVal(item, index) = val;
        end
    end
    
    o = gVal;
    v = vVal;
end

function o = entropy(classes, data)
    total = 0;
    
    for class = classes
        cCount = sum(data(:, 3) == class);
        f = cCount / length(data);
        
        if (f ~= 0)
            total = total + (f * log(f));
        end
    end
    
    o = -total;
end


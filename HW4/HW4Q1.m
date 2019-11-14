A = imread("colorPlane.jpg");
B = imread("colorBird.jpg");

clf

[pixelDataA, pixelsA, widthA, heightA] = extractData(A);
[pixelDataB, pixelsB, widthB, heightB] = extractData(B);

offset = 1;
for f = 1:4
    figure(f);
    
    subplot(3, 2, 1);
    image(A);
    title('Base Image');
    drawColData(pixelDataA, pixelsA, widthA, heightA, offset + f, 1, 2);
    
    subplot(3, 2, 2);
    image(B);
    title('Base Image');
    drawColData(pixelDataB, pixelsB, widthB, heightB, offset + f, 2, 2);
end
    
function drawColData(pixelData, pixels, width, height, groups, col, cols)
    [idx,~] = kmeans(pixelData, groups);
    cImg = clusterImg(idx, pixels, width, height);

    GMM = fitgmdist(pixelData, groups);
    idx2 = cluster(GMM, pixelData);
    cImg2 = clusterImg(idx2, pixels, width, height);
    
    lNames = strings(3);
    gColor = zeros(groups, 3);
    gsc = 1.0/max(idx);
    
    for g = 1:groups
        lNames(g) = sprintf('Group %d', g);
        gColor(g, :) = [g - 1, g - 1, g - 1] * gsc;
    end
    
    subplot(3, cols, col + cols);
    image(cImg);
    
    hold on;
    % https://www.mathworks.com/matlabcentral/answers/415096-legend-for-a-image
    for ii = 1:groups
      scatter([],[],1, gColor(ii,:), 'filled', 'DisplayName', lNames{ii});
    end
    hold off;
    legend();
    
    title(sprintf('K-means Grouping\n With K = %d', groups));
    
    subplot(3, cols, col + cols*2);
    image(cImg2);
    
    hold on;
    for ii = 1:groups
      scatter([],[],1, gColor(ii,:), 'filled', 'DisplayName', lNames{ii});
    end
    hold off;
    legend();
    
    title(sprintf('GMM Grouping\n With %d Groups', groups));
end

function [pixelData, pixels, width, height] = extractData(A)
    width = length(A(:,1,1));
    height = length(A(1,:,1));
    pixels = width * height;
    nImg = single(A);
    
    minCol = min(nImg(:, :, 1:3), [], [1,2]);
    nImg(:, :, 1:3) = nImg(:, :, 1:3) - minCol;
    
    maxCol = max(nImg(:, :, 1:3), [], [1,2]);
    nImg(:, :, 1:3) = nImg(:, :, 1:3)./maxCol;
    
    pixelData = zeros(pixels, 5);

    for ind = 1:pixels
        x = 1 + mod(ind - 1, width );
        y = ceil(ind / width);

        color = squeeze(nImg(x, y, 1:3))';
        pos = [(x - 1) / (width - 1), (y - 1) / (height - 1)];
        
        data = cat(2, color, pos);
        pixelData(ind, :) = data;
    end
end

function outImg = clusterImg(idx, pixels, width, height)
    outImg = zeros(width, height, 3);
    gsc = 1.0/max(idx);
    
    for ind = 1:pixels
        x = 1 + mod(ind - 1, width);
        y = ceil(ind / width);
        k = idx(ind) - 1;
        outImg(x, y, :) = [k, k, k] * gsc;
    end
end


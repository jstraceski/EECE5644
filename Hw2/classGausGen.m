function [data,cData,pdfData] = classGausGen(samples, n, mus, sigmas, priors)
    data = repmat(zeros(n, 1), [1,samples]);
    cData = zeros(samples, 1);
    pdfData = zeros(samples, 1);
    classes = length(priors); % use the rank of the prior list to find 
    % how many classes there are
    
    for i = 1:1:samples
        class = 1;
        offset = 0;
        r = rand();
        
        % map a random value to prior ranges, assumes the priors add up to
        % a total of 1
        while r >= offset + priors(class)
            offset = offset + priors(class);
            class = class + 1;
        end
        
        mu = mus(:, class);
        sigma = sigmas(:, (1 + (class - 1) * n):(n + (class - 1) * n));
        
        % generate a single datapoint
        data(:, i) = gausGen(1, n, mu, sigma);
        % store which class the data was generated from
        cData(i) = class;
        
        % create a MAP estimate lookup table that relates the class with 
        % the highest probability to the data index
        max = 0;
        class = 0;
        for cInd = 1:classes
            mu = mus(:, cInd);
            sigma = sigmas(:, (1 + (cInd - 1) * n):(n + (cInd - 1) * n));
            % using class mu and sigma data calculate the gausian pdf of a
            % given data point times the prior
            p = gausPdf(data(:, i), mu, sigma) * priors(cInd); 
            
            % find the maximum probability and store the class it came from
            if (p > max)
                class = cInd;
                max = p;
            end
        end
        
        % set the class index
        pdfData(i) = class;
    end
end
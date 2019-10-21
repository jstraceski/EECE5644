data = classGausGen(200, 2, [[0;0], [5;5]], [eye(2) eye(2)], [0.5, 0.5]);



means = 2;
mData = zeros(2, means);
mData([1 2], 2) = mData([1 2], 2) + [1; 1]

for i = 1:200
    clf
    hold on
    x = data([1 2], i);
    for mIndex = 1:means
        
    end
    
    for mIndexA = 1:means
        for mIndexB = 1:means
            if (mIndexA == mIndexB)
                continue
            end
            
            mA = mData([1 2], mIndexA);
            mB = mData([1 2], mIndexB);
            %d1 = min(1, max(0.001, norm(mA - mB)));
            
            p = max(0.0001, gausPdf(x, mB, eye(2)));
            d1 = max(0.0001, norm(mB - x));
            %d2 = max(0.0001, norm(mA - mB));
            
            v = (x - mB);
            
            mB = mB + v * 0.5 * d1/4;

            mData([1 2], mIndexB) = mB;
            
            scatter(data(1, 1:i), data(2, 1:i), 'black')
            scatter(mData(1, :), mData(2, :), 'red')
            drawnow limitrate
        end
    end
    
end

disp(mData)

scatter(mData(1, :), mData(2, :), 'red')

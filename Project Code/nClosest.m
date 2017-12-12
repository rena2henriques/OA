function [ closest ] = nClosest( y, N , size)
    closest = cell(size,1);
 
    for i = 1:60
        for n = 1:N
            min = Inf;
            for j = 1:60
                if i ~= j && ismember(j,closest{i}) == 0
                    cur = norm(y(:,i)-y(:,j));
                    if cur < min
                        jmin = j;
                        min = cur;
                    end
                end
            end
            closest{i} = [closest{i} jmin];
        end
    end
end


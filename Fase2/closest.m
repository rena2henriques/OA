%% Generating Points
% equidistant classes
class = [[10 0 0];[0 10 0];[0 0 10];];
c = ['r' 'g' 'b']
y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = round(rand*2)+1;
    y = [y; class(classtype(i),:)];
end

y = awgn(y, 7, 'measured');
y=y';

hold on;
for i = 1:60
    scatter3(y(1,i),y(2,i),y(3,i),c(classtype(i)));
end

closest = cell(60,1);

for i = 1:60
    min = Inf;
    for j = 1:60
        if i ~= j
           cur = norm(y(:,i)-y(:,j));
           if cur < min
               closest{i}(1)= j;
               min = cur;
           end
        end
    end
    min = Inf;
    
    for j = 1:60
        if i ~= j & j ~= closest{i}(1)
           cur = norm(y(:,i)-y(:,j));
           if cur < min
               closest{i}(2)= j;
               min = cur;
           end
        end
    end
    min = Inf;
    for j = 1:60
        if i ~= j & j ~= closest{i}(1) & j ~= closest{i}(2)
           cur = norm(y(:,i)-y(:,j));
           if cur < min
               closest{i}(3)= j;
               min = cur;
           end
        end
     end
end
closest

scatter3(y(1,1),y(2,1),y(3,1),'*');
scatter3(y(1,closest{1}(1)),y(2,closest{1}(1)),y(3,closest{1}(1)),'+');
scatter3(y(1,closest{1}(2)),y(2,closest{1}(2)),y(3,closest{1}(2)),'+');
scatter3(y(1,closest{1}(3)),y(2,closest{1}(3)),y(3,closest{1}(3)),'+');
grid on;
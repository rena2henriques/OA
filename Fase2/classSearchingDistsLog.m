%% Generating Points
% equidistant classes
class = [[10 0 0];[0 10 0];[0 0 10];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = round(rand*2)+1;
    
    y = [y; class(classtype(i),:)];
end

y = awgn(y, 15, 'measured');
y=y';

%% Grouping points

% distance ref
epsilon = 0.5;

% Weight of term 2
ro = 1;

x_old = zeros([3, 60]);

norm_atual = 0;
norm_ant = 0;

for iter=0:3

    cvx_begin quiet
        variable x(3, 60);

        Term1 = 0;
        Term2 = 0;

        for i=1:60
           % same as euclidean norm squared
           Term1 = Term1 + (y(:,i) - x(:,i))'*(y(:,i) - x(:,i));
        end

        for i=1:60
           for j=i+1:60
               if (iter == 0)
                   norm_atual = norm(x(:,i) - x(:,j));
                   Term2 = Term2+ norm_atual/((y(:,i) - y(:,j))'*(y(:,i) - y(:,j)) + 10^(-6));
               else
                   norm_atual = norm(x(:,i) - x(:,j));
                   norm_ant = norm(x_old(:,i)-x_old(:,j));
                   Term2 = Term2+ norm_atual/(norm_ant  + 10^(-6) );
               end 
           end
        end               
        
        minimize(Term1 + ro*Term2);

        % subject to
        % nothing

    cvx_end
    
    iter
    
    plot(y(1,:),y(2,:),'x'); 
    hold on;
    plot(x(1,:),x(2,:),'ro');
    pause(5/1000);
    hold off;
    x_old = x;
end

%% Polishing the results

points = (unique(round(x, 3)','rows'))';
group=cell(1,3);

for i=1:60
    for p=1:3
        if( round(x(:,i),3) == points(:,p)) 
            group{p}=[group{p}, i];
        end
    end
end

% Fazer cvx para as 3 classes

classPred = zeros(3);

for p=1:3
    cvx_begin quiet   
        variable pred(3,1);
  
        Term1=0;

        for k=1:length(group{p})
            Term1 = Term1 + (y(:, group{p}(k)) - pred)'*(y(:, group{p}(k)) - pred);
        end

        minimize(Term1);
        
        % subject to  
        %nothing
    cvx_end;
    
    pred'
    
    %inserts point in the predictions array
    classPred(:,p) = pred';
    
end

for i=1:3
    error(i) = norm(classPred(:,i)-class(:,i));
end

%plot the result
figure(1); 
clf; 
% printing in 2D for now
plot(y(1,:),y(2,:),'x'); 
hold on
plot(x(1,:),x(2,:),'ro');
figure(2);
scatter3(x(1,:),x(2,:),x(3,:),'ro');
hold on
scatter3(y(1,:),y(2,:),y(3,:),'x');
axis('equal'); 
grid on;

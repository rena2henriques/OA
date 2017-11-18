%% Generating Points
% equidistant classes
class = [[0 0 5];[0 5 0];[5 0 0];];

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
epsilon = 0.7;

% Weight of term 2
ro = 2

cvx_begin quiet
    variable x(3, 60);
    
    Term1 = 0;
    Term2 = 0;
    
    for i=1:60
       Term1 = Term1 + (y(:,i) - x(:,i))'*(y(:,i) - x(:,i));
    end

    for i=1:60
       for j=i+1:60
           if ( norm(y(:,i) - y(:,j)) < epsilon )
              Term2 = Term2 + norm(x(:,i) - x(:,j)); 
           end
       end
    end
    
    minimize(Term1 + ro*Term2);

    % subject to
    % nothing
    
cvx_end

%plot the result
figure(2); 
clf; 
% printing in 2D for now
%plot(x(1,:),x(2,:),'ro'); 
scatter3(x(1,:),x(2,:),x(3,:),'ro');
axis('equal'); 
grid on;

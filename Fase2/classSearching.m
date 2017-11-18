


% distance ref
epsilon = 0.5;

% Weight of term 2
ro = 0

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
              term2 = term2 + norm(x(:,i) - x(:,j)); 
           end
       end
    end
    
    minimize(Term1 + ro*Term2);

    % subject to
    % nothing
    
cvx_end

%plot the result
figure(1); 
clf; 
% printing in 2D for now
plot(x(1,:),x(2,:),'ro'); 
axis('equal'); 
grid on;

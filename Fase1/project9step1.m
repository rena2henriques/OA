a=[-2*sensors; ones(1,64)];
for i=1:64
   B(i)=d(:,i)^2-norm(sensors(:,i))^2;
end
ro=10;
cvx_begin quiet   
    variable x(2, 64);
    variable t(64);
    
    Term1=0;
    Term2=0;  
    for i=1:64
        Term1 = Term1 + (a(:,i)'*[x(:,i) ; t(i)] - B(i))^2;
     end
    
for i=1:64
    for j=i+1:64
        if(norm(sensors(:,i)-sensors(:,j))==1)
            Term2=Term2+norm([x(:,i);t(i)]-[x(:,j);t(j)]);    
        end
    end
    
%     Term1 = Term1 + (a(:,i)'*[x(:,i) ; t(i)] - B(i))*(a(:,i)'*[x(:,i) ; t(i)] - B(i));
end

minimize(Term1 + ro*Term2);
% subject to
for i = 1:64
    x(:,i)'*x(:,i)<= t(i);
end               
cvx_end;

figure(1); clf; plot(x(1,:),x(2,:),'ro'); axis('equal'); grid on;

hold on;
plot(X(1,:),X(2,:),'b+'); axis('equal'); grid on;
figure(1)
n = 5;
class = [n 0 n;0 n n;0 0 0];
load('rVectorClasstype.mat');
factor = 0.75;
y = (class(:,classtype) + rVector*factor );


scatter3(y(1,:), y(2,:),y(3,:), '.');
hold on;
scatter3(class(1,:), class(2,:),class(3,:), 's', 'filled');
xlabel('coordenada x');
ylabel('coordenada y');
zlabel('coordenada z');
legend('input data','real points');
axis('equal');
grid on;

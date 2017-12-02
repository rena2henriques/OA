load('y.mat');
Ro = [ 1 2 3 4 5 6 7 8 9 10];
[X, P] = metodo1(Ro, y);
%%
for i = length(Ro):-1:1
    figure()
    scatter3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'ro');
    hold on
    scatter3(y(1,:),y(2,:),y(3,:),'x');
    hold off;
    title(['Ro: ',num2str(Ro(i)),'    Points: ',num2str(points(i))])
    pause(5/10);
end
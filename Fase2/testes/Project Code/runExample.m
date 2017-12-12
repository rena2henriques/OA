class = [[1.5 0 0];[0 2 0];[0 0 1];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = fix(rand*3)+1;
    
    y = [y; class(classtype(i),:)];
end
%y = awgn(y, 15, 'measured');
factor = 0.75;
y=y+randn(60,3)*factor;
y=y';
ro = 5;
neighbors=5;
[classPred, x, MSE, points]=funcXneighbors(y, neighbors, ro, class');
classPred = classPred';
%%
figure();
hold on;
scatter3(class(:,1),class(:,2),class(:,3),'ks','filled');
scatter3(classPred(:,1),classPred(:,2),classPred(:,3),'ro','filled');
scatter3(y(1,:),y(2,:),y(3,:),3, 'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[.5 .5 .5]);
title(['MSE: ',num2str(MSE),'   \rho: ',num2str(ro),'   Neighbors: ',num2str(neighbors)]);
xlabel('X');
ylabel('Y');
zlabel('Z')
grid on;
hold off;
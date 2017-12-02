class1 = [[3 0 0];[0 3 0];[3 3 0];];
class2 = [[3 0 0];[0 3 0];[2.5 2.5 0];];
class3 = [[3 0 0];[0 3 0];[2 2 0];];
class4 = [[3 0 0];[0 3 0];[1.85 1.85 0];];
class5 = [[3 0 0];[0 3 0];[1.75 1.75 0];];
class6 = [[3 0 0];[0 3 0];[1.5 1.5 0];];

classes = cell(3,1);
classes{1} = class1';
classes{2} = class2';
classes{3} = class3';
classes{4} = class4';
classes{5} = class5';
classes{6} = class6';

rVector = randn(60,3);
classtype = fix(rand(60,1)*3)+1;
factor = 0.5;
%%
c = ['r','b','g'];

y = ([classes{1}(classtype,:)] + rVector*factor )';

figure;
hold on;
for i =1:length(classtype)
	scatter3(y(1,i),y(2,i),y(3,i), num2str(c(classtype(i))));
end
grid on;
axis('equal')
%%
ro = 2;
neig = 5;

for i = 1:length(classes)

    [classPred, x, MSE, points]=funcXneighbors(y, neig, ro, classes{i});
    
    %%
    figure;
    hold on;
    scatter3(y(1,:),y(2,:),y(3,:),'.');%, num2str(c(classtype(i))));   
    scatter3(classPred(1,:),classPred(2,:),classPred(3,:),'kx');
    scatter3(classes{i}(1,:),classes{i}(2,:), classes{i}(3,:), 'rx');
    legend('Data', 'Estimation', 'True Class');
    
    title(['\rho :', num2str(ro),'   Neigbors :', num2str(neig),'   #Points :', num2str(length(points)),'   MSE :',num2str(MSE)]);
    
    axis('equal'); 
    grid on;
end
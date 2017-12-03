class1 = [[2.5 0 0];[0 2.5 0];[2.5 2.5 0];];
class2 = [[2.5 0 0];[0 2.5 0];[2 2 0];];
class3 = [[2.5 0 0];[0 2.5 0];[1.85 1.85 0];];
class4 = [[2.5 0 0];[0 2.5 0];[1.75 1.75 0];];
class5 = [[2.5 0 0];[0 2.5 0];[1.5 1.5 0];];
class6 = [[2.5 0 0];[0 2.5 0];[1.25 1.25 0];];

classes = cell(3,1);
classes{1} = class1';
classes{2} = class2';
classes{3} = class3';
classes{4} = class4';
classes{5} = class5';
classes{6} = class6';

%% 
rVector = randn(3,60);
classtype = fix(rand(60,1)*3)+1;
%%
factor = 0.85;
ONLYPRINT = 1;
%%
c = ['r','b','g'];
ro = 2;
neig = 5;

CLASSPred = cell(length(classes));
Pts = cell(length(classes));
X = cell(length(classes));
C = cell(3);
%%
for i = 1:length(classes)
    y = (classes{i}(:,classtype) + rVector*factor );
    %%
    if ONLYPRINT == 0
    [classPred, x, mse, points]=funcXneighbors(y, neig, ro, classes{i});
    [ind, ctr] = kmeans(y, 3);
    %%
    C{i} = ctr;
    CLASSPred{i} = classPred;
    Pts{i} = points;
    X{i} = x;
    MSE(i) = mse;
    end
    %%
    f = figure;
    hold on;
    scatter3(y(1,:),y(2,:),y(3,:),'.');%, num2str(c(classtype(i))));   
    scatter3(CLASSPred{i}(1,:), CLASSPred{i}(2,:),CLASSPred{i}(3,:),'ko', 'filled');
    scatter3(C{i}(:,1), C{i}(:,2), C{i}(:,3), 'mo', 'filled');
    scatter3(classes{i}(1,:), classes{i}(2,:), classes{i}(3,:), 'ro', 'filled');
    legend('Data', 'Estimation', 'Kmeans','True Class');
    title(['\rho :', num2str(ro),'   Neigbors :', num2str(neig),'   #Points :', num2str(length(Pts{i})),'   MSE :',num2str(MSE(i))]);
    axis([-3 5 -3 6]);
    grid on;
    hold off;
    %pause(1/500);
    saveas(f, ['gif/t2r',num2str(factor),'.',num2str(i),'.jpg']);
    close(f)
    save(['badRegionsTest2Noise', num2str(factor),'.mat']);
end
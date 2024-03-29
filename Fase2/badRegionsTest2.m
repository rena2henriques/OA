class1 = [[2.5 0 0];[0 2.5 0];[2.5 2.5 0];];
class2 = [[2.5 0 0];[0 2.5 0];[2 2 0];];
class3 = [[2.5 0 0];[0 2.5 0];[1.85 1.85 0];];
class4 = [[2.5 0 0];[0 2.5 0];[1.75 1.75 0];];
class5 = [[2.5 0 0];[0 2.5 0];[1.5 1.5 0];];
class6 = [[2.5 0 0];[0 2.5 0];[1.25 1.25 0];];
class7 = [[2.5 0 0];[0 2.5 0];[2.5 2.25 0];];
class8 = [[2.5 0 0];[0 2.5 0];[2.5 2 0];];
class9 = [[2.5 0 0];[0 2.5 0];[2.5 1.75 0];];
class10 = [[2.5 0 0];[0 2.5 0];[2.5 1.5 0];];
class11 = [[2.5 0 0];[0 2.5 0];[2.5 1.25 0];];
class12 = [[2.5 0 0];[0 2.5 0];[2.5 1 0];];
class13 = [[2.5 0 0];[0 2.5 0];[2.5 0.75 0];];
class14 = [[2.5 0 0];[0 2.5 0];[2.5 0.5 0];];
class15 = [[2.5 0 0];[0 2.5 0];[2.5 0.25 0];];

classes = cell(15,1);
classes{1} = class1';
classes{2} = class2';
classes{3} = class3';
classes{4} = class4';
classes{5} = class5';
classes{6} = class6';
classes{7} = class7';
classes{8} = class8';
classes{9} = class9';
classes{10} = class10';
classes{11} = class11';
classes{12} = class12';
classes{13} = class13';
classes{14} = class14';
classes{15} = class15';

%% 
load('rVectorClasstype.mat');
%rVector = randn(3,60);
%%classtype = fix(rand(60,1)*3)+1;
%%
factor = 1;
ONLYPRINT = 0;
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
    opts = statset('Display','final');
    [ind, ctr] = kmeans(y',3,'Distance','cityblock','Replicates',5,'Options',opts);
    
    %%
    C{i} = ctr;
    msek(i) = mse_func(C{i}', classes{i});
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
    title(['\rho :', num2str(ro),'   Neigbors :', num2str(neig),'   #Points :', num2str(length(Pts{i})),'   MSE :',num2str(MSE(i)),'  MSE-k-means:',num2str(msek(i))]);
    axis([-3 5 -3 6]);
    grid on;
    hold off;
    %pause(1/500);
    saveas(f, ['gif/t2r',num2str(factor),'.',num2str(i),'.jpg']);
    close(f)
    save(['badRegionsTest2Noise', num2str(factor),'.mat']);
end
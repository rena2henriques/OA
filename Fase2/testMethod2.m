load('testMethod2.mat');
class = [[1 0 0];[4 4 0];[0 1 0];];

c = ['r','b','g'];
y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = fix(rand*3)+1;
    
    y = [y; class(classtype(i),:)];
end

%y = awgn(y, 15, 'measured');
y=y+randn(60,3)*0.50;
y=y';
%load('y.mat');

if 1
    figure()
    hold on;
    for i =1:length(classtype)
        scatter3(y(1,i),y(2,i),y(3,i), num2str(c(classtype(i))));
    end
    grid on;
    axis('equal')
end

%%
for numNeig = 5:5
    closest = nClosest(y,numNeig,60);
    Ro = [2];

    [X, P, E] = metodo2(Ro, y, closest, numNeig, class);
    %%
    save(['method2testBadRegions/testMethod2n5r5.mat']);
    %%
    for i = length(Ro):-1:1
        figure();
        scatter3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'ro');
        hold on
        scatter3(y(1,:),y(2,:),y(3,:),'x');
        hold off;
        title(['Ro: ',num2str(Ro(i)),'    Points: ',num2str(P(i)),'    Neighbors: ',num2str(numNeig),'    Erro: ',num2str(E)]);
        pause(5/10);
    end
    %savefig(h,['method2teste2/m2n',num2str(numNeig),'.fig']);
    %close(h);
end
save('testMethod2.mat');
load('testMethod2.mat');
load('y.mat');
for numNeig = 1:30
    closest = nClosest(y,numNeig,60);
    Ro = [ 1 2 3 4 5 6 7 8 9 10];

    [X, P] = metodo2(Ro, y, closest, numNeig);
    %%
    save(['method2/testMethod2n',num2str(numNeig),'.mat']);
    %%
    for i = length(Ro):-1:1
        h(i)=figure();
        scatter3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'ro');
        hold on
        scatter3(y(1,:),y(2,:),y(3,:),'x');
        hold off;
        title(['Ro: ',num2str(Ro(i)),'    Points: ',num2str(P(i)),'    Neighbors: ',num2str(numNeig)]);
        %%pause(5/10);
    end
    savefig(h,['method2/m2n',num2str(numNeig),'.fig']);
    close(h);
end
save('testMethod2.mat');
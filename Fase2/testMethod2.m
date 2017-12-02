load('testMethod2.mat');
class = [[10 0 0];[0 10 0];[0 0 10];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = fix(rand*3)+1;
    
    y = [y; class(classtype(i),:)];
end

%y = awgn(y, 15, 'measured');
y=y+randn(60,3)*0.75;
y=y';
%load('y.mat');
for numNeig = 10:12
    closest = nClosest(y,numNeig,60);
    %Ro = [ 1 2 3 4 5 6 7 8 9 10];
    Ro = [15];

    [X, P, E] = metodo2(Ro, y, closest, numNeig, class);
    %%
    save(['method22/testMethod2n',num2str(numNeig),'.mat']);
    %%
    for i = length(Ro):-1:1
        h(i)=figure();
        scatter3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'ro');
        hold on
        scatter3(y(1,:),y(2,:),y(3,:),'x');
        hold off;
        title(['Ro: ',num2str(Ro(i)),'    Points: ',num2str(P(i)),'    Neighbors: ',num2str(numNeig),'    Erro: ',num2str(E)]);
        %%pause(5/10);
    end
    savefig(h,['method22/m2n',num2str(numNeig),'.fig']);
    close(h);
end
save('testMethod2.mat');
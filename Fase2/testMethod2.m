load('testMethod2.mat');
class = [[2 0 0];[2 2.5 0];[0 0 5];];

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
scatter3(y(1,:),y(2,:),y(3,:),'x');
axis('equal')
%%
for numNeig = 5:6
    closest = nClosest(y,numNeig,60);
    Ro = [ 0.001 0.01 0.1 1 10 100 1000];

    [X, P, E] = metodo2(Ro, y, closest, numNeig, class);
    %%
    save(['method2/testMethod2n',num2str(numNeig),'RoPower10.mat']);
    %%
    %for i = length(Ro):-1:1
       % h(i)=figure();
       % scatter3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'ro');
        %hold on
       % scatter3(y(1,:),y(2,:),y(3,:),'x');
      %  hold off;
     %   title(['Ro: ',num2str(Ro(i)),'    Points: ',num2str(P(i)),'    Neighbors: ',num2str(numNeig),'    Erro: ',num2str(E)]);
        %%pause(5/10);
    %end
    %savefig(h,['method2teste2/m2n',num2str(numNeig),'.fig']);
    %close(h);
end
save('testMethod2.mat');
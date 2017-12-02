for nei = 1:30

load(['method2/testMethod2n',num2str(nei),'.mat']);
for ro = 1:10
    class = [[5 0 0];[0 5 0];[0 0 5];];
    uniquex = (unique(round(X{ro}, 3)','rows'))';
        error=[];
        for i = 1:length( uniquex(1,:))
            minimum = [];
            for j = 1:length(class)
                 minimum = [minimum norm(uniquex(:,i)-class(:,j))];
            end
            [m mind]= min(minimum);
            error=[error; norm(uniquex(:,i)-class(:,mind))];
        end

        ERRO(ro)=sum(error.^2)/length(uniquex(1,:));
        tamanho(ro)=length( uniquex(1,:));
        fprintf('Neigbor: %d\tRo: %d\tErro: %f\tPoints: %d\n',nei, ro, ERRO(ro), tamanho(ro));
        save(['method2/errorPlotNeig',num2str(nei),'Ro',num2str(ro),'.mat']);
end
%%
figure()    
plot(1:ro, ERRO,'-');
title(['Neigbors: ',num2str(nei)])
xlabel('Ró')
ylabel('Error');
end
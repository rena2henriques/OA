for ro = 1:10
for nei = 1:30
    class = [[5 0 0];[0 5 0];[0 0 5];];
    load(['method2/testMethod2n',num2str(nei),'.mat']);
    uniquex = (unique(round(X{ro}, 3)','rows'))';
        % error
            error=[];
        for i = 1:length( uniquex(1,:))
            minimum = [];
            for j = 1:length(class)
                 minimum = [minimum norm(uniquex(:,i)-class(:,j))];
            end
            [m mind]= min(minimum);
            error=[error; norm(uniquex(:,i)-class(:,mind))];
        end

        ERRO(nei)=sum(error.^2)/length(uniquex(1,:));
        tamanho(nei)=length( uniquex(1,:));
        fprintf('Neigbor: %d\tRo: %d\tErro: %f\tPoints: %d\n',nei, ro, ERRO(nei), tamanho(nei));
end
save(['method2/errorPlotRo',num2str(ro),'Neig',num2str(nei),'.mat']);

plot(1:nei, ERRO,'-');
title(['Ró: ',num2str(ro)])
end

for nei = 1:30
    ro = 1;
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

        tamanho(nei)=length( uniquex(1,:));
        ERRO(nei)=sum(error.^2)/length(uniquex(1,:));
        tamanho(nei)=length( uniquex(1,:));
        fprintf('Neigbor: %d\tRo: %d\tErro: %f\tPoints: %d\n',nei, ro, ERRO(nei), tamanho(nei));
end

save(['method2/errorPlotRo',num2str(ro),'Neig',num2str(nei),'.mat']);
%%

ro=1;
load(['errorPlotRo',num2str(ro),'Neig30.mat']);
nei=20;

f1=figure
plot(1:nei, ERRO(1:nei),'-');
title(['\rho= ',num2str(ro)])
xlabel('n� de vizinhos');
ylabel('MSE');
saveas(f1,['MSE_Ro',num2str(ro),'Pos5_VariarNeig.png']);

f2=figure
plot(1:nei, tamanho(1:nei),'-');
title(['\rho= ',num2str(ro)])
xlabel('n� de vizinhos');
ylabel('m� de pontos encontrados');
saveas(f2,['Pontos_Ro',num2str(ro),'Pos5_VariarNeig.png']);
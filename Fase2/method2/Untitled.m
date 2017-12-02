nei=15;
load(['errorPlotNeig',num2str(nei),'Ro.mat']);

f1=figure
plot(1:10, ERRO,'-');
title(['Nº de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('MSE');
saveas(f1,['MSE_Neig',num2str(nei),'Pos5_VariarRo.png']);

f2=figure
plot(1:10, tamanho,'-');
title(['Nº de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('nº de pontos encontrados');
saveas(f2,['Pontos_Neig',num2str(nei),'Pos5_VariarRo.png']);
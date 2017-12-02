nei=15;
load(['errorPlotNeig',num2str(nei),'Ro.mat']);

f1=figure
plot(1:10, ERRO,'-');
title(['N� de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('MSE');
saveas(f1,['MSE_Neig',num2str(nei),'Pos5_VariarRo.png']);

f2=figure
plot(1:10, tamanho,'-');
title(['N� de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('n� de pontos encontrados');
saveas(f2,['Pontos_Neig',num2str(nei),'Pos5_VariarRo.png']);
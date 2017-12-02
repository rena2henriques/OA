nei=5;
load(['errorPlotNeig',num2str(nei),'Ro.mat']);

f1=figure
plot(Ro, ERRO,'-');
title(['Nº de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('MSE');
saveas(f1,['MSE_Neig',num2str(nei),'Pos5_VariarRo.png']);

f2=figure
plot(Ro, tamanho,'-');
title(['Nº de vizinhos= ',num2str(nei)])
xlabel('\rho');
ylabel('nº de pontos encontrados');
saveas(f2,['Pontos_Neig',num2str(nei),'Pos5_VariarRo.png']);
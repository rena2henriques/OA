set = [[5 0 0];[0 5 0];[0 0 5]];
load('rVectorClasstype.mat');
ro = 2;
neig = 5;
factor = 0.25:0.1:2.55;
for f = 1:length(factor)
    y = (set(:,classtype) + rVector*factor(f) );
    [setPred, x, mse, points] = funcXneighbors(y, neig, ro, set);
    MSEr2(f) = mse;
    fprintf('ro %d\tfactor %d\tMSE %f\n',ro,factor(f),mse);

end
%%
load('testedistaciaFixa.mat');
f=figure();
hold on;   
plot(factor(:), MSE(:),'.-');
plot(factor(:), MSEr2(:),'.-');
plot(factor(:), MSEKmeans(:),'.-'); 
xlabel('Factor de Ruido');
ylabel('MSE');
legend('Método \rho = 5','Método \rho = 2','K - means');
title(['Dispersão do ruído, Distância min: ',num2str(normMin)])
grid on;
save('dfix.mat');
saveas(f,'dfix.png');


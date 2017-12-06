load('rVectorClasstype.mat');
ro = 5;
neig = 5;
factor = 0.65;
N = 0.1:0.1:5;
for n = 1:length(N);
    set = [[N(n) 0 0];[0 N(n) 0];[0 0 N(n)]];
    y = (set(:,classtype) + rVector*factor );
    [setPred, x, mse, points] = funcXneighbors(y, neig, ro, set);
	MSE(n) = mse;
    fprintf('class %d\tMSE %f\n',N(n),mse);
    figure();
    hold on;
    scatter3(x(1,:),x(2,:),x(3,:),'o');
    scatter3(setPred(:,1),setPred(:,2),setPred(:,3),'r*');
    scatter3(set(:,1),set(:,2),set(:,3),'k*');
    scatter3(y(1,:),y(2,:),y(3,:),'x');
    title(['N: ',num2str(N(n))]);
    grid on;
    
end   
%%
figure();
plot(N(:), MSE(:),'.-');
xlabel('Distância entre pontos');
ylabel('MSE');
title('Distância a variar');
save('ruidoFixo.mat');
grid on;

%%
    
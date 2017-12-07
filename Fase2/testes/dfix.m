set = [[5 0 0];[0 5 0];[0 0 5]];
% descobrir  a distancia minima entre 2 pontos da class
[npts ptsdim] = size(set);
normMin = Inf;
for i = 1:npts
    for j = i+1:npts
        normActual = norm(set(:,i)-set(:,j));
        if normActual < normMin
            normMin = normActual;
        end
	end        
end
    
load('rVectorClasstype.mat');

ro = 5;
neig = 5;
factor = 0.25:0.1:2.55;
for f = 1:length(factor)
    y = (set(:,classtype) + rVector*factor(f) );
    [setPred, x, mse, points] = funcXneighbors(y, neig, ro, set);
    MSE(f) = mse;
    
    [idx,C] = kmeans(y',3);
    setPredKmeans=[C(:,1) C(:,2) C(:,3)];
    error=[];    
	for i = 1:length(setPredKmeans)
        minimum = [];
        for j = 1:length(set)  
        	minimum =[minimum norm(setPredKmeans(:,i)-set(:,j))];
        end
        [m mind]= min(minimum);
        error(i) = norm(setPredKmeans(:,i)-set(:,mind));
    end
    MSEKmeans(f)=sum(error.^2)/3;

    fprintf('factor %d\tMSE %f\n',factor(f),mse);
    h = figure();
    hold on;
    %scatter3(x(1,:),x(2,:),x(3,:),'o');
    scatter3(y(1,:),y(2,:),y(3,:),'bx');
    scatter3(setPred(:,1),setPred(:,2),setPred(:,3),'r*');
    scatter3(set(:,1),set(:,2),set(:,3),'k*');
    scatter3(C(:,1),C(:,2),C(:,3),'mo','filled');
    title(['Fator:',num2str(factor(f))]);
    grid on;
    saveas(h,['evolution/dfix',num2str(factor(f)),'.png']);
    
end   
%%
f=figure();
hold on;   
plot(factor(:), MSE(:),'.-');
plot(factor(:), MSEKmeans(:),'.-'); 
xlabel('Factor de Ruido');
ylabel('MSE');
title(['Dispersão do ruído, Distância min: ',num2str(normMin)])
grid on;
save('testedistaciaFixa.mat');
saveas(f,'dfix.png');


class = [[5 0 0];[0 5 0];[0 0 5]];
% descobrir  a distancia minima entre 2 pontos da class
[npts ptsdim] = size(class);
normMin = Inf;
for i = 1:npts
    for j = i+1:npts
        normActual = norm(class(:,i)-class(:,j));
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
    y = (class(:,classtype) + rVector*factor(f) );
    [classPred, x, mse, points] = funcXneighbors(y, neig, ro, class);
    MSE(f) = mse;
    figure();
    hold on;
    scatter3(x(1,:),x(2,:),x(3,:),'o');
    scatter3(classPred(:,1),classPred(:,2),classPred(:,3),'r*');
    scatter3(class(:,1),class(:,2),class(:,3),'r*');
    scatter3(y(1,:),y(2,:),y(3,:),'x');
    title(['Fator:',num2str(factor(f))]);
end   
MSE
%%
figure();
plot(factor(:), MSE(:),'.-');    
xlabel('Factor de Ruido');
ylabel('MSE');
title(['Ruido a variar, Distância min: ',num2str(normMin)])
save('testedistaciaFixa.mat');



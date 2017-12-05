class1 = [[5 0 0];[0 5 0];[0 0 5];];
class2 = [[2 0 0];[0 2 0];[0 0 2];];

classes = cell(2,1);
classes{1} = class1';
classes{2} = class2';


load('rVectorClasstype.mat');
factor = 0.75;
neig = 5;
Ro = 0.25:0.5:10;
ClassPred = cell(2,1);
X = cell(2,1);
P = cell(2,1);
mse = zeros(2,1);
%%
for c = 1:length(classes)
    y = (classes{c}(:,classtype) + rVector*factor );
    [ x, pts , err] = metodo2( Ro, y, neig, classes{c});
    X{c} = x;
    P{c} = pts;
end
save('comparisonsRo.mat');
%%
for c = 1:length(classes)   
    figure(1)
    hold on;
    plot(Ro(:),P{c}(:,1)); 
    hold off;
end
xlabel('\rho');
ylabel('Nº of Points');
legend('class1','class2');
title('Nº Points VS \rho');
grid on;
%%  VIZINHOS

Xviz = cell(2,1);
Pviz = cell(2,1);
ro = 5;
% isto  v é perigoso
Nei = [ 1 2 3 4 5 6 8 10 15 20];
for c = 1:length(classes)
    y = (classes{c}(:,classtype) + rVector*factor );
    for n = 1:length(Nei)        
        [ x, pts , err] = metodo2( ro, y, n, classes{c});   
        xviz(n) = x;
        ptsviz(n) = pts;
        
    end
    Xviz{c} = xviz;
    Pviz{c} = ptsviz;    
end
save('comparisonsNei.mat');
%%
for c = 1:length(classes)   
    figure(2)
    hold on;
    plot(Nei(:),Pviz{c}(:)); 
    hold off;
end
xlabel('Nº of Neighbors');
ylabel('Nº of Points');
legend('Class 1','Class 2');
title('Nº Points VS Neighbors');
grid on;
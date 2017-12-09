set1 = [[5 0 0];[0 5 0];[0 0 5];];
set2 = [[2 0 0];[0 2 0];[0 0 2];];

set = cell(2,1);
set{1} = set1';
set{2} = set2';

load('rVectorClasstype.mat');
factor = 0.75;
neig = 5;
Ro = 0.1:0.25:10;
X = cell(2,1);
P = cell(2,1);
mse = zeros(2,1);
%%
for c = 1:length(set)
    y = (set{c}(:,classtype) + rVector*factor );
    [ x, pts , err] = metodo2( Ro, y, neig, set{c});
    X{c} = x;
    P{c} = pts;
end
save('comparisonsRo.mat');
f = figure();
hold on; 
for c = 1:length(set)   
    plot(Ro(:),P{c}(:,1), '.-'); 
end
xlabel('\rho');
ylabel('Nº of Points');
title('Nº Points VS \rho');
grid on;
hold off;
saveas(f,'ro/rho.png');
%%  VIZINHOS

Xviz = cell(2,1);
Pviz = cell(2,1);
ro = 5;
% isto  v é perigoso
Nei = [ 1 2 3 4 5 6 8 9 10 15 20];
for c = 1:length(set)
    y = (set{c}(:,classtype) + rVector*factor );
    for n = 1:length(Nei)        
        [ x, pts , err] = metodo2( ro, y, n, set{c});   
        xviz(n) = x;
        ptsviz(n) = pts;     
    end
    Xviz{c} = xviz;
    Pviz{c} = ptsviz;    
end
save('comparisonsNei.mat');
%%
f = figure();
hold on;
for c = 1:length(set)   
    plot(Nei(:),Pviz{c}(:), '.-'); 
end
xlabel('Nº of Neighbors');
ylabel('Nº of Points');
title('Nº Points VS Neighbors');
grid on;
hold off;
saveas(f,'neig/neig.png');
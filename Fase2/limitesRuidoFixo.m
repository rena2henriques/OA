function [] = limitesRuidoFixo()
    class1 = [[2.5 0 0];[0 2.5 0];[2.5 2.5 0];];
    class2 = [[2.5 0 0];[0 2.5 0];[2.5 2.25 0];];
    class3 = [[2.5 0 0];[0 2.5 0];[2 2 0];];
    class4 = [[2.5 0 0];[0 2.5 0];[2.5 2 0];];
    class5 = [[2.5 0 0];[0 2.5 0];[1.85 1.85 0];];
    class6 = [[2.5 0 0];[0 2.5 0];[1.75 1.75 0];];
    class7 = [[2.5 0 0];[0 2.5 0];[1.5 1.5 0];];
    class8 = [[2.5 0 0];[0 2.5 0];[1.25 1.25 0];];
    class9 = [[2.5 0 0];[0 2.5 0];[2.5 1.75 0];];
    class10 = [[2.5 0 0];[0 2.5 0];[2.5 1.5 0];];
    class11 = [[2.5 0 0];[0 2.5 0];[2.5 1.25 0];];
    class12 = [[2.5 0 0];[0 2.5 0];[2.5 1 0];];
    class13 = [[2.5 0 0];[0 2.5 0];[2.5 0.75 0];];
    class14 = [[2.5 0 0];[0 2.5 0];[2.5 0.5 0];];
    class15 = [[2.5 0 0];[0 2.5 0];[2.5 0.25 0];];

    
    classes = cell(15,1);
    classes{1} = class1';
    classes{2} = class2';
    classes{3} = class3';
    classes{4} = class4';
    classes{5} = class5';
    classes{6} = class6';
    classes{7} = class7';
    classes{8} = class8';
    classes{9} = class9';
    classes{10} = class10';
    classes{11} = class11';
    classes{12} = class12';
    classes{13} = class13';
    classes{14} = class14';
    classes{15} = class15';

    
    %% descobrir  a distancia minima entre 2 pontos da mesma classe
    
    for c = 1:length(classes)
        [npts ptsdim] = size(classes{c});
        normMin = Inf;        
        for i = 1:npts
            for j = i+1:npts
                normActual = norm(classes{c}(:,i)-classes{c}(:,j));
                if normActual < normMin
                    normMin = normActual;
                end
            end        
        end
        dist(c) = normMin;
    end
    
    %%  
    
    load('rVectorClasstype.mat');
    ro = 5;
    neig = 5;
    factor = 0.75;
    for c = 1:length(classes)
        y = (classes{c}(:,classtype) + rVector*factor );
        [classPred, x, mse, points] = funcXneighbors(y, neig, ro, classes{c});
        MSE(c) = mse;
    end   
    MSE
    plot(factor/dist(:), MSE(:));
    xlabel('Ruido/Distância');
    ylabel('MSE');
    title('Distância a variar');
    save('ruidoFixo.mat');
    
end


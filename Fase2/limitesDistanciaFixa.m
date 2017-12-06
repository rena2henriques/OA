function [] = limites( class )zz
    
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
    factor = 0.25:0.25:1;
    for f = 1:length(factor)
        y = (class(:,classtype) + rVector*f );
        [classPred, x, mse, points] = funcXneighbors(y, neig, ro, class);
        MSE(f) = mse;
    end   
    MSE
    figure();
    plot(factor(:), MSE(:));
    xlabel('Ruido/Distância');
    ylabel('MSE');
    title('Ruido a variar')
    save('distaciaFixa.mat');
end


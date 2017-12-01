function [ X, P ] = metodo2( Ro, y, closest, numNeig)
    
    P = zeros(length(Ro),1);
    X = cell(length(Ro),1);
    for r = 1:length(Ro)
        ro = Ro(r);
        
        norm_atual = 0;
        norm_ant = 0;
        
        points = Inf;
        for iter=0:5
            if points <= 3
                break;
            end

            cvx_begin quiet
                variable x(3, 60);

                Term1 = 0;
                Term2 = 0;

                for i=1:60
                   % same as euclidean norm squared
                   Term1 = Term1 + (y(:,i) - x(:,i))'*(y(:,i) - x(:,i));
                end

                for i=1:60
                   for j=i+1:60

                       if (iter == 0)
                           if( ismember(j,closest{i}) )
                              norm_atual = norm(x(:,i) - x(:,j));
                              Term2 = Term2 + norm(x(:,i) - x(:,j)); 
                           end
                       else
                           if( ismember(j,closest{i}) )
                               norm_atual = norm(x(:,i) - x(:,j));
                               norm_ant = norm(x_old(:,i)-x_old(:,j));
                               Term2 = Term2+ norm_atual/(norm_ant  + 10^(-6) );
                           end
                       end 
                   end
                end

                minimize(Term1 + ro*Term2);

                % subject to
                % nothing
                fprintf('Neigbors: %d\tRo:%d\tIter:%d\n',numNeig,ro, iter);

            cvx_end
    %%
            x_old = x;
            points = length((unique(round(x, 3)','rows'))');
        end
        
        P(r) = points;
        X{r} = x;       
        
    end
end

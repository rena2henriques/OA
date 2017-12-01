function [X, P] = metodo1(Ro, y)
    P = zeros(length(Ro),1);
    X = cell(length(Ro),1);
    for r = 1:length(Ro)
        ro = Ro(r)
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
                      Term2 = Term2 + norm(x(:,i) - x(:,j))/((y(:,i) - y(:,j))'*(y(:,i) - y(:,j)) + 10^(-6)); 
               end
            end

            minimize(Term1 + ro*Term2);
            % subject to
            % nothing
        cvx_end
        
        P(r) = length((unique(round(x, 3)','rows'))');
        X{r} = x;
    end
end


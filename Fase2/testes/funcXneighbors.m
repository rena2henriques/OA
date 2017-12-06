function [classPred, x, MSE, points] = funcXneighbors( y, neig, ro, class)
    
    closest = nClosest(y,neig,length(y));
    norm_atual = 0;
    norm_ant = 0;
    
    num_points = Inf;
    for iter=0:5
        if num_points <= 3
            if iter >= 1
                x = x_old;
            end
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

        cvx_end
        x_old = x;
        points = (unique(round(x, 3)','rows'))';
        num_points=length(points(:,1));
    end

    
    % Polishing the results without omegas - only if points is less or equal than 3.
    if length(points(1,:)) <=3 
        
        group=cell(1,3);
        for i=1:length(x);
            for p=1:length(points(1,:))
                if( round(x(:,i),3) == points(:,p)) 
                    group{p}=[group{p}, i];
                end
            end
        end

        % Fazer cvx para as 3 classes

        classPred = zeros(3);

        for p=1:3
            cvx_begin quiet   
                variable pred(3,1);

                Term1=0;

                for k=1:length(group{p})
                    Term1 = Term1 + (y(:, group{p}(k)) - pred)'*(y(:, group{p}(k)) - pred);
                end

                minimize(Term1);

                % subject to  
                %nothing
            cvx_end;

            %inserts point in the predictions array
            classPred(:,p) = pred';

        end

    % Polishing Results with Omegas - only if we have more than 3 points 
    else

    points = (unique(round(x, 3)','rows'))';
    fprintf('Number of points:%d\n',length(points));

    erromin=Inf;
    xpmin=zeros(3,1);
    xqmin=zeros(3,1);
    xrmin=zeros(3,1);


    for i=1:length(points(1,:))
        for j=i+1:length(points(1,:))
            for k=j+1:length(points(1,:))

                    % dar clear dos OmegaP e OmegaQ
                    OmegaP=[];
                    OmegaQ=[]; 
                    OmegaR=[]; 

                    for s=1:60 % for all the sensors
                        %calcular a distancia entre o sensor s e todos os pontos


                        [min_norm, min_ind] = min([norm(y(:,s) - points(:,i)) norm(y(:,s) - points(:,j)) norm(y(:,s) - points(:,k))]);

                        if min_ind==1
                            OmegaP = [OmegaP , s];
                        elseif min_ind==2
                           OmegaQ = [OmegaQ , s];
                        else
                           OmegaR = [OmegaR, s];      
                        end

                    end

                    % obter novas posicoes de xp por minimizacao    
                    cvx_begin quiet   
                    variable xp(3, 1);

                    Term1=0;

                    for w=1:length(OmegaP)
                        Term1 = Term1 + (y(:,OmegaP(w))-xp)'*(y(:,OmegaP(w))-xp);
                    end

                    minimize(Term1);

                    cvx_end;

                    %nova posicao de xq
                    cvx_begin quiet   
                    variable xq(3, 1);            

                    Term1=0;

                    for w=1:length(OmegaQ)
                        Term1 = Term1 + (y(:,OmegaQ(w))-xq)'*(y(:,OmegaQ(w))-xq);
                    end

                    minimize(Term1);

                    cvx_end;
                    cvx_begin quiet   
                    variable xr(3, 1);

                    Term1=0;

                    for w=1:length(OmegaR)
                        Term1 = Term1 + (y(:,OmegaR(w))-xr)'*(y(:,OmegaR(w))-xr);
                    end

                    minimize(Term1);
                    cvx_end;

                    % calculo do erro, comparar com o previous error
                    erro=0;
                    for w=1:length(OmegaP)
                        erro = erro +(y(:,OmegaP(w))-xp)'*(y(:,OmegaP(w))-xp);
                    end
                    for w=1:length(OmegaQ)
                        erro = erro +(y(:,OmegaQ(w))-xq)'*(y(:,OmegaQ(w))-xq);
                    end
                    for w=1:length(OmegaR)
                        erro = erro +(y(:,OmegaR(w))-xr)'*(y(:,OmegaR(w))-xr);
                    end
                    % se for menor, guardar apenas o i e j deste erro
                    % c.c. deixa-se estar
                    if(erro<erromin)
                        erromin=erro;
                        xpmin=xp;
                        xqmin=xq;
                        xrmin=xr;
                    end
                end

            end
        end

        %agora voltar a inserir os 3 valores obtidos para obter melhores
        %estimativas
        % dar clear dos OmegaP e OmegaQ
        OmegaP=[];
        OmegaQ=[]; 
        OmegaR=[]; 

        for s=1:60 % for all the sensors
        %calcular a distancia entre o sensor s e todos os pontos
            [min_norm, min_ind] = min([norm(y(:,s) - xpmin) norm(y(:,s) - xqmin) norm(y(:,s) - xrmin)]);

            if min_ind==1
                OmegaP = [OmegaP , s];
            elseif min_ind==2
                OmegaQ = [OmegaQ , s];
            else
            	OmegaR = [OmegaR, s];      
            end
        end
        % obter novas posicoes de xp por minimizacao    
        cvx_begin quiet   
        variable xp(3, 1);
        Term1=0;
        for w=1:length(OmegaP)
        	Term1 = Term1 + (y(:,OmegaP(w))-xp)'*(y(:,OmegaP(w))-xp);
        end
        minimize(Term1);
        cvx_end;

        cvx_begin quiet   
        variable xq(3, 1);            
        Term1=0;
        for w=1:length(OmegaQ)
        	Term1 = Term1 + (y(:,OmegaQ(w))-xq)'*(y(:,OmegaQ(w))-xq);
        end
        minimize(Term1);
        cvx_end;
        
        cvx_begin quiet   
        variable xr(3, 1);
        Term1=0;
        for w=1:length(OmegaR)
            Term1 = Term1 + (y(:,OmegaR(w))-xr)'*(y(:,OmegaR(w))-xr);
        end
        minimize(Term1);
        cvx_end;

        xpmin=xp;
        xqmin=xq;
        xrmin=xr;
        
        classPred=[xpmin xqmin xrmin];
    end
    %%
    minimum = [];
    error=[];
	for i = 1:ndims(classPred)
        minimum = [];
        for j = 1:length(class)  
        	minimum =[minimum norm(classPred(:,i)-class(:,j))];
        end
        [m mind]= min(minimum);
        mind;
    	error(i) = norm(classPred(:,i)-class(:,mind));
	end
	MSE=sum(error.^2)/3;
    
end


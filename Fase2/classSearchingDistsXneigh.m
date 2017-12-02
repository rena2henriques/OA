%% Generating Points
% equidistant classes
class = [[2 0 0];[0 2 0];[0 0 2];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = fix(rand*3)+1;
    
    y = [y; class(classtype(i),:)];
end


load('noise.mat');
%%
load('ypos2_noise.mat');
factor=1.;
y=y+noise*factor;
y=y';
nei=4;
closest = nClosest(y,nei,60);

%% Grouping points

% Weight of term 2
ro = 5;

norm_atual = 0;
norm_ant = 0;

for iter=0:5
    
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
    
    iter
    
%     plot(y(1,:),y(2,:),'x'); 
%     hold on;
%     plot(x(1,:),x(2,:),'ro');
%     pause(5/1000);
%     hold off;
%     x_old = x;
end


points = (unique(round(x, 3)','rows'))';
fprintf('Number of Points:%d',length(points));



% Polishing the resu   lts without omegas - only if points is less or equal than 3.
if length(points(1,:)) <=3
    
    group=cell(1,3);

    for i=1:60
        for p=1:3
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

        pred'

        %inserts point in the predictions array
        classPred(:,p) = pred';

    end

    minimum = [];
    error=[];
    for i = 1:length(classPred)
        minimum = [];
        for j = 1:length(class)  
            minimum =[minimum norm(classPred(:,i)-class(:,j))];
        end
        [m mind]= min(minimum);
        mind
        error(i) = norm(classPred(:,i)-class(:,mind));
    end


    MSE=sum(error.^2)/3;

    %plot the result
    figure(1); 
    clf; 
    % printing in 2D for now
    plot(y(1,:),y(2,:),'x'); 
    hold on
    plot(x(1,:),x(2,:),'ro');
    figure(2);
    scatter3(x(1,:),x(2,:),x(3,:),'ro');
    hold on
    scatter3(y(1,:),y(2,:),y(3,:),'x');
    axis('equal'); 
    grid on;

% Polishing Results with Omegas - only if we have more than 3 points 
else

    points = (unique(round(x, 3)','rows'))';
    fprintf('Number of points:%d',length(points));

    OmegaP = {};
    OmegaQ = {};
    OmegaR= {};

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
                for k=1:length(OmegaP)
                    erro = erro +(y(:,OmegaP(k))-xp)'*(y(:,OmegaP(k))-xp);
                end
                for k=1:length(OmegaQ)
                    erro = erro +(y(:,OmegaQ(k))-xq)'*(y(:,OmegaQ(k))-xq);

                end
                for k=1:length(OmegaR)
                    erro = erro +(y(:,OmegaR(k))-xr)'*(y(:,OmegaR(k))-xr);
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

    xpmin=xp;
    xqmin=xq;
    xrmin=xr;
%%
    % error 
    minimum = [];
    classPred=[xpmin xqmin xrmin];
    error=[];

    error=[];
    for i = 1:length(classPred)
        minimum = [];
        for j = 1:length(class)  
            minimum =[minimum norm(classPred(:,i)-class(:,j))];
        end
        [m mind]= min(minimum);
        mind
        error(i) = norm(classPred(:,i)-class(:,mind));
    end


    MSE=sum(error.^2)/3;


    
    figure(4);
    %plot the resuts
    hold on;
    scatter3(xrmin(1,:),xrmin(2,:),xrmin(3,:),'ro');
    scatter3(xqmin(1,:),xqmin(2,:),xqmin(3,:),'ro');
    scatter3(xpmin(1,:),xpmin(2,:),xpmin(3,:),'ro');
    scatter3(y(1,:),y(2,:),y(3,:),'x');
    axis('equal'); 
    grid on;
end
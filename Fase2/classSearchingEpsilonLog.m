%% Generating Points
% equidistant classes
class = [[0 0 5];[0 5 0];[5 0 0];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = round(rand*2)+1;
    
    y = [y; class(classtype(i),:)];
end

y = awgn(y, 15, 'measured');
y=y';

%% Grouping points

% distance ref
epsilon = 0.7;

% Weight of term 2
ro = 10

x_old = zeros([3, 60]);

norm_atual = 0;
norm_ant = 0;


for iter=0:20

    cvx_begin quiet
        variable x(3, 60);

        Term1 = 0;
        Term2 = 0;

        for i=1:60
           Term1 = Term1 + (y(:,i) - x(:,i))'*(y(:,i) - x(:,i));
        end

        for i=1:60
           for j=i+1:60
               if ( norm(y(:,i) - y(:,j)) < epsilon )
                  if (iter == 0)
                    norm_atual = norm(x(:,i) - x(:,j));
                     Term2 = Term2+ norm_atual;
                  else
                    norm_atual = norm(x(:,i) - x(:,j));
                    norm_ant = norm(x_old(:,i)-x_old(:,j));
                    Term2 = Term2+ 1/( norm_ant + 10^(-6)) * norm_atual;  
                  end
                 
               end
           end
        end

        minimize(Term1 + ro*Term2);

        % subject to
        % nothing

    cvx_end
    
    iter
    
    x_old = x;
end
%%

%plot the result
figure(1); 
clf; 
% printing in 2D for now
%plot(x(1,:),x(2,:),'ro'); 
scatter3(x(1,:),x(2,:),x(3,:),'ro');
axis('equal'); 
grid on;

%% POLISHING THE PREVIOUS RESULTS

points = (unique(round(x, 3)','rows'))';

OmegaP = {};
OmegaQ = {};
OmegaR= {};

erromin=1000000;
xpmin=zeros(3,1);
xqmin=zeros(3,1);
xrmin=zeros(3,1);


for i=1:length(points(1,:))
    for j=i+1:length(points(1,:))
        for r=j+1:length(points(1,:))

            % dar clear dos OmegaP e OmegaQ
            OmegaP=[];
            OmegaQ=[]; 
            OmegaR=[]; 

            for s=1:60 % for all the sensors
                %calcular a distancia entre o sensor s e o ponto i
                %calcular a distancia entre o sensor s e o ponto j
                if norm(y(:,s) - points(:,i)) < norm(y(:,s) - points(:,j)) && norm(y(:,s) - points(:,i)) < norm(y(:,s) - points(:,r))
                    OmegaP = [OmegaP , s]; %<-- guardamos os indices de todos os sensores que pertencem à classe
                                           %para depois podermos aceder à matriz a e B
                elseif norm(y(:,s) - points(:,j)) < norm(y(:,s) - points(:,i)) && norm(y(:,s) - points(:,j)) < norm(y(:,s) - points(:,r))  
                    OmegaQ = [OmegaQ , s];
                else
                    OmegaR= [OmegaR , s];        
                end

            end

            % obter novas posicoes de xp por minimizacao    
            cvx_begin quiet   
            variable xp(3, 1);

            Term1=0;

                for k=1:length(OmegaP)
                    Term1 = Term1 + (y(:,OmegaP(k)) - xp)'*(y(:,OmegaP(k)) - xp);
                end

            minimize(Term1);

            cvx_end

            %nova posicao de xq
            cvx_begin quiet   
            variable xq(3, 1);

            Term1=0;

            for k=1:length(OmegaQ)
                Term1 = Term1 + (y(:,OmegaQ(k)) - xq)'*(y(:,OmegaQ(k)) - xq);
            end

            minimize(Term1);

            cvx_end
            
            cvx_begin quiet   
            variable xr(3, 1);

            Term1=0;

            for k=1:length(OmegaR)
                Term1 = Term1 + (y(:,OmegaR(k)) - xr)'*(y(:,OmegaR(k)) - xr);
            end

            minimize(Term1);

            cvx_end

            % calculo do erro, comparar com o previous error
            erro=0;
            for k=1:length(OmegaP)
                erro=erro+(y(:,OmegaP(k)) - xp)'*(y(:,OmegaP(k)) - xp);
            end
            for k=1:length(OmegaQ)
                erro=erro+(y(:,OmegaQ(k)) - xq)'*(y(:,OmegaQ(k)) - xq);
            end
            for k=1:length(OmegaR)
                erro=erro+(y(:,OmegaR(k)) - xr)'*(y(:,OmegaR(k)) - xr);
            end
    
            % se for menor, guardar apenas o i e j deste erro
            % c.c. deixa-se estar
            if erro<erromin
                erromin=erro;
                xpmin=xp;
                xqmin=xq;
                xrmin=xr;
            end
        end
    end
end






%%
figure(1); 
clf; 
plot3(xpmin(1),xpmin(2),xpmin(3),'ro'); 
hold on
plot3(xqmin(1),xqmin(2),xqmin(3),'ro'); 
hold on
plot3(xrmin(1),xrmin(2),xrmin(3),'ro'); 
axis('equal'); 
grid on;


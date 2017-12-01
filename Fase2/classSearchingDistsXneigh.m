%% Generating Points
% equidistant classes
class = [[10 0 0];[0 10 0];[0 0 10];];

y = [];
for i = 1:60
    % generates a random integer between 1 and 3
    classtype(i) = round(rand*2)+1;
    
    y = [y; class(classtype(i),:)];
end

y = awgn(y, 15, 'measured');
y=y';

closest = nClosest(y,5,60);
load('y.mat');
%% Grouping points

% Weight of term 2
ro = 1;

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
    
    plot(y(1,:),y(2,:),'x'); 
    hold on;
    plot(x(1,:),x(2,:),'ro');
    pause(5/1000);
    hold off;
    x_old = x;
end
points = (unique(round(x, 3)','rows'))';
fprintf('Number of Points:%d',length(points));

%% Polishing Results 

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
%% error 
minimum = [];
classPred=[xpmin xqmin xrmin]
for j = 1:length(class)
    for i = 1:length(classPred)
        minimum(j,i) = norm(classPred(:,i)-class(:,j));
    end
    [m mind]= min(minimum(j,:));
    mi(j) =  [mind];
end
cP = classPred(:,mi)
for i=1:3
    error(i) = norm(cP(:,i))-norm(class(:,i));
end
error

%%
figure();
%plot the resuts
scatter3(xrmin(1,:),xrmin(2,:),xrmin(3,:),'ro');
hold on
scatter3(xqmin(1,:),xqmin(2,:),xqmin(3,:),'ro');
hold on
scatter3(xpmin(1,:),xpmin(2,:),xpmin(3,:),'ro');
hold on
scatter3(y(1,:),y(2,:),y(3,:),'x');
axis('equal'); 
grid on;


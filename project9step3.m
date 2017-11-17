%
load('group15dataset.mat');

for i=1:64
   B(i)=d(:,i)^2-norm(sensors(:,i))^2;
end
ro=10;

x_old = zeros([2, 64]);
t_old = zeros([64,1]);

norm_atual = 0;
norm_ant = 0;

a=[-2*sensors; ones(1,64)];

%%
for iter=0:30
    
    cvx_begin quiet   
        variable x(2, 64);
        variable t(64);

        Term1=0;
        Term2=0;  
        for i=1:64
            Term1 = Term1 + (a(:,i)'*[x(:,i) ; t(i)] - B(i))^2;
        end

        for i=1:64
            for j=i+1:64
                if(norm(sensors(:,i)-sensors(:,j))==1)
                    if (iter == 0)
                       norm_atual = norm([x(:,i);t(i)]-[x(:,j);t(j)]);
                       Term2=Term2 + norm_atual;
                    else 
                       norm_atual = norm([x(:,i);t(i)]-[x(:,j);t(j)]);
                       norm_ant = norm([x_old(:,i);t_old(i)]-[x_old(:,j);t_old(j)]);
                       Term2 = Term2+ 1/( norm_ant + 10^(-6)) * norm_atual;
                    end
                end
            end
        end
        
        minimize(Term1 + ro*Term2);
        
        % subject to
        for i = 1:64
            x(:,i)'*x(:,i)<= t(i);
        end
        
    cvx_end;
    
    iter
    
    x_old = x;
    t_old = t;
end

%plot the result
figure(1); 
clf; 
plot(x(1,:),x(2,:),'ro'); 
axis('equal'); 
grid on;

%% Part3

% Fazer combinações de 2 entre todos os pontos obtidos para 30 operações da
% part2

% criar um array com todos os valores distintos dos x (atenção que podem
% ser iguais só até uma certa casa decimal

load('part2points.mat');
load('group15dataset.mat');

%variaveis alfa e beta
for i=1:64
   B(i)=d(:,i)^2-norm(sensors(:,i))^2;
end

a=[-2*sensors; ones(1,64)];

points = (unique(round(x, 3)','rows'))';

OmegaP = {};
OmegaQ = {};

erromin=1000000;
xpmin=zeros(2,1);
xqmin=zeros(2,1);

for i=1:length(points(1,:))
    for j=i+1:length(points(1,:))
        
             % dar clear dos OmegaP e OmegaQ
            OmegaP=[];
            OmegaQ=[]; 
        
        for s=1:64 % for all the sensors
            %calcular a distancia entre o sensor s e o ponto i
            %calcular a distancia entre o sensor s e o ponto j
            if (norm(sensors(:,s) - points(:,i)) < norm(sensors(:,s) - points(:,j)))
                OmegaP = [OmegaP , s]; %<-- guardamos os indices de todos os sensores que pertencem à classe
                                       %para depois podermos aceder à matriz a e B
            else    
                OmegaQ = [OmegaQ , s];
            end
            
        end
        
        % obter novas posicoes de xp por minimizacao    
        cvx_begin quiet   
        variable xp(2, 1);
        variable tp;

        Term1=0;

        for k=1:length(OmegaP)
            Term1 = Term1 + (a(:,OmegaP(k))'*[xp(:) ; tp] - B(OmegaP(k)))^2;
        end

        minimize(Term1);
        
        % subject to  
        xp(:)'*xp(:)<= tp;
                   
        cvx_end;
        
        %nova posicao de xq
        cvx_begin quiet   
        variable xq(2, 1);
        variable tq;

        Term1=0;

        for k=1:length(OmegaQ)
            Term1 = Term1 + (a(:,OmegaQ(k))'*[xq(:) ; tq] - B(OmegaQ(k)))^2;
        end

        minimize(Term1);
        
        % subject to  
        xq(:)'*xq(:)<= tq;
                   
        cvx_end;
        
        % calculo do erro, comparar com o previous error
%        erro=0;
        erro = sum( pow2(norm(sensors(:,OmegaP) - xp(:) ) -d(OmegaP) );
        erro += sum( pow2(norm(sensors(:,OmegaQ) - xq(:) ) -d(OmegaQ) );
%        for k=1:length(OmegaP)
%            erro=erro+(norm(sensors(:,OmegaP(k))-xp(:))-d(OmegaP(k)))*(norm(sensors(:,OmegaP(k))-xp(:))-d(OmegaP(k)));
%        end
%        for k=1:length(OmegaQ)
%            erro=erro+(norm(sensors(:,OmegaQ(k))-xq(:))-d(OmegaQ(k)))*(norm(sensors(:,OmegaQ(k))-xq(:))-d(OmegaQ(k)));
%        end
        % se for menor, guardar apenas o i e j deste erro
        % c.c. deixa-se estar
        if(erro<erromin)
            erromin=erro;
            xpmin=xp;
            xqmin=xq;
            
        end
        
    end
end

figure(1); 
clf; 
plot(xp(1),xp(2),'ro'); 
hold on
plot(xq(1),xq(2),'ro'); 
axis('equal'); 
grid on;

% Dividir os sensores todos nos que estão mais próximos do ponto p e nos
% que estão mais próximos do ponto q

% Fazer estimativa de posição para todos os sensores de cada subsecção e
% obter o melhor ponto para cada subsecção

% calcular o erro

% Fazer isto para todas as combinações de pontos e o escolher os pontos que
% gerem o menor erro



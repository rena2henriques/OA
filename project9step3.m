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

% Fazer combina��es de 2 entre todos os pontos obtidos para 30 opera��es da
% part2

% criar um array com todos os valores distintos dos x (aten��o que podem
% ser iguais s� at� uma certa casa decimal



points = (unique(round(x, 3)','rows'))';

OmegaP = {};
OmegaQ = {};

for i=1:length(points(1,:))
    for j=i+1:length(points(1,:))
        
            OmegaP=[];
            OmegaQ=[]; 
        
        for s=1:64 % for all the sensors
            %calcular a distancia entre o sensor s e o ponto i
            %calcular a distancia entre o sensor s e o ponto j
            if (norm(sensors(:,s) - points(:,i)) < norm(sensors(:,s) - points(:,j)))
                OmegaP = [OmegaP , sensors(:,s)]; %<---- VAI ESTAR MAL, CONFIRMAR
            else    
                OmegaQ = [OmegaQ , sensors(:,s)];
            end
            
        end
        
   
        % calculo do erro, comparar com o previous error
        % dar clear dos OmegaP e OmegaQ
        
        % se for menor, guardar apenas o i e j deste erro
        % c.c. deixa-se estar
        
    end
end

% Dividir os sensores todos nos que est�o mais pr�ximos do ponto p e nos
% que est�o mais pr�ximos do ponto q

% Fazer estimativa de posi��o para todos os sensores de cada subsec��o e
% obter o melhor ponto para cada subsec��o

% calcular o erro

% Fazer isto para todas as combina��es de pontos e o escolher os pontos que
% gerem o menor erro



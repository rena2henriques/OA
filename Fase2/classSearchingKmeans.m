load('ypos2_noise.mat');
factor=1.5;
y=y+noise*factor;

[idx,C] = kmeans(y,3);
class = [[2 0 0];[0 2 0];[0 0 2];];

minimum = [];
classPred=[C(:,1) C(:,2) C(:,2)];
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
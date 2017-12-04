function [ MSE ] = mse_func( classPred, class )
minimum = [];
    error=[];
	for i = 1:length(classPred)
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


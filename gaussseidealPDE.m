T = zeros(4,4);
T(1,:) = 100;
n = 10;
for k = 1:n
    for i = 2:3
        for j = 2:3
            T(i,j) = 0.25*(T(i+1,j)+T(i-1,j)+T(i,j+1)+T(i,j-1));
        end
    end
end
T
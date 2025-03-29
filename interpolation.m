function [x] = interpolation(X,Y)

n = length(X);
A = zeros(n,n);
B = zeros(n,1);
for j = 1:n
    B(j) = Y(j);
    for i = 1:n
        A(j,i) = (X(j)^(i-1));
    end
end
x = A\B
A
x1 = [0:0.1:5];
y1 = zeros(length(x1));
for i=1:length(x1)
    for j = 1:length(x)
        y1(i) = y1(i)+x(j)*x1(i)^(j-1);
    end
end
plot(x1,y1)
hold on
plot(X,Y)

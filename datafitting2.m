x = 1:1:10;
a = 8;
n = 9;
y = a*x.^n + (rand(1,10)-0.5);
Y = log(y);
X = log(x);
n = length(X);
A = zeros(n,n);
B = zeros(n,1);
for j = 1:n
    B(j) = Y(j);
    for i = 1:n
        A(j,i) = (X(j)^(i-1));
    end
end
a = ((A')*A);
a
b = A'*B;
b
x = a\b;
x
y 
X
Y




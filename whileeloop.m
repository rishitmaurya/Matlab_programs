tol = 1.e-08;
error = 2*tol;
x = 0.5;
r = 3;
count = 1;
while error>tol
    count = count + 1;
    if count > 1000
        break
    else 
        xold = x;
        x = r*x*(1-x);
        error = abs(x - xold);
    end
    
    
end
plot(x,r);



tol = 1.e-08;
error = 2*tol;
x = [];
x(1) = 0.5;
r = 3;
count = 1;
for n = 2:10
    xold = x(n-1);
    x(n) = r*xold*(1-xold);
end
x
plot(r)

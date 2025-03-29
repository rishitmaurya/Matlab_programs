dt = 0.1;
t = 0:dt:10;
x = 0*t;
x(1)=0.5;
for i = 1:length(t)-1
    x(i+1) = x(i) + dt*(x(i)-2*x(i)^2);

end
plot(t,x)
x


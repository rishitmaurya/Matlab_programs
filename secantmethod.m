x0=1;
x1=2;
for n=1:10
    x=((x1*x0)+2)/(x1+x0);
    x0=x1;
    x1=x;
end
x;



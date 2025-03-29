function fn=e(n)
if n==1||n==2
    fn=1;
elseif n==0
    fn=0;

end
f1=1;
f2=1;

for z=3:n
    fn=f1+f2;
    f1=f2;
    f2=fn;

end
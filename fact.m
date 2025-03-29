function y = fact(n)

if n==0
    y=1;
elseif n<0
    fprintf('please provide valid input\n')
else
    y=1;
    for z = n:-1:1
    y = y*z;
    end
end
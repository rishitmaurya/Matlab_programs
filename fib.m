function [fn] = fib(n)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
phi1=(sqrt(5)+1)/2;
phi2=(sqrt(5)-1)/2;
fn=((phi1^n)-(-phi2)^n)/sqrt(5);
end
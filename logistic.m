function [x] = logistic(n,r,x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=0:n-1
    x=r*x*(1-x);
end
x
end
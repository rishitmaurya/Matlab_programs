clear
%initial condition
x(1)=0.111; 
% parameter interval
k_min=3;
k_max=4;
%iteration step
t=0.001;
k_interval=k_min:t:k_max;
pos=0; %internal variable for position counting
%iteration parameters
N=10^3;
m=150;
for k=k_interval
    pos=pos+1;
    for i=2:N
        x(i)=k*x(i-1)*(1-x(i-1)); %logistic map
   end
    M(:,pos)=x(end-m+1:end)';
end
hold all
plot(k_interval,M,'.k','MarkerSize',2)
xlabel('k')
ylabel('x')
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
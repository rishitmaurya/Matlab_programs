function [theta1,theta2] = inverseKinematics(x,y)
l1=4;
l2=4;
theta1=40;
theta2=60;
X=[0;
   0];
count=0;
e=1;
if sqrt(x^2+y^2)<=l1+l2
    while (count<300 && e>10^(-6))
        Y=X;
        A=[l2*sind(theta1+theta2)-l1*sind(theta1) l2*sind(theta1+theta2);
           l1*cosd(theta1)-l2*cosd(theta1+theta2) -l2*sind(theta1+theta2)];
        b=[x-l1*cosd(theta1)+l2*cosd(theta1+theta2);
           y-l1*sind(theta1)+l2*sind(theta1+theta2)];
        X=A\b;

        theta1=X(1)+theta1;
        theta2=X(2)+theta2;
        count=count+1;
        e=norm(Y-X);
        X
        e
        count
    end
else
    fprintf("Not Reachable");
end
p1=[0 l1*cosd(theta1) x];
p2=[0 l2*sind(theta1) y];
theta1
theta2
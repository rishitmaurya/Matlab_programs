function [X,Y] = twoR(theta1,theta2,l1,l2)
xp1=l1*cosd(theta1);
yp1=l1*sind(theta1);
X=[0,xp1,yp1];

xp2=xp1+(l2*cosd(theta1+theta2));
yp2=yp1+(l2*sind(theta1+theta2));
Y=[0,xp2,yp2];

end
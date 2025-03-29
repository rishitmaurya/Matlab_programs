A=[1 2 3;
   4 5 6;
   7 8 9];


b=[3 4 7]';
B=[8 6 5;
   3 4 1;
   8 1 9];
inverseA=A^(-1);
x=inverseA*B;
z=A\b;
b1=[7 3 9];
b2=[2 9 8];
%X=A\[b1,b2]
X=A\[b1' b2']; %gauss elemination
X
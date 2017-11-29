function [delRgByDelA] = getRgDelByDelA(nodes,a,b)
x = [nodes(1,1), nodes(2,1), nodes(3,1), nodes(4,1)];
y = [nodes(1,2), nodes(2,2), nodes(3,2), nodes(4,2)];
%delNByDelA = [-0.25*(1-b),-0.25*(1+b),0.25*(1+b),0.25*(1-b)];
delNByDelA = [-0.25*(1-b),0.25*(1-b),0.25*(1+b),-0.25*(1+b)];
sumx = 0; sumy = 0;
for i = 1:4
    sumx = sumx + (delNByDelA(i)*x(i));
    sumy = sumy + (delNByDelA(i)*y(i));
end
delRgByDelA = [sumx,sumy];

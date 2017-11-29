function [delRgByDelB] = getRgDelByDelB(nodes,a,b)
x = [nodes(1,1), nodes(2,1), nodes(3,1), nodes(4,1)];
y = [nodes(1,2), nodes(2,2), nodes(3,2), nodes(4,2)];
%delNByDelB = [-0.25*(1-a),0.25*(1-a),0.25*(1+a),-0.25*(1+a)];
delNByDelB = [-0.25*(1-a),-0.25*(1+a),0.25*(1+a),0.25*(1-a)];
sumx = 0; sumy = 0;

for i = 1:4
    sumx = sumx + (delNByDelB(i)*x(i));
    sumy = sumy + (delNByDelB(i)*y(i));
end
delRgByDelB = [sumx,sumy];

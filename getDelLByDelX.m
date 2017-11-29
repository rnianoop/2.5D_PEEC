function [delKByDelX] = getDelLByDelX(nodes,avals)
% delNByDelB = [-0.25*(1-avals(1)),0.25*(1-avals(2)),0.25*(1+avals(3)),-0.25*(1+avals(4))];
delNByDelB = [-0.25*(1-avals(1)),-0.25*(1+avals(2)),0.25*(1+avals(3)),0.25*(1-avals(4))];

sum = 0;
for i = 1:4
    sum = sum + (delNByDelB(i)*nodes(i));
end
delKByDelX = sum;
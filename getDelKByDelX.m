function [delKByDelX] = getDelKByDelX(nodes,bvals)
% delNByDelA = [-0.25*(1-bvals(1)),-0.25*(1+bvals(2)),0.25*(1+bvals(3)),0.25*(1-bvals(4))];
delNByDelA = [-0.25*(1-bvals(1)),0.25*(1-bvals(2)),0.25*(1+bvals(3)),-0.25*(1+bvals(4))];

sum = 0;
for i = 1:4
%     (delNByDelA(i)*nodes(i))
    sum = sum + (delNByDelA(i)*nodes(i));
end
delKByDelX = sum;
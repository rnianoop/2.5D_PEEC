function [lengths] = getQuadLengths(nodes)
n1 = nodes(1,:); n2 = nodes(2,:); n3 = nodes(3,:); n4 = nodes(4,:);

l1 = norm(n1 - n2);
l2 = norm(n2 - n3);
l3 = norm(n3 - n4);
l4 = norm(n4 - n1);

lengths = [l1,l2,l3,l4];
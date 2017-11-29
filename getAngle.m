function [theta] = getAngle(n1,n2,n3)
v1 = n1 - n2;
v2 = n3 - n2;
theta = acos((dot(v1,v2))/(norm(v1)*norm(v2)));
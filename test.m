r = 1.5;
[p,q] = size(group);
for i = 1 : p
rectangle('Position',[group(i,3) - r,group(i,4) - r,2*r,2*r],'Curvature',[1,1]),axis equal
% hold on
end
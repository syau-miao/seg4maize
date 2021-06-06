function [  ] = showLine( xyz0,direction,color )
%SHOWLINE 此处显示有关此函数的摘要
%   此处显示详细说明

t=-10:0.05:10;
xx=xyz0(1)+direction(1)*t;
yy=xyz0(2)+direction(2)*t;
zz=xyz0(3)+direction(3)*t;

scatter3(xx(1),yy(1),zz(1),50,[0 0 0], 'filled');
scatter3(xyz0(1),xyz0(2),xyz0(3),50,[0 1 0], 'filled');
scatter3(xx(end),yy(end),zz(end),50,[0 1 1], 'filled');

plot3(xx,yy,zz,color)
%h.LineWidth = 2;
%hold on;

end


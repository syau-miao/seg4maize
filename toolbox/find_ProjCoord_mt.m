function [ PCoord ] = find_ProjCoord_mt(dir1,center,v)
%FIND_PROJCOORD_MT 计算点V到面P的投影点，P的法向量为dir1，P上一点为center
%%  垂直于dir1的面K公式为   (x-center)*dir1=dir1*x-dir*center
%%  点P按dir1方向到面K的投影为  p'= p+dir1*t;
%%  t的值为
TEMP=(dir1.*center-dir1.*v);
Temp2=(dir1(1)*dir1(1)+dir1(2)*dir1(2)+dir1(3)*dir1(3));
t= (dir1(1)*center(1)+dir1(2)*center(2)+dir1(3)*center(3)-dir1(1)*v(1)-dir1(2)*v(2)-dir1(3)*v(3))./(dir1(1)*dir1(1)+dir1(2)*dir1(2)+dir1(3)*dir1(3));
PCoord=v+dir1.*t;
end


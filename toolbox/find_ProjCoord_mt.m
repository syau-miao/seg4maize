function [ PCoord ] = find_ProjCoord_mt(dir1,center,v)
%FIND_PROJCOORD_MT �����V����P��ͶӰ�㣬P�ķ�����Ϊdir1��P��һ��Ϊcenter
%%  ��ֱ��dir1����K��ʽΪ   (x-center)*dir1=dir1*x-dir*center
%%  ��P��dir1������K��ͶӰΪ  p'= p+dir1*t;
%%  t��ֵΪ
TEMP=(dir1.*center-dir1.*v);
Temp2=(dir1(1)*dir1(1)+dir1(2)*dir1(2)+dir1(3)*dir1(3));
t= (dir1(1)*center(1)+dir1(2)*center(2)+dir1(3)*center(3)-dir1(1)*v(1)-dir1(2)*v(2)-dir1(3)*v(3))./(dir1(1)*dir1(1)+dir1(2)*dir1(2)+dir1(3)*dir1(3));
PCoord=v+dir1.*t;
end


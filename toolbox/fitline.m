function [xyz0 ,direction ] = fitline( lineData)
%FITLINE 此处显示有关此函数的摘要
%   此处显示详细说明
xyz0=mean(lineData,1);
% xyz0=(lineData(1,:)),
% 协方差矩阵奇异变换，与拟合平面不同的是
% 所得直线的方向实际上与最大奇异值对应的奇异向量相同
centeredLine=bsxfun(@minus,lineData,xyz0);
[U,S,V]=svd(centeredLine);
direction=V(:,1)';


end


function [res] = fitline_r( lineData)
%FITLINE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
xyz0=mean(lineData,1),
% xyz0=(lineData(1,:)),
% Э�����������任�������ƽ�治ͬ����
% ����ֱ�ߵķ���ʵ�������������ֵ��Ӧ������������ͬ
centeredLine=bsxfun(@minus,lineData,xyz0);
[U,S,V]=svd(centeredLine);
direction=V(:,1)';
res=[xyz0 direction];


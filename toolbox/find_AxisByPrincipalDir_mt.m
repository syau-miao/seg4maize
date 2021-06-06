function [ Axis ] = find_AxisByPrincipalDir_mt(pts,dir1,center,show_result)
%% find_AxisByPrincipalDir_mt ���ݸ�������������������ϵ
%% ��������ֵ Axis  4*3����   Axis(1,:) ����ԭ��   Axis(2,:)��������  Axis(3,:)�ڶ������� Axis(4,:)����������
%%  ����1
%%  �������е㵽������ֱ���ϵ�ͶӰ����
ptsNum=size(pts,1);
pCoords=zeros(ptsNum,3);
for i=1:ptsNum
  pCoords(i,:)=find_ProjCoord_mt(dir1,center,pts(i,:));   
end
coeff = pca(pCoords);
dir2=coeff(:,1)';
dir3=coeff(:,2)';

Axis=[center;dir1;dir2;dir3];

if(show_result)
    figure('Name','Given Dir Plane','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    
    scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0 0 0], 'filled');
    hold on;
    scatter3( pCoords(:,1), pCoords(:,2), pCoords(:,3),5,[0 1 0], 'filled');
    hold on;
    showLine(center,dir1,'r'); 
    showLine(center,dir2,'g'); 
    showLine(center,dir3,'b'); 
    %showLine(J_J_Center,GrowthDir,'b'); 
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;
    %showLine(xyz,dir,'r');  
  

end

end


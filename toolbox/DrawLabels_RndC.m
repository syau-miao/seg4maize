function  DrawLabels_RndC( points,Regions,FigureName )
%DRAWSEGMENTLABEL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
  if(true)
   figure('Name',FigureName,'NumberTitle','off');set(gcf,'color','white');movegui('southwest');
  
  for i=1:length(Regions)
    color=[rand(1,1) rand(1,1) rand(1,1)];
    I1=Regions{i};
    
     pt=median(points(I1,:),1);
     scatter3(points(I1,1),points(I1,2),points(I1,3),5,color, 'filled');
     hold on;
%      scatter3(pt(:,1),pt(:,2),pt(:,3),20,color, 'filled');
%      hold on;
  end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d ZOOM;

end


function  DrawLabels( points,Regions )
%DRAWSEGMENTLABEL 此处显示有关此函数的摘要
%   此处显示详细说明
  if(true)
   figure('Name','LeafClassify','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=[1 0 0;0 0 1;0 1 0;1 1 0;1 0 1; 0 1 1;0.5 0 0;0 0.5 0;0 0 0.5;0.5 0.5 0;0.5 0 0.5;0 0.5 0.5;0.25 0 0;0 0.25 0;0 0 0.25;0.25 0.25 0];
  for i=1:length(Regions)
    I1=Regions{i};
    scatter3(points(I1,1),points(I1,2),points(I1,3),5,color(i,:), 'filled');
    hold on;
  end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d ZOOM;

end


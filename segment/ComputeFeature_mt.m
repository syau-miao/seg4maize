function [features] = ComputeFeature_mt(AxisPts,K,bDebugShow)
%COMPUTERFEATURE_MT 此处显示有关此函数的摘要
%   此处显示详细说明
  % K=64;
   ptCloud = pointCloud(AxisPts);
   features=zeros(size(AxisPts,1),1);
   for i=1:size(AxisPts,1)
   pt=AxisPts(i,:);
   [indices,~]=findNearestNeighbors(ptCloud,pt,K);
   n_pts=AxisPts(indices,:);
   [~,~,coffes]= pca(n_pts,'Algorithm','eig');  
   e1=coffes(1)/sum(coffes);e2=coffes(2)/sum(coffes);e3=coffes(3)/sum(coffes);
  % features(i)=(e1-e2)/(e1);
   features(i)=(e3)/(e2);
    
   %features(i)=((coffes(2)-coffes(3))/coffes(1));
   end
   if(~bDebugShow)return;end
   figure('Name','TensorFeatures','NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
   XX=jet(256);
   scatter3(AxisPts(:,1),AxisPts(:,2),AxisPts(:,3),10,XX(floor(features.*256)+1), 'filled');
   % hold on;   
    colorbar;   
    hold on
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;
 

   
end


function [ StemLen,StemRadius,StemSkeleton, SkeletonRadius] = StemTrait( pts ,Num,DebugShow)
%STEMTRAIT 此处显示有关此函数的摘要
%   此处显示详细说明
  %Num=20;
  ptsX=pts(:,3);
  [minX,minXId]=min(ptsX); [maxX,maxXId]=max(ptsX);
  StepX=(maxX-minX)/Num;
  StemSkeleton=[0 0 0];
  StemLen=0;
  Radius=[];
  for i=1:Num
     X1=minX+(i-1)*StepX;
     X2=minX+i*StepX;
     indices=find(ptsX>=X1&ptsX<X2);
     pts_in=pts(indices,:);
     if(~isempty(indices))
         StemSkeleton=[StemSkeleton;median(pts_in)];
     end
  end
  v1=StemSkeleton(3,:);
  v2=StemSkeleton(2,:);
  Dir1=(v2-v1)./norm(v2-v1);
  pt1=pts(minXId,:);
  [~, T]=P2LineDistance(v1,Dir1,pt1);
  skeV=v1+T*Dir1;
  StemSkeleton(1,:)=skeV;
  v1=StemSkeleton(end,:);
  v2=StemSkeleton(end-1,:);
  Dir1=(v2-v1)./norm(v2-v1);
  pt1=pts(maxXId,:);
  [~, T]=P2LineDistance(v1,Dir1,pt1);
  skeV=v1+T*Dir1;
  StemSkeleton(end+1,:)=skeV;
  
  SkeletonRadius=zeros(length(StemSkeleton),1);
  for i=1:length(StemSkeleton)-1
     id1=i; id2=i+1;
     v1=StemSkeleton(id1,:);
     v2=StemSkeleton(id2,:);
     StemLen=StemLen+norm(v2-v1);
     Dir1=(v2-v1)./norm(v2-v1);
     X1=v1(3);X2=v2(3);
     indices=find(ptsX>=X1&ptsX<X2);
     pts_in=pts(indices,:); 
     m=[v1 Dir1];
     R=P2LineDistance_r(m,pts_in);
     ids_r=find(ptsX(indices)<(maxX+minX)/2);
     Radius=[Radius;R(ids_r)];
     if(id1>1)
        SkeletonRadius(id1)= 0.5*(SkeletonRadius(id1)+median(R));  
     end
      SkeletonRadius(id2)=median(R);
  end
  SkeletonRadius(1)=SkeletonRadius(2);
 % SkeletonRadius(end)=SkeletonRadius(end-1);
  StemRadius=median(Radius);
  radius=median(Radius);
%   [coeff, ~,score]= pca(pts);
%   center=mean(pts,1);
%   PNum=size(pts,1);
%   Dir1=coeff(:,1)';
%   maxT=-inf;
%   minT=inf;
%   maxR=-inf;
%   Rarray=zeros(size(pts,1),1);
%   for i=1:size(pts,1)
%     pt=pts(i,:);  
%     [R T]=P2LineDistance(center,Dir1,pt);
%     if(T>=maxT)maxT=T;end;
%     if(T<=minT)minT=T;end;
%     Rarray(i)=R;
%   end
%   StemDir=Dir1;
%   StemRadius=median(Rarray);
%   Skeleton=zeros(2,3);
%   Skeleton(1,:)=minT*StemDir+center;
%   Skeleton(2,:)=maxT*StemDir+center;
%   %%%%%%%%%%长度%%%%%%%%%%%%%%%%%%%%%%%
%   v=Skeleton(2,:)-Skeleton(1,:);
%   StemLen=sqrt(v(1)*v(1)+v(2)*v(2)+v(3)*v(3));
%   StemSkeleton=Skeleton;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if(DebugShow)
    figure('Name','Stem Skeleton ','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    scatter3( pts(:,1),pts(:,2),pts(:,3),5,[0 0 0], 'filled');
    hold on;
   % for i=1:length(StemSkeleton)-1
    %id1=i; id2=i+1;
    id1=1; id2=length(StemSkeleton);
    scatter3(StemSkeleton(id1,1),StemSkeleton(id1,2),StemSkeleton(id1,3),25,[0 1 0], 'filled');
    hold on;
    scatter3(StemSkeleton(id2,1),StemSkeleton(id2,2),StemSkeleton(id2,3),25,[0 1 0], 'filled');
    hold on;
    idx = [id1;id2];
    line( StemSkeleton(idx,1),StemSkeleton(idx,2),StemSkeleton(idx,3), 'LineWidth', 2, 'Color', [1 0 1]);
    hold on;
   % end
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(180,0);view3d ZOOM;
  end
end


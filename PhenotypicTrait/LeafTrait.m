function [ leafLen,leafWidth,leafAngle,LeafLenPath,LeafWidthPath] = LeafTrait( pts ,DebugShow)
%LEAFTRAIT 此处显示有关此函数的摘要
%   此处显示详细说明
   [coeff, ~,score]= pca(pts);
   center=mean(pts,1);
   PNum=size(pts,1);
   Dir1=coeff(:,1)';
   axis_=find_AxisByPrincipalDir_mt(pts,Dir1,center,false);
   newpts=Transfer_XYZ2AXIS_mt(pts,axis_); 
   X1=newpts(:,3);Y1=newpts(:,1);Z1=newpts(:,2);
   [minX,minXId]=min(X1); [maxX,maxXId]=max(X1);
   minX_=minX+0.48*(maxX-minX);   maxX_=minX+0.52*(maxX-minX);
   Interval_Id=find(X1>minX_&X1<maxX_);
   times=1;
    while(isempty(Interval_Id))
      minX_=minX+(0.48-times*0.05)*(maxX-minX);   maxX_=minX+(0.52+times*0.05)*(maxX-minX);
      Interval_Id=find(X1>minX_&X1<maxX_); 
      times=times+1;
    end
   %[~,minYId]=min(Y1); [~,maxYId]=max(Y1);
   [minY_,minYId]=min(Y1(Interval_Id)); [maxY_,maxYId]=max(Y1(Interval_Id));
   minYId=Interval_Id(minYId); maxYId=Interval_Id(maxYId);
   %%%%%%%%%%%%%
   [minZ_,minZId]=min(Z1(Interval_Id)); [maxZ_,maxZId]=max(Z1(Interval_Id));
   minZId=Interval_Id(minZId); maxZId=Interval_Id(maxZId);
   
   if((maxZ_-minZ_)>(maxY_-minY_))
      minYId=minZId;maxYId=maxZId; 
   end
   
   %%%%%construct ajmatrix %%%%%%%%%%%%
   
   
   
   D=zeros(length(newpts),length(newpts));
   sumd=0;
   k=0;
   m=length(newpts);
   for i=1:length(newpts)-1
     for j=i+1:length(newpts)  
       vi=newpts(i,:);
       vj=newpts(j,:);
       d=norm(vi-vj);
       sumd=sumd+d;
       k=k+1;
       D(i,j)=d;
       D(j,i)=d;
     end
   end
   
   %计算矩阵中每行前k个值的位置并赋值（先按大小排列）
W1=zeros(m,m);
k=32;
for i=1:m
A=D(i,:);
t=sort(A(:));%对每行进行排序后构成一个从小到大有序的列向量
 k_=k;
if(length(t)<k)
    k_=length(t);
end
[row,col]=find(A<=t(k_),k_);%找出每行前K个最小数的位置
for j=1:k_
c=col(1,j);
 W1(i,c)=D(i,c); %W1(i,c)=1;%给k近邻赋值为距离
end
end
for i=1:m
    for j=1:m
        if W1(i,j)==0&i~=j
            W1(i,j)=inf;
        end
    end
end

   
   
%    thd=sumd/k;
%    AJM(find(AJM>thd))=inf;
   [leafLen,LeafLenPath]=mydijkstra(W1,minXId,maxXId);
   [leafWidth,LeafWidthPath]=mydijkstra(W1,minYId,maxYId);
 %  [leafWidth2,LeafWidthPath2]=mydijkstra(W1,minZId,maxZId);
   %%得到叶片
%    LeafWidthPath=LeafWidthPath1;
%    leafWidth=leafWidth1;
%    if(length(LeafWidthPath)<length(LeafWidthPath2))
%      LeafWidthPath=LeafWidthPath2;
%      leafWidth=leafWidth2;   
%    end
   
   
   
   % LenPath
   pt1=pts(minXId,:);
   pt2=pts(maxXId,:);
   dis1=sqrt(pt1(2)*pt1(2)+pt1(3)*pt1(3));
   dis2=sqrt(pt2(2)*pt2(2)+pt2(3)*pt2(3));
   O_Pt=[];%%%%%%%%%叶片最下端的点
   if(dis1>dis2)
     O_Pt=pt2;
     LeafLenPath=fliplr(LeafLenPath);
   else
     O_Pt=pt1;
   end
   LenPathPts=pts(LeafLenPath,:);
   [~,maxId]=max(LenPathPts(:,1));
   T_Pt=pts(LeafLenPath(maxId),:);
   Dir=(T_Pt-O_Pt)./norm(T_Pt-O_Pt);
   leafAngle=180*acos(Dir(1))/3.1415926;
   
   %return;
    
     if(DebugShow)
          figure('Name','LeafTrait' ,'NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
    scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0 0 0], 'filled');
     hold on;
     scatter3(pts(LeafLenPath,1),pts(LeafLenPath,2),pts(LeafLenPath,3),20,[1 0 0], 'filled');%     hold on;
     hold on;
     scatter3(pts(minYId,1),pts(minYId,2),pts(minYId,3),20,[0 0 1], 'filled');%     dir1=[0 0 1];
     hold on;
     scatter3(pts(maxYId,1),pts(maxYId,2),pts(maxYId,3),20,[0 0 1], 'filled');%     dir1=[0 0 1];
     hold on;
     scatter3(pts(LeafWidthPath,1),pts(LeafWidthPath,2),pts(LeafWidthPath,3),20,[0 0 1], 'filled');%     dir1=[0 0 1];
      hold on;
     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;   
     end


end


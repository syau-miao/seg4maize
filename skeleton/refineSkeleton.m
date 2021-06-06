function [ OrganSkeletons,newSpls,new_spls_Adj] = refineSkeleton(OrganRegions,Pts,Spls,Corresp,Spls_Adj,IdName,isWrite)
%REFINESKELETON 此处显示有关此函数的摘要
%   此处显示详细说明
  pts_label=zeros(size(Pts,1),1);
  A=Spls_Adj; 
  A(A==0)=inf;
  for i=1:size(A,1)
       for j=1:size(A,1)
          if(i==j) A(i,j)=0;end; 
       end
  end
  for i=1:length(OrganRegions)
     regions=OrganRegions{i};
     for j=1:length(regions)
        index=regions(j);
        pts_label(index)=i;
     end
  end
  spls_label=cell(size(Spls,1),1);
  %%splite spls%%
  debugnew=[];
  newSpls=[];%%%%%%%新的SPLS
  newSplsLabels=[];%%%%%%%%新SPLS的LABELS
  Pre2New=[];
  New2Pre=[];
 labelNum= length(OrganRegions);
 OrganSkeletons=cell(labelNum,1);
 %PreOrganSkeletons=
 for i=1:labelNum
    OrganSkeletons{i}=[]; 
 end
  for i=1:size(Spls,1)
     indices=find(Corresp==i);
     labels=pts_label(indices);
     labels_=unique(labels);
     labels_(labels_==0)=[];
     spls_label{i}=labels_;
     newId=[];
     pre2new.bSplit=-1;
     new2pre.bSplit=-1;
     new2pre.parent=-1;
     
     %%%%%%%%%%%如果是单一的类别，则直接加入新骨架数组
     if(length(labels_)==1)
         newSpls=[newSpls;Spls(i,:)];
         newSplsLabels=[newSplsLabels;labels_(1)];
         pre2new.newId=length(newSplsLabels);
         pre2new.bSplit=0;
         new2pre.parent=i;
         New2Pre=[New2Pre;new2pre];
         lab=OrganSkeletons{labels_(1)};
         lab=[lab;i];
         OrganSkeletons{labels_(1)}=lab;
     end%%%%end if
     %%%%%%%%%%如果不是单一的，进行拆分，将拆分的加入新骨架组
     if(length(labels_)>1)
       pre2new.bSplit=1;
       for k=1:length(labels_)
          type=labels_(k);
          ids=indices(find(labels==type));
          pts=Pts(ids,:);
          nspls=mean(pts,1);
          newSpls=[newSpls;nspls];
          newSplsLabels=[newSplsLabels;type];
          debugnew=[debugnew;length(newSplsLabels)];
          newId=[newId;length(newSplsLabels)];  
          pre2new.bSplit=1;
          new2pre.bSplit=1;
          new2pre.parent=i;
          New2Pre=[New2Pre;new2pre];
         lab=OrganSkeletons{labels_(k)};
         lab=[lab;i];
         OrganSkeletons{labels_(k)}=lab;
       end%%end for k
       pre2new.newId=newId;
     end%%%%% end if 
     Pre2New=[Pre2New;pre2new];
  end%%%%%% end for i
  %%%%%%%%%%%%构建器官骨架
%  labelNum= size(OrganRegions,2);
%  OrganSkeletons=cell(labelNum,1);
  PreOrganSkeletons=OrganSkeletons;
 for i=1:labelNum
   nodes=OrganSkeletons{i};
   %%%寻找叶尖节点
   tip=-1;
   for j=1:length(nodes)
      node=nodes(j);
      links = find( A(node,:)==1 );
      if length(links) == 1 % root
       tip=node;
      end%%%%end if
   end%%%%%%end for j
   Dist=[];
   Path=[];
   for j=1:length(nodes)
      c_index=nodes(j);
      [t1, t2]=mydijkstra(A,tip,c_index);
       Dist(j)=t1;
       Path{j}=t2;
   end%%%%%% end for j
  [~, a]= max(Dist);
  PreSkeletons=Path{a};
  PreOrganSkeletons{i}=PreSkeletons;
  NewSkeletons=[];
  for k=1:length(PreSkeletons)
      preId=PreSkeletons(k);
      pre2new=Pre2New(preId);
      newId=pre2new.newId;
      if(length(newId)==1)
         NewSkeletons=[NewSkeletons;newId(1)]; 
      else
        for j=1:length(newId)
           id=newId(j); 
           if(newSplsLabels(id)==i)
             NewSkeletons=[NewSkeletons;id];   
           end %%end if
        end%%%end for
      end%%%end if else
  end%%%%%end for k
  OrganSkeletons{i}=NewSkeletons;
 end%%%%%%%% end for i

 new_spls_Adj=zeros(length(newSplsLabels),length(newSplsLabels));
 %%%%%%%%%%%%%将茎骨架拟合为直线%%%%%%%%%%%%%% 
 stemSkeletons=OrganSkeletons{1};
 stemPts=newSpls(stemSkeletons,:);
 [center,dir]=fitline(stemPts);
 for i=1:length(stemSkeletons)
 [~,  t]=P2LineDistance(center,dir,stemPts(i,:));
   newSpls(stemSkeletons(i),:)= dir*t+center; 
 end
  %%%%%%%%%%%%重新对骨架进行连接
  stemSkeletons=OrganSkeletons{1};
  
  for i=1:labelNum
     nodes=OrganSkeletons{i};
     if(isempty(nodes))
         continue;
     end
     for j=1:length(nodes)-1
        n1=nodes(j);n2=nodes(j+1);
        new_spls_Adj(n1,n2)=1;
        new_spls_Adj(n2,n1)=1;
     end
     if(i==1)continue;end
      n1=nodes(end);
      new2pre=New2Pre(n1);
      n1=nodes(end); v1=newSpls(n1,:);minDis=Inf; minId=-1;
     n_a=nodes(end-1,:);v_a=newSpls(n_a,:);
     dir1=(v_a-v1)./norm(v_a-v1);
     Dis=[];
     for j=1:length(stemSkeletons)
       n2=stemSkeletons(j);
       v2=newSpls(n2,:);
       dis=norm(v2-v1);
       Dis=[Dis;dis];
%        if(minDis>dis)
%            minDis=dis;
%            minId=n2;
%        end
     end
     [~,sindex]=sort(Dis);
     maxc=-1;
     minId=-1;
     for k=1:3
        sid=sindex(k);
        n2=stemSkeletons(sid);
        v2=newSpls(n2,:);
        dir2=(v1-v2)./norm(v1-v2);
        c=dot(dir2,dir1);
        if(k==1&&c>0.5)
           minId=n2;
           break; 
        end
            
        if(c>maxc)
           maxc=c;
           minId=n2;
        end
     end
     newSpls(n1,:)=0.5*v_a+0.5*newSpls(minId,:);
     new_spls_Adj(n1,minId)=1;
     new_spls_Adj(minId,n1)=1;
     OrganSkeletons{i}=[OrganSkeletons{i};minId];
     
     vend=newSpls(minId,:);
%      vend_1=newSpls(OrganSkeletons{i}(end-1),:);
%      vend_2=newSpls(OrganSkeletons{i}(end-2),:);
     vend_3=newSpls(OrganSkeletons{i}(end-3),:);
     stepv=(vend-vend_3)/3;
     newSpls(OrganSkeletons{i}(end-2),:)=vend_3+stepv; 
     newSpls(OrganSkeletons{i}(end-1),:)=vend_3+2*stepv; 
  end
  
 
   k=16;
   adjustIds=[];
  for i=1:length(OrganRegions)
     pts=Pts(OrganRegions{i},:);
     spls= newSpls(OrganSkeletons{i},:);
     kdtree = kdtree_build(pts);% kdtree,用来找k近邻
     %index= zeros(length(spls), k);
     for j = fix(length(spls)/2):length(spls)-1
       index  = kdtree_k_nearest_neighbors(kdtree,spls(j,:),k)';
       spls(j,:)=mean(pts(index,:));
       adjustIds=[adjustIds;OrganSkeletons{i}(j)];
     end
     newSpls(OrganSkeletons{i},:)=spls;
    kdtree_delete(kdtree);
  end
%    
%   
%   
 for i = 1:length(adjustIds)
    id=adjustIds(i);
    links = find( new_spls_Adj(id,:)==1 );   
    %if length(links) == 2
    if length(links) >1
        verts = newSpls(links,:);
        newSpls(id,:) = mean(verts);
    end
end

  
  %%%%%%%%%%%%%%%显示老骨架
   figure('Name','skeleton ','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   A=Spls_Adj; 
   tmax = max(max(A))*1.0;
    edge_num = 0;
    for i=1:(size(A,1)-1)
            for j=(i+1):size(A,2)
                if( A(i,j)>0 )
                    idx = [i;j];
                    color=[1 0 0];
                    line( Spls(idx,1),Spls(idx,2),Spls(idx,3), 'LineWidth', 2, 'Color', color);
%                       text(pts(i,1),pts(i,2),pts(i,3),int2str(i)) ;
                    edge_num = edge_num +1;
                end
            end
    end
    hold on
   scatter3(Spls(:,1),Spls(:,2),Spls(:,3),30,[0,0,1], 'filled');
    color=[1 0 0;0 1 0;0 0 1;1 1 0;1 0 1; 0 1 1;0.5 0 0;0 0.5 0;0 0 0.5;0.5 0.5 0;0.5 0 0.5;0 0.5 0.5;0.25 0.0 0;0 0.25 0.0;0.0 0 0.25;0.25 0.25 0];
   for i=1:length(OrganRegions)
     regions=OrganRegions{i};
     scatter3(Pts(regions,1),Pts(regions,2),Pts(regions,3),2,[0 0 0],'filled');
   end
   
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
  if(isWrite)
   % saveas(gcf,['.\result\',IdName,'_old_s'],'png');
   end
  
  %%%%%%%%%%%%%%%显示新骨架点%%%%%%%%%%%%%%%%%%%
    figure('Name','new_skeleton ','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
     A=new_spls_Adj; 
   tmax = max(max(A))*1.0;
    edge_num = 0;
    for i=1:(size(A,1)-1)
            for j=(i+1):size(A,2)
                if( A(i,j)>0 )
                    idx = [i;j];
                    color=[1 0 0];
                    line( newSpls(idx,1),newSpls(idx,2),newSpls(idx,3), 'LineWidth', 2, 'Color', color);
%                       text(pts(i,1),pts(i,2),pts(i,3),int2str(i)) ;
                    edge_num = edge_num +1;
                end
            end
        end
    hold on
    for i=1:labelNum
    indices=OrganSkeletons{i}; 
    color=[1 0 0;0 1 0;0 0 1;1 1 0;1 0 1; 0 1 1;0.5 0 0;0 0.5 0;0 0 0.5;0.5 0.5 0;0.5 0 0.5;0 0.5 0.5;0.25 0.0 0;0 0.25 0.0;0.0 0 0.25;0.25 0.25 0];
    scatter3(newSpls(indices,1),newSpls(indices,2),newSpls(indices,3),30,[0 0 1], 'filled');
    hold on;
    end
    % scatter3(newSpls(debugnew,1),newSpls(debugnew,2),newSpls(debugnew,3),240,[0,1,0],'filled');
     hold on;
     for i=1:length(OrganRegions)
     regions=OrganRegions{i};
     %scatter3(Pts(regions,1),Pts(regions,2),Pts(regions,3),5,color(i,:),'filled');
     scatter3(Pts(regions,1),Pts(regions,2),Pts(regions,3),2,[0,0,0],'filled');
     end
  %  scatter3(Pts(regions,1),Pts(regions,2),Pts(regions,3),30,color(i,:),'filled');
  
 axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
  if(isWrite)
  %  saveas(gcf,['.\result\',IdName,'_new_s'],'png');
   end  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%%%%%%%%%%%显示叶片骨架%%%%%%%%%%%%%%%%
%    for i=1:labelNum
%        
%    figure('Name','new_leaf_skeleton ','NumberTitle','off');set(gcf,'color','white');movegui('southwest');      
%       A=new_spls_Adj; 
%     indices=OrganSkeletons{i}; 
%     for j=1:length(indices)
%       for k=1:length(indices) 
%           id1=indices(j);id2=indices(k);
%           if(id1==id2)continue;end
%             if( A(id1,id2)>0 )
%                     idx = [id1;id2];
%                     color=[1 0 0];
%                     line( newSpls(idx,1),newSpls(idx,2),newSpls(idx,3), 'LineWidth', 2, 'Color', color);
%              end
%       end
%     end
%     hold on;
%     scatter3(newSpls(indices,1),newSpls(indices,2),newSpls(indices,3),25,[0 0 1], 'filled');
%     hold on;
%     regions=OrganRegions{i};
%     scatter3(Pts(regions,1),Pts(regions,2),Pts(regions,3),10,[0,0,0],'filled');
%     hold on;
%      axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(180,0);view3d ZOOM;
%    end
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  
end


function [ organ_subskeleton,spls ] = SkeletonDecomposition(spls, joints,roots, spls_adj,show_results )
%CLASSIFYROOT  recognize the only stem root vertex from all the root vertices
%output: organ_subskeleton .The last element is the stem sub_skeleton. The rest is the leaf sub_skeleton 
%%%%%%%%%%%%%initial%%%%%%%%%%%%%%%%
rootNum=size(roots,1);
jointNum=size(joints,1);
[s_adj_Num]=size(spls,1);
adjmatrix=zeros(s_adj_Num,s_adj_Num);
sindex=1;
for i=1:s_adj_Num
    for j=1:s_adj_Num
    temp=spls_adj(i,j);
     if(temp==0)
       adjmatrix(i,j)=inf;
     end
      if(temp~=0)
       adjmatrix(i,j)=1;
     end
     if(i==j)
         adjmatrix(i,j)=0;
     end
    end
end
%%%%%%calculated the leaf sub-skeleton%%%%%%%%%%%%%
organ_subskeleton=cell(rootNum,1);
for i=1:rootNum
  r_index=roots(i);
  Dist=[];
  Path=[];
  for j=1:jointNum
    c_index=joints(j);
    [t1, t2]=mydijkstra(adjmatrix,r_index,c_index);
    Dist(j)=t1;
    Path{j}=t2;
  end
  [~, a]= min(Dist);
  b=Path{a};
  [~,tnum]=size(b);
  organ_subskeleton{sindex}=b(1:tnum);
  sindex=sindex+1;
end
%%%%%%find the unique non leaf sub-skeleton from all the leaf sub_skeletons%%%%%%%%%%%%%
d_v=zeros(rootNum,3);
for i=1:rootNum
   indices= organ_subskeleton{i};
   vi_end=indices(end);
   vi_mid=indices(floor(end/2));
   v_end=spls(vi_end,:);
   v_mid=spls(vi_mid,:);
   d_v(i,:)=(v_mid-v_end)./norm(v_mid-v_end);
end
d_v2=d_v*d_v';
sumV=sum(d_v2,1);
[~,index]=min(sumV);
%stem_root=roots(index);
stem_root=roots(1);

%%%%%%%calculated the stem_subskelton
organ_subskeleton(index)=[];
  r_index=stem_root;
  Dist=[];
  Path=[];
  for j=1:jointNum
    c_index=joints(j);
    [t1, t2]=mydijkstra(adjmatrix,r_index,c_index);
    Dist(j)=t1;
    Path{j}=t2;
  end
  [~, a]= max(Dist);
  b=Path{a};
  [~,tnum]=size(b);
  organ_subskeleton{end+1}=b(1:tnum);
  
%%%%%%%%Optimize the 3D position of stem vertices  
  for i=3:length(b)
     index1=b(i-2); 
     index2=b(i-1);
     index3=b(i);
     spl_1=spls(index1,:);
     spl_2=spls(index2,:);
     spl_3=spls(index3,:);
     r=norm(spl_3-spl_2);
     dir=(spl_2-spl_1)./norm(spl_2-spl_1);
     spl_4=spl_2+dir*r;
     spls(index3,:)=0.5*(spl_4+spl_3);
  end
  
if show_results
figure('Name','SkeletonDecomposetion','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   for i=1:length(organ_subskeleton)
       indices=organ_subskeleton{i};
       cr=rand(1,1);
       cg=rand(1,1);
       cb=rand(1,1);
       color=[cr cg cb];
       if(i==length(organ_subskeleton))
           color=[0 0 0];
       end
       scatter3(spls(indices,1),spls(indices,2),spls(indices,3),20,color, 'filled');
       hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;
end

end


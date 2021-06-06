function [ organ_subskeleton] = SkeletonDecomposition2(mainskeleton,spls, joints,roots, spls_adj,corresp,features,show_results )
%CLASSIFYROOT  recognize the only stem root vertex from all the root vertices
%output: organ_subskeleton .The last element is the stem sub_skeleton. The rest is the leaf sub_skeleton 
%%%%%%%%%%%%%initial%%%%%%%%%%%%%%%%
rootNum=size(roots,1);
jointNum=size(joints,1);
[s_adj_Num]=size(spls,1);
adjmatrix=zeros(s_adj_Num,s_adj_Num);
sindex=1;

 G = spls_adj;
 hascycle=false;
cycles = findcycles(sparse(G));
for i = 1:length(cycles)
    cycle = cycles{i};
    if length(cycle)<3
        continue
    end
     hascycle=true;
     break;
end





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
organ_subskeleton=cell(0,1);
deleteRoot=[];
for i=1:rootNum
  r_index=roots(i);
  if(~ismember(mainskeleton,r_index))
      continue;
  end
  Dist=[];
  Path=[];
  isolated=false;
  for j=1:jointNum
    c_index=joints(j);
     if(~ismember(mainskeleton,r_index))
      continue;
    end
    [t1, t2]=mydijkstra(adjmatrix,r_index,c_index);
    if(length(t2)==0)
    isolated=true;
    break;
    end
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
d_v=zeros(length(organ_subskeleton),3);
skelen=[];
skefeature=[];
for i=1:length(organ_subskeleton)
   indices= organ_subskeleton{i};
   if(length(indices)<3)
      skefeature=[skefeature;-Inf]; 
      d_v(i,:)=[0 0 0];
      continue;
   end
  skelen=[skelen;length(indices)/length(spls)];
   fsum=0;
   psum=0;
   for j=1:length(indices)
   pids=find(corresp==indices(j));
   fsum=fsum+sum(features(pids));
   psum=psum+length(pids);
   end
   mf=fsum./psum;
   skefeature=[skefeature;mf];
   vi_end=indices(end);
   vi_mid=indices(floor(end/2));
   v_end=spls(vi_end,:);
   v_mid=spls(vi_mid,:);
   d_v(i,:)=(v_mid-v_end)./norm(v_mid-v_end);
end
d_v2=d_v*d_v';
sumV=sum(d_v2,1);
%negNum=length(find(sumV<0));
if(hascycle)
ids=find(sumV<inf);
skelen=skefeature;
lens=skelen(ids);
[~,id]=max(lens);
index=ids(id);
 else
  [~,index]=min(sumV);     
 end
stem_root= organ_subskeleton{index}(1);

%%%%%%%calculated the stem_subskelton
  organ_subskeleton(index)=[];
  r_index=stem_root;
  Dist=[];
  Path=[];
  for j=1:jointNum
    c_index=joints(j);
    if(~ismember(mainskeleton,c_index))
      continue;
    end
    [t1, t2]=mydijkstra(adjmatrix,r_index,c_index);
    Dist(j)=t1;
    Path{j}=t2;
  end
  [~, a]= max(Dist);
  b=Path{a};
  [~,tnum]=size(b);
  organ_subskeleton{end+1}=b(1:tnum);
  
if show_results
figure('Name','SkeletonDecomposetion','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   for i=1:length(organ_subskeleton)
       indices=organ_subskeleton{i};
       cr=rand(1,1);
       cg=rand(1,1);
       cb=rand(1,1);
       color=[cr cg cb];
         scatter3(spls(indices,1),spls(indices,2),spls(indices,3),20,color, 'filled');
       hold on;
       if(i==length(organ_subskeleton))
           color=[0 0 0];
              scatter3(spls(indices,1),spls(indices,2),spls(indices,3),20,color, 'filled');
              hold on;
              scatter3(spls(indices(1),1),spls(indices(1),2),spls(indices(1),3),100,color, 'filled');  
              hold on;
       end    
        if(i==length(organ_subskeleton)-1)
           color=[0 1 0];
              scatter3(spls(indices,1),spls(indices,2),spls(indices,3),50,color, 'filled');
              hold on;
       end     
       hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot; 
end
   %%%%%%%%%%% splite cycles %%%%%%%%%%%%%%%%%%%%
 [xyz0,stemdir]=fitline(spls(b(1:3),:));
  G = spls_adj;
cycles = findcycles(sparse(G));
kept_joints = zeros(0,1);
%%%%%%%找到需要被分离的joints%%%%%%%%%
J_S=[];
C_S=cell(0,1);
J_id=1;
for i = 1:length(cycles)
    cycle = cycles{i};
    if length(cycle)<3
        continue
    end
   jid=[];
   
   
%    figure('Name','cycle','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
%        color=[1 0 0];
%            scatter3(spls(:,1),spls(:,2),spls(:,3),5,[0 0 0], 'filled');
%            hold on;
%        scatter3(spls(cycle,1),spls(cycle,2),spls(cycle,3),40,color, 'filled');
%    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot; 
   
   
   for j = 1:length(cycle)  
        if ismember(cycle(j), joints)% a joint
            id = cycle(j);
            jid=[jid;id];
        end
   end
  jointV=spls(jid,:); 
  m=[xyz0 stemdir];
  [ distances] = P2LineDistance_r(m,jointV);
  [d_,id_]=max(distances);
  J_S=[J_S;jid(id_)];
  C_S{J_id}=cycle;
  J_id=J_id+1;
end

if(isempty(J_S))return;end;
 for i=1:length(J_S)
 joints(joints==J_S(i))=[];
 end
 for i=1:length(J_S)
   id_=J_S(i); 
   neis=spls_adj(id_,:);
   neis=find(neis==1);
   %%%%%%如果连接点仅有3个，说明环上有2个，还有1个在器官里%%
   %%则将环上的一个点作为新的root，将换上另外一个点到其最近joint点
   %%之间的路径加入到已有的器官骨架中
   if(length(neis)==3)
    cycle=C_S{i};
    ov=-1;
    cv=[];
    new_r=-1;
    new_b=-1;
    for j=1:length(neis)
      if ismember(neis(j), cycle)
         cv=[cv;neis(j)];
      else
         ov=neis(j); 
      end
    end 
    ov_s=spls(ov,:);
    cv_s1=spls(cv(1),:);
    cv_s2=spls(cv(2),:);
    j_s=spls(id_,:);
    od=(ov_s-j_s)./norm(ov_s-j_s);
    cvd1=(j_s-cv_s1)./norm(j_s-cv_s1);
    cvd2=(j_s-cv_s2)./norm(j_s-cv_s2);
    d1=sum(od.*cvd1);
    d2=sum(od.*cvd2);
    if(d1>d2)
        new_r=cv(2);
        new_b=cv(1);
    else
        new_b=cv(2);
        new_r=cv(1);
    end
    adjmatrix(id_,new_r)=Inf;
    adjmatrix(new_r,id_)=Inf;
  Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,new_r,c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_=Path{a};
   organ_subskeleton{end+1}=organ_subskeleton{end};
   organ_subskeleton{end-1}=b_;   
   Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,new_b,c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_=Path{a};
 for k = 1:length(organ_subskeleton)-1 
   subsk=organ_subskeleton{k};
   if ismember(id_, subsk)% a joint
     organ_subskeleton{k}=[subsk b_]; 
   end
 end
 stemk=organ_subskeleton{end};
 ds=[];
 for k=1:length(organ_subskeleton{end})
    id_2=stemk(k);
    if(ismember(id_2,b_))
      ds=[ds;k];  
    end
 end
 stemk(ds)=[];
 organ_subskeleton{end}=stemk;  
 
  %%%%%%如果连接点有4个，说明环上有2个，还有2个在器官里%%
   %%则环拆分为两个骨架，分别加入到对应器官里
 elseif(length(neis)==4)
    cycle=C_S{i};
    ov=[];
    cv=[];
    for j=1:length(neis)
      if ismember(neis(j), cycle)
         cv=[cv;neis(j)];
      else
         ov=[ov;neis(j)]; 
      end
    end 
    ov_s1=spls(ov(1),:);
    ov_s2=spls(ov(2),:);
    cv_s1=spls(cv(1),:);
    cv_s2=spls(cv(2),:);
    j_s=spls(id_,:);
    od1=(ov_s1-j_s)./norm(ov_s1-j_s);
    od2=(ov_s2-j_s)./norm(ov_s2-j_s);
    cvd1=(j_s-cv_s1)./norm(j_s-cv_s1);
    cvd2=(j_s-cv_s2)./norm(j_s-cv_s2);
    d1=sum(od1.*cvd1);
    d2=sum(od1.*cvd2);
    d3=sum(od2.*cvd1);
    d4=sum(od2.*cvd2);
    adjmatrix(id_,ov(1))=Inf;
    adjmatrix(ov(1),id_)=Inf;
     adjmatrix(id_,ov(2))=Inf;
    adjmatrix(ov(2),id_)=Inf;
     adjmatrix(id_,cv(1))=Inf;
    adjmatrix(cv(1),id_)=Inf;
     adjmatrix(id_,cv(2))=Inf;
    adjmatrix(cv(2),id_)=Inf;
   % [~,mid]=max([d1 d2 d3 d4]);
    if(d1+d4>d2+d3) 
    % if(mid==1||mid==4)    
%       一组od1,cvd1
%       二组od2,cvd2
  Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,cv(1),c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_1=Path{a};
  
   Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,cv(2),c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_2=Path{a};
 for k = 1:length(organ_subskeleton)-1 
   subsk=organ_subskeleton{k};
   if ismember(ov(1), subsk)% a joint
     organ_subskeleton{k}=[subsk b_1]; 
     break;
   end
 end
 for k = 1:length(organ_subskeleton)-1 
   subsk=organ_subskeleton{k};
   if ismember(ov(2), subsk)% a joint
     organ_subskeleton{k}=[subsk b_2]; 
   end
 end
%  stemk=organ_subskeleton{end};
%  ds=[];
%  for k=1:length(organ_subskeleton{end})
%     id_2=stemk(k);
%     if(ismember(id_2,b_1))
%       ds=[ds;k];  
%     end
%     if(ismember(id_2,b_2))
%       ds=[ds;k];  
%     end
%  end
%    stemk(ds)=[];
%    organ_subskeleton{end}=stemk; 
 else
%       一组od1,cvd2
%       二组od2,cvd1
  Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,cv(1),c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_1=Path{a};
  Dist=[];
  Path=[]; 
  for k=1:length(joints)
    c_index=joints(k);
    [t1, t2]=mydijkstra(adjmatrix,cv(2),c_index);
    Dist(k)=t1;
    Path{k}=t2;
  end
  [~, a]= min(Dist);
  b_2=Path{a};
 for k = 1:length(organ_subskeleton)-1 
   subsk=organ_subskeleton{k};
   if ismember(ov(1), subsk)% a joint
     organ_subskeleton{k}=[subsk b_2]; 
     break;
   end
 end
 for k = 1:length(organ_subskeleton)-1 
   subsk=organ_subskeleton{k};
   if ismember(ov(2), subsk)% a joint
     organ_subskeleton{k}=[subsk b_1]; 
   end
 end
%  stemk=organ_subskeleton{end};
%  ds=[];
%  for k=1:length(organ_subskeleton{end})
%     id_2=stemk(k);
%     if(ismember(id_2,b_1))
%       ds=[ds;k];  
%     end
%     if(ismember(id_2,b_2))
%       ds=[ds;k];  
%     end
%  end
%  stemk(ds)=[];
%  organ_subskeleton{end}=stemk; 
    end
   end
 end
 
 
 %%%%%%%%%%%重新计算茎骨架%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%calculated the stem_subskelton
  organ_subskeleton(end)=[];
  r_index=stem_root;
  Dist=[];
  Path=[];
  for j=1:length(joints)
    c_index=joints(j);
    if(~ismember(mainskeleton,c_index))
      continue;
    end
    [t1, t2]=mydijkstra(adjmatrix,r_index,c_index);
    Dist(j)=t1;
    Path{j}=t2;
  end
  [~, a]= max(Dist);
  b=Path{a};
  [~,tnum]=size(b);
  organ_subskeleton{end+1}=b(1:tnum);


if show_results
figure('Name','SplitSkeletonDecomposetion','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   for i=1:length(organ_subskeleton)
       indices=organ_subskeleton{i};
       cr=rand(1,1);
       cg=rand(1,1);
       cb=rand(1,1);
       color=[cr cg cb];
         scatter3(spls(indices,1),spls(indices,2),spls(indices,3),20,color, 'filled');
       hold on;
       if(i==length(organ_subskeleton))
           color=[0 0 0];
              scatter3(spls(indices,1),spls(indices,2),spls(indices,3),20,color, 'filled');
              hold on;
              scatter3(spls(indices(1),1),spls(indices(1),2),spls(indices(1),3),100,color, 'filled');  
              hold on;
       end    
        if(i==length(organ_subskeleton)-1)
           color=[0 1 0];
              scatter3(spls(indices,1),spls(indices,2),spls(indices,3),50,color, 'filled');
              hold on;
       end     
       hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot; 




end




end


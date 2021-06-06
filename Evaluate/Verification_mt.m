function [Precison,Recall,Micro_F1,Macro_F1,OA,Precisons,Recalls,F1s,RegionsCorresp] = Verification_mt(pts, trueRegions, autoRegions,ptnum,IdName,isWrite)
%VERIFICATION_MT 此处显示有关此函数的摘要
%   此处显示详细说明
 t_size=length(trueRegions);
 a_size=length(autoRegions);
 CorrespIndex=zeros(t_size,1);
 CorrespMax=zeros(t_size,1);
 for i=1: t_size
   t_indices=trueRegions{i};
   interNum=zeros(a_size,1);
   for j=1:a_size
     a_indices= autoRegions{j};  
     inter=intersect(t_indices,a_indices);
     interNum(j)=length(inter);
   end
   [maxNum,idx]=sort(interNum);
   CorrespIndex(i)=idx(end);
   CorrespMax(i)=maxNum(end);
 end
 %%%%%%%%%如果出现多个trueRegions对应一个autoRegions的情况
 %%%%%%%%%选取交集最大的作为对应，剩下的认为是FN
 for i=1:t_size
      if(CorrespIndex(i)==-1)
          continue;
      end
   for j=i+1:t_size 
      if(CorrespIndex(j)==-1)
          continue;
      end
      if(CorrespIndex(i)==CorrespIndex(j))
         if(CorrespMax(i)>CorrespMax(j))
           CorrespIndex(j)=-1;
           CorrespMax(j)=-1;
         else
           CorrespIndex(i)=-1;  
          CorrespMax(i)=-1;
         end
      end
   end
 end
 RegionsCorresp=CorrespIndex;
%  autoLabels=zeros(ptnum,1);
%  trueLabels=zeros(ptnum,1);
% for i=1:length(autoRegions)
%    label=find(CorrespIndex==i);
%    if(isempty(label))
%        label=-1;
%    end
%    ids=autoRegions{i};
%    autoLabels(ids)=label;
% end
% for i=1:length(trueRegions)
%    ids=trueRegions{i};
%    trueLabels(ids)=i;  
% end
precison=zeros(t_size,1);recall=zeros(t_size,1);f1_score=zeros(t_size,1);
for i=1:length(trueRegions)
  tr=trueRegions{i};
  j=CorrespIndex(i,1);
  if(j==-1)
     precison(i)=0; recall(i)=0;f1_score(i)=0;
     continue;
  end
  ar=autoRegions{j};
  precison(i)=CorrespMax(i)/length(ar);
  recall(i)=CorrespMax(i)/length(tr);
  if(recall(i)==0||precison(i)==0)
      f1_score(i)=0;
  else
  f1_score(i)=2*precison(i)*recall(i)/(recall(i)+precison(i));
  end
end
Precison=mean(precison);
Recall=mean(recall);
Micro_F1=2*(Precison*Recall)/(Precison+Recall);
Macro_F1=mean(f1_score);

Precisons=precison;
Recalls=recall;
F1s=f1_score;

OA=sum(CorrespMax)/ptnum;
 if(true)
    figure('Name','True segment','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    hold on;
    color=MyGS.MYCOLOR;
    for i=1:length(trueRegions)
    %for i=1:1
    ids=trueRegions{i};
    scatter3(pts(ids,1),pts(ids,2),pts(ids,3),5,color(i,:), 'filled');
    hold on;
    end
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
    if(isWrite)
    saveas(gcf,['.\result\',IdName,'_T'],'png');
    end
  end
 
 if(true)
    figure('Name','auto segment','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    hold on;
    color=MyGS.MYCOLOR; 
    for i=1:length(autoRegions)
    %for i=1:1
    region=autoRegions{i};
    trId= find(CorrespIndex(:,1)==i);
    if(isempty(trId))
        trId=length(color)-1;
    end
    trId=trId(1);
    scatter3(pts(region,1),pts(region,2),pts(region,3),5,color(trId,:), 'filled');
    hold on;
    end
     
    
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(180,0);view3d ZOOM;
    if(isWrite)
    saveas(gcf,['.\result\',IdName,'_A'],'png');
    end
end

 
 
 
end


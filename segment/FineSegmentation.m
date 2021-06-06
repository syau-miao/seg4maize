function [ Regions ] = FineSegmentation( points,bottomStem,leafSeeds,unSegment,sample1,sample2,coeff1,coeff2,DebugShow )
%FINESEGMENTATION 此处显示有关此函数的摘要
%   此处显示详细说明
 leafNum=length(leafSeeds);
 UnSegPts=points(unSegment,:);
 %EFF=UnSegPts(:,3);
 EFF=sum((UnSegPts-bottomStem).*(UnSegPts-bottomStem),2);
 [sortZ, SortIndices]=sort(EFF,'descend');
if(DebugShow)
   figure('Name','RoughSegment','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
  color=MyGS.MYCOLOR;
   scatter3(points(:,1),points(:,2),points(:,3),5,[0.0 0.0 0], 'filled');
   hold on;
   for i=1:length(leafSeeds)
   I1=leafSeeds{i};
   scatter3(points(I1,1),points(I1,2),points(I1,3),5,color(i,:), 'filled');
   hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
end 

   for i=1:size(SortIndices,1)
       index=SortIndices(i); 
       pt=UnSegPts(index,:);
       Dis1=zeros(leafNum,1); 
       a1=1.0;a2=coeff1;SampleNum=sample1;SampleNum2=sample2; a3=7;     
       for j=1:leafNum
          ids=leafSeeds{j};
%           stopx=stopX(j);
%          startx=startX(j);
%           if(stopx>pt(1))
%               Dis1(j)=Inf;
%               continue;
%           end
          leafPts=points(ids,:);      
          Dis1(j)=caldis1(leafPts,pt,SampleNum); 
       end
     [sortDis1,SortIndices1]=sort(Dis1,'ascend');
     s1=SortIndices1(1); s2=SortIndices1(2);
     d1=sortDis1(1);     d2=sortDis1(2);
   %  min_id=s1;
%      if(s1==1||s2==1)
%         min_id=s1; 
%      else
     if(abs(d2-d1)/(d1)>coeff2)
         min_id=s1; 
     else
         ids=leafSeeds{s1};
         leafPts=points(ids,:);
         %d1_2=caldis2(leafPts,nts,pt,nt,SampleNum2);  
         d1_2=caldis2(leafPts,pt,SampleNum2);  
         ids=leafSeeds{s2};
         leafPts=points(ids,:);
         %d2_2=caldis2(leafPts,nts,pt,nt,SampleNum2);
         d2_2=caldis2(leafPts,pt,SampleNum2);
         if(d1_2==Inf||d2_2==Inf)
             sd1=a1*d1;  sd2=a1*d2;
         else 
            sd1=a1*d1+a2*d1_2;  sd2=a1*d2+a2*d2_2;
         end
         if(sd1>sd2)
               min_id=s2;
         else
             min_id=s1;
         end
     end
     temp=leafSeeds{min_id};
     temp=[temp;unSegment(index)];
     leafSeeds{min_id}=temp;
 
    
   if(DebugShow&&mod(i,20000)==0) 
   figure('Name','LeafClassify','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
   scatter3(points(:,1),points(:,2),points(:,3),5,[0 0.0 0.0], 'filled');
   hold on;
   scatter3(UnSegPts(:,1),UnSegPts(:,2),UnSegPts(:,3),5,[0 0 0], 'filled');
   hold on; 
%    scatter3(points(newleaf,1),points(newleaf,2),points(newleaf,3),40,[0 0 1], 'filled');
%    hold on;
    for i=1:length(leafSeeds)
    I1=leafSeeds{i};
    scatter3(points(I1,1),points(I1,2),points(I1,3),5,color(i,:), 'filled');
    hold on;
    end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
   end
   end
   Regions=leafSeeds';
% if(true)
%    figure('Name','基于欧拉距离LeafClassify','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
%    color=MyGS.MYCOLOR;
%    scatter3(points(:,1),points(:,2),points(:,3),5,[0 0 0], 'filled');
%    hold on;
%     for i=1:length(leafSeeds)
%     I1=leafSeeds{i};
%     scatter3(points(I1,1),points(I1,2),points(I1,3),5,color(i,:), 'filled');
%     hold on;
%     end
%    axis on; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
%    end 
end



function [min_dis]= caldis2(points,pt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
  % rad=abs(vs(:,3))+1.5*abs(vs(:,1))+1.5*abs(vs(:,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num<sampleNum)
       sampleNum=num;
   end
   indices=sortIndices(1:sampleNum);
   samplePts=points(indices,:);
   [coeff,~,~]=pca(samplePts);
    projd=Inf;
    if(size(coeff,2)==3)
    normal=coeff(:,3)';
    Spt=mean(samplePts);
    %Spt=samplePts(1,:);
    pjs=find_ProjCoord_mt(normal,Spt,pt);
  %  pjs2=find_ProjCoord_mt(normal,Spt,samplePts);
  %  vs=pjs2-samplePts;
  %  projds=sqrt(sum(vs.*vs,2));
  %  mprojds=mean(projds);
    v=pjs-pt;projd=sqrt(v(1)*v(1)+v(2)*v(2)+v(3)*v(3));
  %  projd=abs(projd-mprojds);
    projd=abs(projd);
    end
   min_dis=projd;
end


function [min_dis]= caldis3(points,nts,pt,nt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num<sampleNum)
       sampleNum=num;
   end
   indices=sortIndices(1:sampleNum);
   nts_=nts(indices,:);
   ndotn=nts_.*nt;
   ndotn=abs(sum(ndotn,2));
   min_dis=mean(ndotn);
end


function [min_dis]= caldis1(points,pt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
  % rad=abs(vs(:,3))+1.5*abs(vs(:,1))+1.5*abs(vs(:,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num>sampleNum)
   min_dis=mean(sortr(1:sampleNum));
   else
   min_dis=mean(sortr(1:num)); 
   end
end


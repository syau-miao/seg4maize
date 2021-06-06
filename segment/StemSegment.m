function [ FinalRegion,WrongRegion ] = StemSegment( points,unknowns,PA_StartX,beta,idstop,DebugShow )
%STEMSEGMENT_MT 此处显示有关此函数的摘要
%   此处显示详细说明
  temp=sort(unique(PA_StartX));
  %%% Height constraint 
  StopZ=temp(end);
  if(length(temp)>1)
  StopZ=temp(end-idstop);
  end
   StemIndices=unknowns;
   UnSegmentIndices=[];
   pts=points(unknowns,:);
   stemPts= pts;
   stemZ=stemPts(:,3);mz=median(stemZ);
   
    uindex=StemIndices(find(stemZ>StopZ));
    UnSegmentIndices=[UnSegmentIndices;uindex];
    StemIndices=setdiff(StemIndices,uindex);
    stemPts=points(StemIndices,:);
if(DebugShow)
     figure('Name','jj','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
     scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0.0 0.0 0], 'filled');
     hold on
     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d rot;        
    figure('Name','Height constraint','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
     scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0.0 0.0 0], 'filled');
     hold on
     scatter3(points(UnSegmentIndices,1),points(UnSegmentIndices,2),points(UnSegmentIndices,3),10,[1 0 1], 'filled');
     hold on
     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d rot;      
end

%%%%%%%%%%%%%%%radius constraint%%%%%%%%%%%%%%%%%%%%%%%%%%%
   stemZ=stemPts(:,3);mz=median(stemZ);
   bottomIndices=find(stemZ<mz/2);
   bottomStemPts=stemPts(bottomIndices,:);
  %  Ids=ransacline(bottomStemPts,10)+1;
%    %if(length(Ids)>length(bottomStemPts)/2)
 % bottomStemPts=bottomStemPts(Ids,:); 
   %end
   [res]=fitline_r(bottomStemPts);
    center=[res(1) res(2) res(3)]; 
    dir=[res(4) res(5) res(6)];
    total=[];
    for i=1:size(stemPts,1)
        pt=stemPts(i,:);
    [dis,~ ]=P2LineDistance(center,dir,pt);
    total=[total;dis];
    end
    mdis=beta*median(total(bottomIndices));
   % mdis=0.5*(mindis+median(total));
    %mdis=0.5*max(total);
    uindex=StemIndices(find(total>mdis));
    UnSegmentIndices=[UnSegmentIndices;uindex];
    StemIndices=setdiff(StemIndices,uindex);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(DebugShow)
    figure('Name','Radius constraint','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
     scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0.0 0.0 0], 'filled');
     hold on
%      scatter3(points(uindex,1),points(uindex,2),points(uindex,3),20,[0 0 0], 'filled');
%        hold on
     scatter3(points(StemIndices,1),points(StemIndices,2),points(StemIndices,3),10,[1 0 0], 'filled');
    hold on 
     scatter3(bottomStemPts(:,1),bottomStemPts(:,2),bottomStemPts(:,3),10,[0 1 1], 'filled');
    hold on 
    Dir=res(4:6);
    showLine(mean(bottomStemPts,1),Dir,'red');
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d rot;      
    %%%%%%%%DEBUG  可视化%%%%%%%%%%%%%%%%%%%%%%%% 
end    
    
    %%%%%%%%%Distance constraint%%%%%%%%%%%
    stemPts=points(StemIndices,:);
    ptCloudIn=pointCloud(stemPts);
    num=size(stemPts,1);
    if(num>32)
    [newpts,inlierIndices,outlierIndices] = pcdenoise(ptCloudIn,'NumNeighbors',32,'Threshold', 0.8);
    uindex=StemIndices(outlierIndices);
    UnSegmentIndices=[UnSegmentIndices;uindex];
    StemIndices=setdiff(StemIndices,uindex);
    else
    UnSegmentIndices=[UnSegmentIndices;StemIndices];
    StemIndices=[];    
    end
   FinalRegion=StemIndices;
   WrongRegion=UnSegmentIndices;
   
   
   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(DebugShow)   
    figure('Name','Distance constraint','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0.0 0.0 0], 'filled');
    hold on 
    scatter3(points(StemIndices,1),points(StemIndices,2),points(StemIndices,3),10,[1 0 0], 'filled');
    hold on
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d rot;      
end
    %%%%%%%%DEBUG  可视化%%%%%%%%%%%%%%%%%%%%%%%%  

end


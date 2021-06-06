function [PlantHeight,PlantDiameter,Skeletons]=PhenotypicTrait(points, g_regions,txtName,DebugShow)
%PHENOTYPICTRAIT 此处显示有关此函数的摘要
%   此处显示详细说明
PhenoTraits=zeros(length(g_regions)+1,4);
 %StemSkeleton;
 LeafLenPaths=cell(0,1);
 LeafWidthPaths=cell(0,1);
%  if(DebugShow)
%   figure('Name','Traits','NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
%  end
 
 for i=1:length(g_regions)
    if(i==1)
      indices=g_regions{i};
      StemPoints=points(indices,:);
      [StemLen,StemRadius,StemSkeleton,~]=StemTrait(StemPoints,5,DebugShow);
      PhenoTraits(i,:)=[StemLen StemRadius*2 0 0];
      Skeletons{1}=StemSkeleton;
      continue; 
    end
    indices=g_regions{i};
    LeafPoints=points(indices,:);
    [LeafLen,LeafWidth,LeafAngle,LeafLenPaths{end+1},LeafWidthPaths{end+1}]=LeafTrait(LeafPoints,DebugShow);
    Skeletons{end+1}=LeafPoints(LeafLenPaths{end},:);
    LeafArea=0.75*LeafLen*LeafWidth;
    PhenoTraits(i,:)=[LeafLen LeafWidth LeafArea LeafAngle];
  end
  pointX=points(:,3);pointY=points(:,1);
  minX=min(pointX); maxX=max(pointX);
  minY=min(pointY); maxY=max(pointY);
  PlantHeight=abs(maxX-minX);
  PlantDiameter=abs(maxY-minY);
  PhenoTraits(end,:)=[PlantHeight PlantDiameter 0 0];
  
  
  %%%%%%%%%%%%%%%%%存文件%%%%%%%%%%%%%%%%%%
  fid=fopen(txtName,'w');
  stemHeight=PhenoTraits(1,1);
  stemDiameter=PhenoTraits(1,2);
  fprintf(fid,'Stem StemHeight %f\r\n',stemHeight);
  fprintf(fid,'Stem StemDiameter %f\r\n',stemDiameter); 
  for i=2:length(PhenoTraits)-1
  LeafLen=PhenoTraits(i,1);
  LeafWidth=PhenoTraits(i,2);
  LeafArea=PhenoTraits(i,3);
  LeafAngle=PhenoTraits(i,4);
  fprintf(fid,'Leaf%d leaflength %f\r\n',i,LeafLen);
  fprintf(fid,'Leaf%d leafwidth %f\r\n',i,LeafWidth);
  %fprintf(fid,'Leaf%d leafArea %f\r\n',i,LeafArea);  
 % fprintf(fid,'Leaf%d leafAngle %f\r\n',i,LeafAngle);
  end
  PlantHeight=PhenoTraits(end,1);
  PlantDiameter=PhenoTraits(end,2);
  fprintf(fid,'Plant PlantHeight %f\r\n',PlantHeight);
  fprintf(fid,'Plant PlantDiameter %f\r\n',PlantDiameter);
  fclose(fid);
%   if(DebugShow)
%      axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;   
%   end
end


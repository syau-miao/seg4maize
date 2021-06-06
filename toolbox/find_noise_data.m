function [ points ] = find_noise_data( pts, spls, corresp, show_result )
%FIND_NOISE_DATA 
%   找到每个segment中的噪声点，将噪声点的坐标修改到合适位置
   ptCloudIn=pointCloud(pts);
   points=pts;
   [newpts ,inlierIndices,outlierIndices] = pcdenoise(ptCloudIn,'NumNeighbors',32,'Threshold', 0.1);
   for i=1:size(outlierIndices,2)
      index=corresp(outlierIndices(i));
      adjIndices=find(corresp==index);
      for j=1:size(adjIndices,1)
         vot=adjIndices(j);
         ins=find(outlierIndices==vot);
         if(isempty(ins))
           points(outlierIndices(i),:)=pts(vot,:);  
           break;
         end
      end
   end
   ptCloudIn=pointCloud(points);
  %pcshow(newpts);
   figure
   pcshow(ptCloudIn);
   
   
end


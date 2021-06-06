function [ OBB_ ] = find_OBB_partition_mt(obb,dir1Num,dir2Num,dir3Num )
%FIND_OBB 将obb在dir1,dir2,dir3方向上进行空间分割，
%   此处显示详细说明
  StepX=(obb.Max(1)-obb.Min(1))/dir1Num;
  StepY=(obb.Max(2)-obb.Min(2))/dir2Num;
  StepZ=(obb.Max(3)-obb.Min(3))/dir2Num;
  temp.Min=[0; 0; 0];
  temp.Max=[inf;inf;inf];
  obb_array=repmat(temp,[dir1Num,dir2Num,dir3Num]);
  OBB.center=obb.center;
  OBB.ExtentLen=obb.ExtentLen;
  OBB.dir1=obb.dir1;
  OBB.dir2=obb.dir2;
  OBB.dir3=obb.dir3;
  OBB.Min=obb.Min;
  OBB.Max=obb.Max;
  for i=0:dir1Num-1
     for j=0:dir2Num-1
         for k=0:dir2Num-1
            temp_obb.Min(1)=obb.Min(1)+i*StepX;
            temp_obb.Max(1)=obb.Min(1)+(i+1)*StepX;
            temp_obb.Min(2)=obb.Min(2)+i*StepY;
            temp_obb.Max(2)=obb.Min(2)+(i+1)*StepY;
            temp_obb.Min(3)=obb.Min(3)+i*StepZ;
            temp_obb.Max(3)=obb.Min(3)+(i+1)*StepZ;
            obb_array(i+1,j+1,k+1)=temp_obb;
         end
     end
  end
  OBB.partition=obb_array;
  
end


function [ output_args ] = find_AxisOBBs_mt(pts,XNUM,YNUM,ZNUM,show_result)
%FIND_AXISOBBS_MT 此处显示有关此函数的摘要
%   此处显示详细说明
 minExtens=[inf;inf;inf];
 maxExtens=[-inf;-inf;-inf];
 VX=pts(:,1);
 VY=pts(:,2);
 VZ=pts(:,3);
 minX=min(V1);maxX=max(V1);
 minY=min(V2);maxY=max(V2);
 minZ=min(V3);maxZ=max(V3);
 OBB.ExtentLen=[maxX-minX;maxY-minY;maxZ-minZ];
 OBB.Min=[minX;minY;minZ];
 OBB.Max=[maxX;maxY;maxZ];
 OBB.XNUM=XNUM;
 OBB.YNUM=YNUM;
 OBB.ZNUM=ZNUM;
 temp.Min=[0; 0; 0];
 temp.Max=[inf;inf;inf];
 temp.Num=0;
 temp.Indices=[];
 obb_array=repmat(temp,[XNUM,YNUM,ZNUM]);
 StepX=(OBB.Max(1)-OBB.Min(1))/XNUM;
 StepY=(OBB.Max(2)-OBB.Min(2))/YNUM;
 StepZ=(OBB.Max(3)-OBB.Min(3))/ZNUM;
 for i=0:XNUM-1
     for j=0:XNUM-1
         for k=0:ZNUM-1
           obb_array(i+1,j+1,k+1).Min(1)=OBB.Min(1)+i*StepX;
           obb_array(i+1,j+1,k+1).Max(1)=OBB.Min(1)+(i+1)*StepX;
           obb_array(i+1,j+1,k+1).Min(2)=OBB.Min(2)+j*StepY;
           obb_array(i+1,j+1,k+1).Max(2)=OBB.Min(2)+(j+1)*StepY;
           obb_array(i+1,j+1,k+1).Min(3)=OBB.Min(3)+k*StepZ;
           obb_array(i+1,j+1,k+1).Max(3)=OBB.Min(3)+(k+1)*StepZ;
           %obb_array(i+1,j+1,k+1)=temp_obb;
         end
     end
  end
  OBB.partition=obb_array; 
 
 
 
end


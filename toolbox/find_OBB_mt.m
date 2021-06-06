function [ OBB ] = find_OBB_mt( points, dir1Num,dir2Num,dir3Num,show_result )
%FIND_OBB_MT 计算点云的OBB盒
% 函数返回值：
%OBB盒中的元素含义为;
%ExtentLen: 在三个方向的最大间距  3*1向量
%Min Max:   在三个方向上的最大值、最小值3*1向量
%dir1,2,3： 三个方向向量 1*3向量
%center：   OBB的中心点，也是OBB的坐标原点 1*3向量
%dir1ParNum dir2ParNum dir3ParNum：  在三个方向上的空间体素个数 
% partition：为体素单元集合，dir1*dir2*dir3 Struct数组，共有dir1ParNum*dir2ParNum*dir3ParNum
%            个元素，每个元素均为Struct，该Struct包含的变量为：
%             Min Max:体素单元在三个方向上的最大值、最小值  3*1向量
%             Num：在体素单元内存在的点云个数
%             Indices：1*N 数组，N为体素内点云个数，该数组为体素单元内点云索引，该索引为输入变量points的索引
% 函数输入值：
% points:  点云数组  N*3 数组，N为点云个数
% dir1Num,dir2Num,dir3Num：包围盒内对Points进行体素分割，在三个方向的体素个数
% show_result:显示函数结果
 [coeff, ~,score]= pca(points);
 center=mean(points,1);
 PNum=size(points,1);
 Dir1=repmat(coeff(:,1)',[PNum 1]);
 Dir2=repmat(coeff(:,2)',[PNum 1]);
 Dir3=repmat(coeff(:,3)',[PNum 1]);
 minExtens=[inf;inf;inf];
 maxExtens=[-inf;-inf;-inf];
 Displace=points-center;
 V1=dot(Displace',Dir1');
 V2=dot(Displace',Dir2');
 V3=dot(Displace',Dir3');
 minX=min(V1);maxX=max(V1);
 minY=min(V2);maxY=max(V2);
 minZ=min(V3);maxZ=max(V3);
 OBB.ExtentLen=[maxX-minX;maxY-minY;maxZ-minZ];
 OBB.Min=[minX;minY;minZ];
 OBB.Max=[maxX;maxY;maxZ];
 OBB.Principal=score;
 %包围盒的三个方向向量
 OBB.dir1=Dir1(1,:);
 OBB.dir2=Dir2(1,:);
 OBB.dir3=Dir3(1,:);
 OBB.center=center;
 %计算包围盒的8个顶点
 OBB.p0=minX*OBB.dir1+minY*OBB.dir2+minZ*OBB.dir3+center;
 OBB.p1=maxX*OBB.dir1+minY*OBB.dir2+minZ*OBB.dir3+center;
 OBB.p2=maxX*OBB.dir1+maxY*OBB.dir2+minZ*OBB.dir3+center;
 OBB.p3=minX*OBB.dir1+maxY*OBB.dir2+minZ*OBB.dir3+center;
 OBB.p4=minX*OBB.dir1+minY*OBB.dir2+maxZ*OBB.dir3+center;
 OBB.p5=maxX*OBB.dir1+minY*OBB.dir2+maxZ*OBB.dir3+center;
 OBB.p6=maxX*OBB.dir1+maxY*OBB.dir2+maxZ*OBB.dir3+center;
 OBB.p7=minX*OBB.dir1+maxY*OBB.dir2+maxZ*OBB.dir3+center;
 %进行OBB盒的分割
 OBB.dir1_ParNum=dir1Num;
 OBB.dir2_ParNum=dir2Num;
 OBB.dir3_ParNum=dir3Num;
 temp.Min=[0; 0; 0];
 temp.Max=[inf;inf;inf];
 temp.Num=0;
 temp.Indices=[];
 HasPointPartNum=0;
 obb_array=repmat(temp,[dir1Num,dir2Num,dir3Num]);
 StepX=(OBB.Max(1)-OBB.Min(1))/dir1Num;
 StepY=(OBB.Max(2)-OBB.Min(2))/dir2Num;
 StepZ=(OBB.Max(3)-OBB.Min(3))/dir3Num;
 for i=0:dir1Num-1
     for j=0:dir2Num-1
         for k=0:dir3Num-1
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
 V1=dot(Displace',Dir1')';
 V2=dot(Displace',Dir2')';
 V3=dot(Displace',Dir3')';
 VPar1=floor(((V1-OBB.Min(1))/StepX))+1;
 VPar2=floor(((V2-OBB.Min(2))/StepY))+1;
 VPar3=floor(((V3-OBB.Min(3))/StepZ))+1;
 VPar1(VPar1==dir1Num+1)=dir1Num;
 VPar2(VPar2==dir2Num+1)=dir2Num;
 VPar3(VPar3==dir3Num+1)=dir3Num;
  for i=1:PNum
    I1=VPar1(i);
    I2=VPar2(i);
    I3=VPar3(i);
     OBB.partition(I1,I2,I3).Num=OBB.partition(I1,I2,I3).Num+1;  
     OBB.partition(I1,I2,I3).Indices(end+1)=i;
  end
  
  for i=1:dir1Num
     for j=1:dir2Num
         for k=1:dir3Num
       if( OBB.partition(i,j,k).Num>0)
          HasPointPartNum=HasPointPartNum+1;   
        end
         end
     end
  end
  OBB.HasPointPartNum=HasPointPartNum;
% TEST CODE
%  k=round(1.2);
%  k2=round(1.8);
%  k3=floor(1.2);
%  k4=floor(1.9);
%  
%   MIN1=min(VPar1);
%  MIN2=min(VPar2);
%  MIN3=min(VPar3);
%   MAX1=max(VPar1);
%   MAX2=max(VPar2);
%   MAX3=max(VPar3);
%  



  %%%
 if show_result
  figure
 dir1=Dir1(1,:);
 dir2=Dir2(1,:);
 dir3=Dir3(1,:);
 ptCloudIn = pointCloud(points);
 pcshow( ptCloudIn,'MarkerSize',20);
 for i=1:dir1Num
     for j=1:dir2Num
         for k=1:dir3Num
  minX=OBB.partition(i,j,k).Min(1);
  minY=OBB.partition(i,j,k).Min(2);
  minZ=OBB.partition(i,j,k).Min(3);
  maxX=OBB.partition(i,j,k).Max(1);
  maxY=OBB.partition(i,j,k).Max(2);
  maxZ=OBB.partition(i,j,k).Max(3);
 p0=minX*dir1+minY*dir2+minZ*dir3+center;
 p1=maxX*dir1+minY*dir2+minZ*dir3+center;
 p2=maxX*dir1+maxY*dir2+minZ*dir3+center;
 p3=minX*dir1+maxY*dir2+minZ*dir3+center;
 p4=minX*dir1+minY*dir2+maxZ*dir3+center;
 p5=maxX*dir1+minY*dir2+maxZ*dir3+center;
 p6=maxX*dir1+maxY*dir2+maxZ*dir3+center;
 p7=minX*dir1+maxY*dir2+maxZ*dir3+center;
 c='g';
 if( OBB.partition(i,j,k).Num>0)
     c='r';
    
 end
 hold on
 plot3([p0(1) p1(1)],[p0(2) p1(2)],[p0(3) p1(3)],c);
 plot3([p0(1) p3(1)],[p0(2) p3(2)],[p0(3) p3(3)],c);
 plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],c);
 plot3([p2(1) p3(1)],[p2(2) p3(2)],[p2(3) p3(3)],c);
 
 plot3([p4(1) p5(1)],[p4(2) p5(2)],[p4(3) p5(3)],c);
 plot3([p5(1) p6(1)],[p5(2) p6(2)],[p5(3) p6(3)],c);
 plot3([p6(1) p7(1)],[p6(2) p7(2)],[p6(3) p7(3)],c);
 plot3([p7(1) p4(1)],[p7(2) p4(2)],[p7(3) p4(3)],c);
 
 plot3([p4(1) p0(1)],[p4(2) p0(2)],[p4(3) p0(3)],c);
 plot3([p5(1) p1(1)],[p5(2) p1(2)],[p5(3) p1(3)],c);
 plot3([p6(1) p2(1)],[p6(2) p2(2)],[p6(3) p2(3)],c);
 plot3([p7(1) p3(1)],[p7(2) p3(2)],[p7(3) p3(3)],c);
%  plot3([p0(1) p1(1)],[p0(2) p1(2)],[p0(3) p1(3)],'r');
%  plot3([p0(1) p3(1)],[p0(2) p3(2)],[p0(3) p3(3)],'g');
%  plot3([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'g');
%  plot3([p2(1) p3(1)],[p2(2) p3(2)],[p2(3) p3(3)],'r');
%  
%  plot3([p4(1) p5(1)],[p4(2) p5(2)],[p4(3) p5(3)],'r');
%  plot3([p5(1) p6(1)],[p5(2) p6(2)],[p5(3) p6(3)],'g');
%  plot3([p6(1) p7(1)],[p6(2) p7(2)],[p6(3) p7(3)],'r');
%  plot3([p7(1) p4(1)],[p7(2) p4(2)],[p7(3) p4(3)],'g');
%  
%  plot3([p4(1) p0(1)],[p4(2) p0(2)],[p4(3) p0(3)],'b');
%  plot3([p5(1) p1(1)],[p5(2) p1(2)],[p5(3) p1(3)],'b');
%  plot3([p6(1) p2(1)],[p6(2) p2(2)],[p6(3) p2(3)],'b');
%  plot3([p7(1) p3(1)],[p7(2) p3(2)],[p7(3) p3(3)],'b');
         end
     end
 end
 end
end


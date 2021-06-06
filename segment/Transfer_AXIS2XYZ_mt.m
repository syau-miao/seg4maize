function [ xyz ] = Transfer_AXIS2XYZ_mt(  Coords,XYZ_Axis )
%TRANSFER_AXIS2XYZ_MT 此处显示有关此函数的摘要
%   此处显示详细说明
 PNum=size(Coords,1);
 Dir1=repmat(XYZ_Axis(2,:),[PNum 1]);
 Dir2=repmat(XYZ_Axis(3,:),[PNum 1]);
 Dir3=repmat(XYZ_Axis(4,:),[PNum 1]);
 rmatrix=[XYZ_Axis(2,:);XYZ_Axis(3,:);XYZ_Axis(4,:)];
 xyz=rmatrix'*Coords';
 xyz=xyz'+XYZ_Axis(1,:);
%  Displace=XYZs_Coords-XYZ_Axis(1,:);
%  V1=dot(Displace',Dir1');
%  V2=dot(Displace',Dir2');
%  V3=dot(Displace',Dir3');
%  Axis_Coords=[ V2' V3' V1'];
%  Axis_normals=find_normal_data(Axis_Coords);

end


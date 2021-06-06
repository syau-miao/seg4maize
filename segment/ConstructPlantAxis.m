function [ PA_Pts,PA_Spls] = ConstructPlantAxis(points,spls,Phi_U,sub_skeletons)
%CONSTRUCTPLANTAXIS 此处显示有关此函数的摘要
%   此处显示详细说明
%%%%%%%%%%%%转坐标系%%%%%%%%%%%%%%%%%%
 [center ,direction]=fitline(points(Phi_U,:));   
 skeleton=sub_skeletons{end};
 p1=spls(skeleton(1),:);p2=spls(skeleton(end),:);
 dir1=(p2-p1)./norm(p2-p1);
 a=sum(dir1.*direction);
 if(a<0)
    direction=-1*direction;
 end
 Axis=find_AxisByPrincipalDir_mt(points(Phi_U,:),dir1,center,false);
 PA_Pts=Transfer_XYZ2AXIS_mt(points,Axis);
 PA_Spls=Transfer_XYZ2AXIS_mt(spls,Axis);
end


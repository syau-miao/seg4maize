function [  normals ] = find_normal_data( pts,number )
%FIND_NORMAL_DATA 此处显示有关此函数的摘要
%   此处显示详细说明
  ptCloud = pointCloud(pts);
  normals = pcnormals(ptCloud,number);
return;
%   figure
%   pcshow(ptCloud)
%   title('Estimated Normals of Point Cloud')
%   hold on
x = ptCloud.Location(1:end,1);
y = ptCloud.Location(1:end,2);
z = ptCloud.Location(1:end,3);
u = normals(1:end,1);
v = normals(1:end,2);
w = normals(1:end,3);
return;
%Plot the normal vectors.
    figure('Name','normal','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    scatter3(x,y,z,5,[u v w], 'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d ZOOM;


end


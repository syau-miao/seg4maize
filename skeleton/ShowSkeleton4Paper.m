function [ output_args ] = DebugShowForPaper( spls, A, joints ,roots, branches,points,Phi_O,Phi_U )
%DEBUGSHOWFORPAPER 此处显示有关此函数的摘要
%   此处显示详细说明
    figure('Name','Find joints','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    plot_skeleton(spls, A);hold on;
    scatter3(spls(joints,1),spls(joints,2),spls(joints,3),40,[0,0,1], 'filled');
    scatter3(spls(roots,1),spls(roots,2),spls(roots,3),40,[1,0,1], 'filled');
    scatter3(spls(branches,1),spls(branches,2),spls(branches,3),20,[0,1,0],'filled');
    scatter3(points(:,1),points(:,2),points(:,3),2,[0,0,0],'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;

   figure('Name','CoaseSegBySkeleton','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
  for i=1:length(Phi_O)
       if(i==1)
           continue;
       end
       indices=Phi_O{i};
       scatter3(points(indices,1),points(indices,2),points(indices,3),5,color(i+1,:), 'filled');
       hold on;
   end
   indices=Phi_U;
   scatter3(points(indices,1),points(indices,2),points(indices,3),5,[0 0 0], 'filled');
   hold on;
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;

   figure('Name','points','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    scatter3(points(:,1),points(:,2),points(:,3),2,[0,0,0],'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;


end


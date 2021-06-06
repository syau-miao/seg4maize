% clear;clc;close all;
% path(path,'toolbox') ;

%sk_filename ='Data.mat';

%%
SHOW_JOINTS = false;
SHOW_ROOT_JOINT = false;
SHOW_CYCLES = false;
SHOW_IRRELEVANT_EXTRAMA = false;

% t1 = 0.1; % for inner branch nodes
% a1 = pi*5.0/7.0; % for inner branch nodes,  
% t2 = 0.0; % for irrelevant extrama;
% t3 = 30; % for small cycles;
%sprintf('thresholds for remove 1)inner nodes: %f angle, %f length \n 2)irrelevant extrama: %f\n3)small cycles: %d \n',t1, a1, t2, t3)

%load(sk_filename,'P');
%axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);
%% 0: find joints and NaN, first
[joints, roots,segments] = find_joints(P.pts, P.spls, P.corresp, P.spls_adj, SHOW_JOINTS);
%% 1: removing small cycles measured by topological length
[P.spls, P.corresp, P.spls_adj, joints, segments] = remove_small_cycles_mt(P.spls, P.corresp, P.spls_adj, joints,roots, segments,t3, SHOW_CYCLES);
%% 2: find root joint, global distance relative to root_id, "size of skeleton"
[root_id, global_dist] = find_root_node(P.spls, P.spls_adj, joints, SHOW_ROOT_JOINT);
%% 3: unify joints if there are no branch node inbetween of them. The effect is bad for some cases.
if ~isempty(joints)
    [P.spls, P.corresp, P.spls_adj, joints, root_id] = merge_nearby_joints(P.spls, P.corresp, P.spls_adj, joints, root_id);
end
%linshi
%
%% 4: removing irrelevant extrama
[P.spls, P.corresp, P.spls_adj, joints, segments] = remove_irrelevant_extrama(P.spls, P.corresp, P.spls_adj, joints, segments,global_dist, t2, SHOW_IRRELEVANT_EXTRAMA);
%% 5: removing inner branch nodes
%[P.spls, P.corresp, P.spls_adj, joints, segments] = remove_inner_nodes(P.spls, P.corresp, P.spls_adj, joints, segments,global_dist,t1,a1);
%% 6: form hierarchy, and rebuild skel_adj remove null node.
P.root_id = root_id;% The first node is root node if there is no joints.
 %[P, graph] = build_hierarchy(P,global_dist); % do not contain cycles
[P.spls,P.corresp,P.spls_adj, graph] = build_graph(P.spls,P.corresp,P.spls_adj);% may contain cycles
%% 7: move skeleton nodes to center of its correspondence point cloud
% figure('Name','Build hierarchy','NumberTitle','off');set(gcf,'color','white');hold on; movegui('south');
% plot_skeleton(P.spls,P.spls_adj);

for i = 1:size(P.spls,1)
    verts = P.pts(P.corresp==i,:);
    if size(verts,1) == 1
        P.spls(i,:) = verts;
    else
        P.spls(i,:) = mean(verts);
    end
end
for i = 1:size(P.spls_adj,1)
    links = find( P.spls_adj(i,:)==1 );
    if length(links) == 2
        verts = P.spls(links,:);
        P.spls(i,:) = mean(verts);
    end
end
%plot_embedded_graph(P.spls, graph, 'b', 'linewidth', 2);
%axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;
%% finally
if(DebugShow)
 figure;set(gcf,'color','white');movegui('northwest');set(gcf,'Renderer','OpenGL');view3d rot;
 scatter3(P.pts(:,1),P.pts(:,2),P.pts(:,3),20,'.','MarkerEdgeColor', GS.PC_COLOR);hold on;
 plot_skeleton(P.spls, P.spls_adj);
 axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,90);
end
%save(['SkeletonFile\' folderName '_' resolutionName '_r.mat'], 'P');
function [joints, roots , branches] = find_Joints_mt( spls, A, pts, show_results)
%FIND_JOINTS_MT %    �������ӵ�������жϹǼܵ������
%��������ֵ
%joints: joint���� N*1����  ÿ��Ԫ��Ϊjoint��spls�е�����,NΪjoint����
%roots: root����   M*1����  ÿ��Ԫ��Ϊroot��spls�е�������MΪroot����
%branches: branche���� K*1����  ÿ��Ԫ��Ϊbranch��spls�е�������MΪroot����
%�������룺
%spls:�Ǽܵ�����
%A���Ǽܵ����Ӿ���
%show_results: �Ƿ���ʾ���

[num, ~]=size(spls);
joints=zeros(0,1);
roots=zeros(0,1);
branches=zeros(0,1);
for i=1:num   
    links = find( A(i,:)==1 );
    if length(links) == 1 % root
       roots(end+1)=i;
    end
    if length(links) == 2 % branch
        branches(end+1)=i;
    end
     if length(links) >2 % joints
        joints(end+1)=i;
    end
end

joints=joints';
roots=roots';
branches=branches';

if show_results
    figure('Name','Find joints','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    plot_skeleton(spls, A);hold on;
    scatter3(spls(joints,1),spls(joints,2),spls(joints,3),40,[0,0,1], 'filled');
    scatter3(spls(roots,1),spls(roots,2),spls(roots,3),40,[1,0,1], 'filled');
    scatter3(spls(branches,1),spls(branches,2),spls(branches,3),20,[0,1,0],'filled');
    scatter3(pts(:,1),pts(:,2),pts(:,3),2,[0,0,0],'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;
end

end


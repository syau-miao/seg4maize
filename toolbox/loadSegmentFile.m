function [ PtCloud ] = loadSegmentFile( filedir)
%LOADSEGMENTFILE 此处显示有关此函数的摘要
%   此处显示详细说明
fileFolder=fullfile(filedir);
dirOutput=dir(fullfile(fileFolder,'*.ply'));
FileNames={dirOutput.name};
Length_Names = size(FileNames,2);    % 获取所提取数据文件的个数
PtCloud=[];
Indices=zeros(Length_Names,1);
for k = 1 : Length_Names
    % 连接路径和文件名得到完整的文件路径
    K_Trace = strcat(fileFolder, FileNames(k));
    pccloud=pcread(K_Trace{1});
    cloud=double(pccloud.Location);
    Indices(k)=size(PtCloud,1)+1;
    PtCloud=[PtCloud; cloud];
end

end

% pts=GS.normalize(PtCloud);
% [Apts Axis_normals]=Transfer_XYZ2AXIS_mt(pts,Axis);
% knum=0;
% for i=1:size(pts,1)
%    coord=pts(i,:);   
%    index=find(Apts==coord);
%    if(size(index,1)>0)
%        knum=knum+1;
%    end
% end
% 
% if(true)
%     figure('Name','segment cloud','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
%    % hold on;
%    
%     scatter3(Apts(:,1),Apts(:,2),Apts(:,3),3,[0 1 0], 'filled');
%     hold on
%     %scatter3(Axis_pts(:,1),Axis_pts(:,2),Axis_pts(:,3),3,[1 0 0], 'filled');
%     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d ZOOM;
%   
% end
% if(true)
%     figure('Name','segment cloud 2','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
%    % hold on;
%    
%    % scatter3(Apts(:,1),Apts(:,2),Apts(:,3),3,[0 1 0], 'filled');
%    % hold on
%     scatter3(Axis_pts(:,1),Axis_pts(:,2),Axis_pts(:,3),3,[1 0 0], 'filled');
%     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d ZOOM;
%   
% 
% end


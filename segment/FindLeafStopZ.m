function [StopX,StopV] = FindLeafStopZ( sub_skeleton,joints,spls)
%FINDLEAFSTOPZ 此处显示有关此函数的摘要
%   此处显示详细说明
  stem_skeleton=sub_skeleton{end};
  StopX=[];
  StopV=[];
  joint_array=[];
  for i=1:length(stem_skeleton)
     v=stem_skeleton(i);
     if(ismember(v,joints))
        joint_array=[joint_array;v];
     end
  end
  for i=1:length(sub_skeleton)-1
     skeleton_=sub_skeleton{i};
     joint_=skeleton_(end);
     id=find(joint_array==joint_);
    % idstep=2;
%      if(id>length(joint_array)-2)
        idstep=2;
%      end2;
     id2=id-idstep;
     if(id2>0)
         StopX=[StopX;spls(joint_array(id2),3)];
%          V=spls(joint_array(id2),:)-spls(joint_array(id),:);
%          StopV=[StopV;V./norm(V)];
     else
         StopX=[StopX;-Inf];
%          id2=stem_skeleton(1);
%          V=spls(id2,:)-spls(joint_array(id),:);
%          StopV=[StopV;V./norm(V)];
     end
     
       id2=id;
       
   %  if(id2>0)
         v1=spls(joint_array(id2),3);
        % v2=spls(joint_array(id2+1),1);
         StopV=[StopV;v1];
%          V=spls(joint_array(id2),:)-spls(joint_array(id),:);
%          StopV=[StopV;V./norm(V)];
   %  else
     %    StopV=[StopV;-Inf];
%          id2=stem_skeleton(1);
%          V=spls(id2,:)-spls(joint_array(id),:);
%          StopV=[StopV;V./norm(V)];
    % end
  end
  
  
  
end


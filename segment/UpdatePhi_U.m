function [ Phi_U ] = UpdatePhi_U( PA_Pts,Phi_S )
%UPDATEPHI_U 此处显示有关此函数的摘要
%   此处显示详细说明
   indices=zeros(length(PA_Pts),1);
   for i=1:length(Phi_S)
      ids=Phi_S{i};
      for j=1:length(ids)
         indices(ids(j))=1; 
      end 
   end
   Phi_U=find(indices==0);
end


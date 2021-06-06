function [ side ] = P2PlaneSide(xyz0,direction,v)
%P2PLANESIDE 此处显示有关此函数的摘要
%   此处显示详细说明
    temp=dot(v-xyz0,direction);
    if(temp>0)
        side=1;
    end;
    if(temp<=0)
        side=0;
    end;
end


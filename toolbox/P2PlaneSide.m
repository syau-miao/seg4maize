function [ side ] = P2PlaneSide(xyz0,direction,v)
%P2PLANESIDE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    temp=dot(v-xyz0,direction);
    if(temp>0)
        side=1;
    end;
    if(temp<=0)
        side=0;
    end;
end


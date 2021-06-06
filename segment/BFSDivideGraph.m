function resultSet=BFSDivideGraph(Graph)
% 连通分量(广度优先搜索)
% Graph 图连通矩阵,无向图，对称矩阵
resultSet=[];
[m n]=size(Graph);
nodelist=zeros(m,1);
p=1;
for k=1:m
    if(nodelist(k)==0)
        startNode=k;
        queue=startNode;
        nodelist(startNode)=1;
        result=startNode;
        while isempty(queue)==false
            i=queue(1);
            queue(1)=[];
            for j=1:n
                if(Graph(i,j)>0&&nodelist(j)==0&&i~=j)
                    queue=[queue;j];
                    nodelist(j)=1;
                    result=[result;j];
                end
            end
        end
        resultSet(p).graph=result;
        p=p+1;
    end
end


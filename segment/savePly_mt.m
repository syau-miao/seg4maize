function [  ] = savePly_mt(OrganRegions,Axis_pts)
%SAVEPLY_MT 此处显示有关此函数的摘要
%   此处显示详细说明
   for i=1:size(OrganRegions,2)
     regions=OrganRegions{i};
     pts=Axis_pts(regions,:);
     pc=pointCloud(pts);
     filename=[num2str(i),'.ply'];
     pcwrite(pc,filename);
   end
   
   %%%%%%%%%生成茎圆柱点云
   regions=OrganRegions{1};
   stemPts=Axis_pts(regions,:);
   [BasePt,StemDir]=fitline(stemPts);
   radius=[];
    NewAxis=find_AxisByPrincipalDir_mt(stemPts,StemDir,BasePt,false);
   [New_pts,~]=Transfer_XYZ2AXIS_mt(stemPts,NewAxis);
   newX=New_pts(:,1);newY=New_pts(:,2);newZ=New_pts(:,3);
   for i=1:length(stemPts)
     r=sqrt(newX(i)*newX(i)+newY(i)*newY(i));
     radius=[radius;r];
   end
   mr=median(radius);
   minz=min(newZ); maxz=max(newZ);
   AngleNum=16;
   HNum=16;
   vertices=zeros(AngleNum*(HNum+1),3);
   for h=1:HNum+1
     z=minz+(h-1)*(maxz-minz)/HNum;    
     for a=1:AngleNum
        ang=2*pi*(a-1)/AngleNum;
        x=mr*cos(ang);y=mr*sin(ang);
        vertices((h-1)*AngleNum+a,:)=[z x y]; 
     end
   end
   vertices(end+1,:)=[minz 0 0];
   vertices(end+1,:)=[maxz 0 0];
   newStemPts=Transfer_AXIS2XYZ_mt(vertices,NewAxis);
   faces=[];
   for h=1:HNum
     h2=h+1;
     for a=1:AngleNum
       v1h1=(h-1)*AngleNum+a;v2h1=(h-1)*AngleNum+a+1; 
       v1h2=(h2-1)*AngleNum+a;v2h2=(h2-1)*AngleNum+a+1;
       if(a==AngleNum)
        v1h1=(h-1)*AngleNum+a;v2h1=(h-1)*AngleNum+1;   
        v1h2=(h2-1)*AngleNum+a;v2h2=(h2-1)*AngleNum+1;   
       end
       f1=[v1h2 v2h1 v1h1];
       f2=[v2h2 v1h2 v2h1];
       faces=[faces;f1];faces=[faces;f2];
       if(h==1)
         f3=[size(vertices,1)-1 v2h1 v1h1]; 
         faces=[faces;f3]  
       end
       if(h==HNum)
         f3=[size(vertices,1) v2h2 v1h2]; 
         faces=[faces;f3]  
       end
     end    
   end
   
   
   %%%%%%%save obj %%%%%%%%%%%%%%%%%%%%%%
 a='v';
 fid=fopen('1.obj','w');
 for i=1:size(vertices,1)
  a='v';
  fprintf(fid,'%s %f %f %f\n',a,newStemPts(i,1),newStemPts(i,2),newStemPts(i,3));     
 end
 for i=1:size(faces,1)
  a='f';
  fprintf(fid,'%s %d %d %d\n',a,faces(i,1),faces(i,2),faces(i,3));     
 end
 fclose(fid);

   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(true)
   figure('Name','newstempts','NumberTitle','off');set(gcf,'color','white');movegui('southwest');  
    scatter3(stemPts(:,1),stemPts(:,2),stemPts(:,3),5,[0 0 0], 'filled');
    hold on;
  scatter3(newStemPts(:,1),newStemPts(:,2),newStemPts(:,3),5,[0 0 1], 'filled');
    hold on;
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;
  end 
   

end


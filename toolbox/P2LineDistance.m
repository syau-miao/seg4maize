function [ distance,t0 ] = P2LineDistance(xyz0,direction,v)
%P2LINEDISTANCE 此处显示有关此函数的摘要
%   此处显示详细说明
     x0=v(1);
     y0=v(2);
     z0=v(3); 
     vx=xyz0(1);
     vy=xyz0(2);
     vz=xyz0(3);
     x=direction(1);
     y=direction(2);
     z=direction(3);
    t0=((x0-vx)*x+(y0-vy)*y+(z0-vz)*z)/(x*x+y*y+z*z);
    distance=sqrt((x0-vx-t0*x).^2+(y0-vy-t0*y).^2+(z0-vz-t0*z).^2);
end


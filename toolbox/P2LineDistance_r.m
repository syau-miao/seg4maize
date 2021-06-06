function [distance] = P2LineDistance_r(m,v)
     a=size(v,1);
     xyz=repmat([m(1) m(2) m(3)],[a,1]);
     Dir =repmat([m(4) m(5) m(6)],[a,1]);
     x0=v(:,1);
     y0=v(:,2);
     z0=v(:,3); 
     vx=xyz(:,1);
     vy=xyz(:,2);
     vz=xyz(:,3);
     x=Dir(:,1);
     y=Dir(:,2);
     z=Dir(:,3);
    t0=((vx-x0).*x+(vy-y0).*y+(vz-z0).*z)./(x.*x+y.*y+z.*z);
    distance=sqrt((x0-vx+t0.*x).^2+(y0-vy+t0.*y).^2+(z0-vz+t0.*z).^2);
end

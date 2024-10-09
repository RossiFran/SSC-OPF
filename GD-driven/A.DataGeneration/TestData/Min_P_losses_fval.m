function obj=losses(x,dat,branch)

V = [x(1:9)'];
theta = [x(10:18)'];

ploss=0;

for ll=1:length(branch)
    ii=branch(ll,1);
    jj=branch(ll,2);
    ploss=ploss+ real(dat.Yl)*(V(ii,1)^2+V(jj,1)^2-2*V(ii,1)*V(jj,1)*cos(theta(ii,1)-theta(jj,1)));
end


obj= ploss;
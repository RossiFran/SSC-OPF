function obj=Min_P_losses(x,dat,branch,constraint)

V = [x(1:9)'];
theta = [x(10:18)'];
P6= x(22);
P5= x(21);

ploss=0;

for ll=1:length(branch)
    ii=branch(ll,1);
    jj=branch(ll,2);
    ploss=ploss+ real(dat.Yl)*(V(ii,1)^2+V(jj,1)^2-2*V(ii,1)*V(jj,1)*cos(theta(ii,1)-theta(jj,1)));
end

ploss=ploss + max(0,eval(constraint)-1);
obj= ploss;
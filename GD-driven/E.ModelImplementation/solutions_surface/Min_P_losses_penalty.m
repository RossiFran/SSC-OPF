function obj=Min_P_losses(x,dat,branch)

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

ploss=ploss + max(0,0.984008+max(0,0.416303-dat.Pd90)*0.0876049+max(0,P6-0.303393)*(-0.157552)+max(0,0.303393-P6)*0.1994+max(0,theta(3,1)+0.0136921)*9.31738+max(0,-0.0136921-theta(3,1))*(-10.2568)+P5*(-0.147466)+max(0,dat.Pd30-0.232119)*0.0679659+max(0,0.232119-dat.Pd30)*0.068344+max(0,0.150587-dat.Pd70)*0.167272+max(0,dat.Pd40-0.367371)*0.0147017+max(0,0.367371-dat.Pd40)*0.0605988+max(0,dat.Pd50-0.194075)*0.0216427+max(0,0.194075-dat.Pd50)*0.0864888-1);

obj= ploss;
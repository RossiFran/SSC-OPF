function obj=Min_P_SG(x,dat,constraint)%,opfstab,opfunstab,jj)

V = [x(1:9)'];
theta = [x(10:18)'];
P6= x(22);
P5= x(21);
psg=(x(21)+x(22)) +10000*max(0,eval(constraint)-1);

obj= psg;

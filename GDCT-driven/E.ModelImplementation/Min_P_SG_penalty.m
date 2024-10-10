function obj=Min_P_SG(x,dat,constraint)

V = [x(1:9)'];
theta = [x(10:18)'];
P6= x(22);
P5= x(21);
Rdroop=x(27);
psg=(x(21)+x(22)) +1000*max(0,eval(constraint)-1);

obj= psg;

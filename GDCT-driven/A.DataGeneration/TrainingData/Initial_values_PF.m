%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save initial values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generator 1
Psg10 = -results_bus(6,3)*100e6;
Qsg10 = -results_bus(6,4)*100e6;
Vsg10 = results_bus(6,1)*Vn;

Isg10 = sqrt(Psg10^2+Qsg10^2)/Vsg10*sqrt(2/3);
phi1 = acos(Psg10/(sqrt(Psg10^2+Qsg10^2)))*sign(Qsg10/Psg10);
delta_sg10 = atan((dat.SG1.Xd*Isg10*cos(phi1)-dat.SG1.Rs*Isg10*sin(phi1))/(Vsg10*sqrt(2/3)+dat.SG1.Rs*Isg10*cos(phi1)+dat.SG1.Xd*Isg10*sin(phi1)));

isq10 = Isg10*cos(delta_sg10-phi1);
isd10 = -Isg10*sin(delta_sg10-phi1);
ikd10 = 0;
ik1q10 = 0;
ik2q10 = 0;

Vsgb10 = (Vsg10+sqrt(dat.SG1.Rs^2+dat.SG1.Xd^2)*Isg10)/Vn;
ifd10 = Vsgb10/(dat.SG1.Lmd*dat.wn/(dat.Vn/sqrt(3)*sqrt(2)));
vfd10= ifd10*dat.SG1.Rfd;
Vref_g1 = vfd10/(dat.SG1.Ka*dat.Vn/sqrt(3)*sqrt(2))+results_bus(6,1);


vsg1q0 = Vsg10*cos(delta_sg10)*sqrt(2/3);
vsg1d0 = -Vsg10*sin(delta_sg10)*sqrt(2/3);

wg10 = 2*pi*f0;

% Generator 2
Psg20 = -results_bus(5,3)*100e6;
Qsg20 = -results_bus(5,4)*100e6;
Vsg20 = results_bus(5,1)*Vn;

Isg20 = sqrt(Psg20^2+Qsg20^2)/Vsg20*sqrt(2/3);

phi2 = acos(Psg20/(sqrt(Psg20^2+Qsg20^2)))*sign(Qsg20/Psg20);

delta_sg20 = atan((dat.SG2.Xd*Isg20*cos(phi2)-dat.SG2.Rs*Isg20*sin(phi2))/(Vsg20*sqrt(2/3)+dat.SG2.Rs*Isg20*cos(phi2)+dat.SG2.Xd*Isg20*sin(phi2)));

e_theta_sg20 = (results_bus(5,2)-delta_sg20-results_bus(6,2)+delta_sg10);

is2q20 = Isg20*cos(delta_sg20-phi2);
is2d20 = -Isg20*sin(delta_sg20-phi2);

[is2q0,is2d0] = rotation(is2q20,is2d20,-e_theta_sg20);

vsg2q20 = Vsg20*cos(delta_sg20)*sqrt(2/3);
vsg2d20 = -Vsg20*sin(delta_sg20)*sqrt(2/3);

[vsg2q0,vsg2d0] = rotation(vsg2q20,vsg2d20,-e_theta_sg20);

isq20 = is2q20;
isd20 = is2d20; 
ikd20 = 0;
ik1q20 = 0;
ik2q20 = 0;

Vsgb20 = (Vsg20+sqrt(dat.SG2.Rs^2+dat.SG2.Xd^2)*Isg20)/Vn;
ifd20 = Vsgb20/(dat.SG2.Lmd*dat.wn/(dat.Vn/sqrt(3)*sqrt(2)));
vfd20= ifd20*dat.SG2.Rfd;
Vref_g2 = vfd20/(dat.SG2.Ka*dat.Vn/sqrt(3)*sqrt(2))+results_bus(5,1);

wg20 = 2*pi*f0;


% Converter

e_theta_c0 = results_bus(1,2)-results_bus(6,2)+delta_sg10;
Pvsc0 = results_branch(1,3)*100e6;
Qvsc0 = results_branch(1,4)*100e6;
Vpcc0 = results_bus(1,1)*Vn;
Ivsc0 = -sqrt(Pvsc0^2+Qvsc0^2)/Vpcc0*sqrt(2/3);

phi_c = acos(Pvsc0/sqrt(Pvsc0^2+Qvsc0^2))*sign(Qvsc0/Pvsc0);

vpccqc0 = Vpcc0*sqrt(2/3);
vpccdc0 = 0;

[vpccq0,vpccd0] = rotation(vpccqc0, vpccdc0,-e_theta_c0);

icqc0 = Ivsc0*cos(-phi_c);
icdc0 = -Ivsc0*sin(-phi_c);

[icq0,icd0] = rotation(icqc0, icdc0,-e_theta_c0);

vconvqc0 = vpccqc0-(Rc*icqc0+Lc*wn*icdc0);
vconvdc0 = vpccdc0-(Rc*icdc0-Lc*wn*icqc0);

% Bus voltages
theta_b10 = results_bus(1,2);
theta_b20 = results_bus(2,2);
theta_b30 = results_bus(3,2);
theta_b40 = results_bus(4,2);
theta_b50 = results_bus(5,2);
theta_b60 = results_bus(6,2);
theta_b70 = results_bus(7,2);
theta_b80 = results_bus(8,2);
theta_b90 = results_bus(9,2);

Vb1 = results_bus(1,1)*Vn;
Vb2 = results_bus(2,1)*Vn;
Vb3 = results_bus(3,1)*Vn;
Vb4 = results_bus(4,1)*Vn;
Vb5 = results_bus(5,1)*Vn;
Vb6 = results_bus(6,1)*Vn;
Vb7 = results_bus(7,1)*Vn;
Vb8 = results_bus(8,1)*Vn;
Vb9 = results_bus(9,1)*Vn;

v1q0 = Vb1*cos(theta_b10)*sqrt(2/3);
v1d0 = -Vb1*sin(theta_b10)*sqrt(2/3);

v2q0 = Vb2*cos(theta_b20)*sqrt(2/3);
v2d0 = -Vb2*sin(theta_b20)*sqrt(2/3);

v3q0 = Vb3*cos(theta_b30)*sqrt(2/3);
v3d0 = -Vb3*sin(theta_b30)*sqrt(2/3);

v4q0 = Vb4*cos(theta_b40)*sqrt(2/3);
v4d0 = -Vb4*sin(theta_b40)*sqrt(2/3);

v5q0 = Vb5*cos(theta_b50)*sqrt(2/3);
v5d0 = -Vb5*sin(theta_b50)*sqrt(2/3);

v6q0 = Vb6*cos(theta_b60)*sqrt(2/3);
v6d0 = -Vb6*sin(theta_b60)*sqrt(2/3);

v7q0 = Vb7*cos(theta_b70)*sqrt(2/3);
v7d0 = -Vb7*sin(theta_b70)*sqrt(2/3);

v8q0 = Vb8*cos(theta_b80)*sqrt(2/3);
v8d0 = -Vb8*sin(theta_b80)*sqrt(2/3);

v9q0 = Vb9*cos(theta_b90)*sqrt(2/3);
v9d0 = -Vb9*sin(theta_b90)*sqrt(2/3);


% Line currents
P1 = results_branch(1,3)*100e6;%V2
Q1 = results_branch(1,4)*100e6;
i1q10 = P1/Vb1*sqrt(2/3);
i1d10 = Q1/Vb1*sqrt(2/3);
[i1q0,i1d0] = rotation(i1q10, i1d10,-theta_b10);
iline1 = sqrt(i1q0^2+i1d0^2); 

P2 = -results_branch(2,3)*100e6;%V2
Q2 = -results_branch(2,4)*100e6;
i2q20 = P2/Vb2*sqrt(2/3);
i2d20 = Q2/Vb2*sqrt(2/3); 
[i2q0,i2d0] = rotation(i2q20, i2d20,-theta_b20);
iline2 = sqrt(i2q0^2+i2d0^2); 

P3 = -results_branch(3,5)*100e6;%V2
Q3 = -results_branch(3,6)*100e6;
i3q30 = P3/Vb3*sqrt(2/3);
i3d30 = Q3/Vb3*sqrt(2/3);
[i3q0,i3d0] = rotation(i3q30, i3d30,-theta_b30);
iline3 = sqrt(i3q0^2+i3d0^2); 

P4 = -results_branch(4,3)*100e6;%V2
Q4 = -results_branch(4,4)*100e6;
i4q40 = P4/Vb2*sqrt(2/3);
i4d40 = Q4/Vb2*sqrt(2/3);
[i4q0,i4d0] = rotation(i4q40, i4d40,-theta_b20);
iline4 = sqrt(i4q0^2+i4d0^2); 

P5 = -results_branch(5,3)*100e6; %V6
Q5 = -results_branch(5,4)*100e6;
i5q50 = P5/(Vb4)*sqrt(2/3);
i5d50 = Q5/(Vb4)*sqrt(2/3);
[i5q0,i5d0] = rotation(i5q50, i5d50,-theta_b40);
iline5 = sqrt(i5q0^2+i5d0^2); 

P6 = results_branch(6,3)*100e6; %V4
Q6 = results_branch(6,4)*100e6;
i6q60 = P6/(Vb4)*sqrt(2/3);
i6d60 = Q6/(Vb4)*sqrt(2/3);
[i6q0,i6d0] = rotation(i6q60, i6d60,-theta_b40);
iline6 = sqrt(i6q0^2+i6d0^2); 

P7 = -results_branch(7,3)*100e6; %V6
Q7 = -results_branch(7,4)*100e6;
i7q70 = P7/(Vsg10)*sqrt(2/3);
i7d70 = Q7/(Vsg10)*sqrt(2/3);
[i7q0,i7d0] = rotation(i7q70, i7d70,-theta_b60);
iline7 = sqrt(i7q0^2+i7d0^2); 

P8 = -results_branch(8,5)*100e6; %V6
Q8 = -results_branch(8,6)*100e6;
i8q80 = P8/(Vb7)*sqrt(2/3);
i8d80 = Q8/(Vb7)*sqrt(2/3);
[i8q0,i8d0] = rotation(i8q80, i8d80,-theta_b70);
iline8 = sqrt(i8q0^2+i8d0^2); 

P9 = -results_branch(9,5)*100e6; %V8
Q9 = -results_branch(9,6)*100e6;
i9q90 = P9/(Vb8)*sqrt(2/3);
i9d90 = Q9/(Vb8)*sqrt(2/3);
[i9q0,i9d0] = rotation(i9q90, i9d90,-theta_b80);
iline9 = sqrt(i9q0^2+i9d0^2); 

P10 = -results_branch(10,5)*100e6; %V8
Q10 = -results_branch(10,6)*100e6;
i10q100 = P10/(Vb9)*sqrt(2/3);
i10d100 = Q10/(Vb9)*sqrt(2/3);
[i10q0,i10d0] = rotation(i10q100, i10d100,-theta_b90);
iline10 = sqrt(i10q0^2+i10d0^2); 


Isg0 = [Isg10,Isg20];
Iline0 = [iline1, iline2, iline3, iline4, iline5, iline6, iline7, iline8, iline9, iline10];

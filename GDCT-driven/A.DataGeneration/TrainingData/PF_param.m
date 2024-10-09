%% System parameters

% Nominal AC voltages
dat.Vn=Vn;
dat.wn = wn;

Vn = dat.Vn;
wn = dat.wn;
Zb = Vn^2/100e6;

% Bus data
dat.Psg1 = SG1.P0/100e6;
dat.Psg2 = SG2.P0/100e6;
dat.Pvsc = Pd_tot/100e6-dat.Psg1-dat.Psg2;
dat.Vsg1 = 1;
dat.Vsg2 = 1;
dat.Vvsc = 1;

% Branch data
Xac = Lac*wn;
Bac = Cac*wn;

%VSC
dat.kfd_vsc = kfd_vsc;


%=================================
% Synchronous Generator 1 
%=================================
dat.SG1.kfd_sg = SG1.kfd_sg; %Ganancia droop del generador síncrono (MW/Hz)
%Stator RL parameters (SI)
dat.SG1.Rs= SG1.Rs;     % resistance (ohms)
dat.SG1.Ll= SG1.Ll;  % leakage inductance (H) 
dat.SG1.Lmd=SG1.Lmd;  % d-axis magnetizing inductance (H)  
dat.SG1.Lmq=SG1.Lmq;   % q-axis magnetizing inductance (H)
%Field parameters
dat.SG1.Rfd = SG1.Rf_prime;
dat.SG1.Llfd = SG1.Llfd_prime;
%Equivalent impedance
dat.SG1.Xd = (dat.SG1.Ll + 1/(1/dat.SG1.Lmd))*wn;     
%Exciter SG
dat.SG1.Ka = KA*Rf_pu/Lmd_pu; %[pu]

%=================================
% Synchronous Generator 1 
%=================================
dat.SG2.kfd_sg = SG2.kfd_sg; %Ganancia droop del generador síncrono (MW/Hz)
%Stator RL parameters (SI)
dat.SG2.Rs= SG2.Rs;     % resistance (ohms)
dat.SG2.Ll= SG2.Ll;  % leakage inductance (H) 
dat.SG2.Lmd=SG2.Lmd;  % d-axis magnetizing inductance (H)  
dat.SG2.Lmq=SG2.Lmq;   % q-axis magnetizing inductance (H)
%Field parameters
dat.SG2.Rfd = SG2.Rf_prime;
dat.SG2.Llfd = SG2.Llfd_prime;
%Equivalent impedance
dat.SG2.Xd = (dat.SG2.Ll + 1/(1/dat.SG2.Lmd))*wn;     
%Exciter SG
dat.SG2.Ka = KA*Rf_pu/Lmd_pu; %[pu]

% Branch data
%	fbus	tbus	r	x	b	
branch = [
	1	2	Rac	Xac	Bac;
    2	6	Rac	Xac	Bac;
    2	3	Rac	Xac	Bac;
    2	4	Rac	Xac	Bac;
    4	6	Rac	Xac	Bac;
    4	5	Rac	Xac	Bac;
    6	8	Rac	Xac	Bac;
    6	7	Rac	Xac	Bac;  
    7	8	Rac	Xac	Bac;
    8	9	Rac	Xac	Bac;];

dat.SG1.Ysgsg = 1/(dat.SG1.Rs+i*dat.SG1.Xd)*Zb;
dat.SG1.Ysg = -dat.SG1.Ysgsg;

dat.SG2.Ysgsg = 1/(dat.SG2.Rs+i*dat.SG2.Xd)*Zb;
dat.SG2.Ysg = -dat.SG2.Ysgsg;

dat.Yl = 1/(Rac+i*Xac)*Zb;

dat.Y11 = (1/(Rac+i*Xac)+i*Bac)*Zb;
dat.Y22 = (4/(Rac+i*Xac)+i*4*Bac+1/Rd20)*Zb;
dat.Y33 = (1/(Rac+i*Xac)+i*Bac+1/Rd30)*Zb;
dat.Y44 = (3/(Rac+i*Xac)+i*3*Bac+1/Rd40)*Zb;
dat.Y55 = (1/(Rac+i*Xac)+i*Bac+1/Rd50)*Zb;
dat.Y66 = (4/(Rac+i*Xac)+i*4*Bac+1/Rd60)*Zb;
dat.Y77 = (2/(Rac+i*Xac)+i*2*Bac+1/Rd70)*Zb;
dat.Y88 = (3/(Rac+i*Xac)+i*3*Bac+1/Rd80)*Zb;
dat.Y99 = (1/(Rac+i*Xac)+i*Bac+1/Rd90)*Zb;

dat.Yii =[dat.Y11 dat.Y22 dat.Y33 dat.Y44 dat.Y55 dat.Y66 dat.Y77 dat.Y88 dat.Y99];
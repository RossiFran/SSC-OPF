% Parametros SG + VSC

%VSC
Vn = 24e3;%220e3; %compuesta
Sn = 500e6;  
In_vsc = Sn/(sqrt(3)*Vn);
Vpeak = Vn/sqrt(3)*sqrt(2); %simple
Ipeak = sqrt(2)*In_vsc;
fn = 50;
wn = 2*pi*fn;

kfd_vsc = Sn/(50*Rdroop);

% Demand

DPd2 = Pd20*0.01;
Rd20 = Vn^2/(Pd20);
Rd2f = Vn^2/(Pd20+DPd2);
DRd2 = Rd2f-Rd20;

DPd3 = Pd30*0.01;
Rd30 = Vn^2/(Pd30);
Rd3f = Vn^2/(Pd30+DPd3);
DRd3 = Rd3f-Rd30;

DPd4 = Pd40*0.01;
Rd40 = Vn^2/(Pd40);
Rd4f = Vn^2/(Pd40+DPd4);
DRd4 = Rd4f-Rd40;

DPd5 = Pd50*0.01;
Rd50 = Vn^2/(Pd50);
Rd5f = Vn^2/(Pd50+DPd5);
DRd5 = Rd5f-Rd50;

DPd6 = Pd60*0.01;
Rd60 = Vn^2/(Pd60);
Rd6f = Vn^2/(Pd60+DPd6);
DRd6 = Rd6f-Rd60;

DPd7 = Pd70*0.01;
Rd70 = Vn^2/(Pd70);
Rd7f = Vn^2/(Pd70+DPd7);
DRd7 = Rd7f-Rd70;

DPd8 = Pd80*0.01;
Rd80 = Vn^2/(Pd80);
Rd8f = Vn^2/(Pd80+DPd8);
DRd8 = Rd8f-Rd80;

DPd9 = Pd90*0.01;
Rd90 = Vn^2/(Pd90);
Rd9f = Vn^2/(Pd90+DPd9);
DRd9 = Rd9f-Rd90;


% Filtro de red
Xn = Vn^2/Sn;
Rc = 0.01*(Xn);
Lc = 0.20*(Xn/wn);
%C = 1/5.88*(1/(wn*Xn));

% Impedancia linea (aprox 300 MVA)
np = 1; %numero de lineas en paralelo
l = 10; %km
Lpu = 1e-3/np; % 1 mH/km;
Rpu = 0.03/np; %0.03 ohm/km
Cpu = 0.01e-6;%0.01*np; %C/2 = 0.01 uF/km 
Vl = 220e3; %Parameters at 220 kV

Lac = Lpu*l*(Vn/Vl)^2;
Rac = Rpu*l*(Vn/Vl)^2;
Cac = Cpu*l/(Vn/Vl)^2;

In_line = [600, 500, 100, 500, 500, 300, 250, 250, 250, 110]*1e6/Vn*sqrt(2/3);

% Lazo de corriente: respuesta primer orden
factor_i=1;
tau_i = factor_i*1e-3;
kp_i = Lc/tau_i;
ki_i = Rc/tau_i;

% Lazo de potencia AC
tau_pac = 0.1;
kp_pac = tau_i/tau_pac;
ki_pac = 1/tau_pac;
tau_fp = 10e-3;

% Lazo de tensión AC
tau_v = 0.1;
kp_v = tau_i/tau_v;
ki_v = 1/tau_v;
tau_fv = 10e-3;

% PARÁMETROS PLL
ts=0.02;
%Em = sqrt(2)*Vn;    % [V]
xi_pll = 0.707;
wn2 = 4/(ts*xi_pll);
kp_pll = 2*wn2*xi_pll/Vpeak;
tau_pll = 2*xi_pll/wn2;
ki_pll = kp_pll/tau_pll;

% Droop SG + turbina
Khp = 0.25; %fracción turbina alta presión
Klp = 1-Khp; %fracción turbina baja presión
tau_lp = 5; %1 s

% Machine parameters from Kundur Examples 3.1, 3.2,  8.1 (pages 91,102, 345)
% "Power System Stability and Control"  McGraw-Hill  book, 1994
% --------------------------------------------------------------------
% Nominal parameters
%Pn= 300e6; %555e6;   % three-phase nominal power (VA)
Vsg=  24e3;    % nominal LL voltage (Vrms)

% Standard parameters

%=================================
% PARAMETERS
%=================================
% Standard parameters
Ld_pu = 1.66;
Lq_pu = 1.61;
Ll_pu = 0.15;
Rs_pu = 0.003;

Lmd_pu = Ld_pu-Ll_pu;
Lmq_pu = Lq_pu-Ll_pu;

Lfd_pu = 0.165;
Rf_pu = 0.0006;

L1d_pu = 0.1713;
R1d_pu = 0.0284;

L1q_pu = 0.7252;
R1q_pu = 0.00619;

L2q_pu = 0.125;
R2q_pu = 0.002368;

% Stator base values
fn = 50;
wbase=2*pi*fn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generator 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SG1.kfd_sg = SG1.Pn/(50*0.05); %Ganancia droop del generador síncrono (MW/Hz)

SG1.Vsbase=Vsg/sqrt(3)*sqrt(2);
SG1.Isbase=SG1.Pn/Vsg/sqrt(3)*sqrt(2);
SG1.Zsbase=Vsg^2/SG1.Pn;
SG1.Lsbase=SG1.Zsbase/wbase;

%Stator RL parameters (SI)
SG1.Rs= Rs_pu*SG1.Zsbase; %0.0031;     % resistance (ohms)
SG1.Ll= Ll_pu*SG1.Lsbase; %0.4129e-3;  % leakage inductance (H) 
SG1.Lmd=Lmd_pu*SG1.Lsbase; %4.5696e-3;  % d-axis magnetizing inductance (H)  
SG1.Lmq=Lmq_pu*SG1.Lsbase; %4.432e-3;   % q-axis magnetizing inductance (H)

% Field base values
SG1.ifn = sqrt(2/3)*Vn/Lfd_pu/wn;
SG1.Ifbase=SG1.ifn*Lmd_pu;
SG1.Vfbase=SG1.Pn/SG1.Ifbase;
SG1.Zfbase=SG1.Vfbase/SG1.Ifbase;
SG1.Lfbase=SG1.Zfbase/wbase;

% Field RL parameters (SI)
SG1.Rf= Rf_pu*SG1.Zfbase; %0.0715;    %  resistance (ohms)
SG1.Llfd= Lfd_pu*SG1.Lfbase; %0.57692; %  self inductance (H)

% Transformation ratio Ns/Nf
SG1.Ns_Nf=2/3*SG1.Ifbase/SG1.Isbase;

% Field parameters referred to the stator
SG1.Rf_prime=SG1.Rf*3/2*SG1.Ns_Nf^2;
SG1.Llfd_prime=SG1.Llfd*3/2*SG1.Ns_Nf^2;

% Damper RL parameters from Kundur Example 3.2 
SG1.Rkd   = R1d_pu*SG1.Zsbase; 
SG1.Llkd  = L1d_pu*SG1.Lsbase; 
SG1.Rkq1  = R1q_pu*SG1.Zsbase;  
SG1.Llkq1 = L1q_pu*SG1.Lsbase; 
SG1.Rkq2  = R2q_pu*SG1.Zsbase;  
SG1.Llkq2 = L2q_pu*SG1.Lsbase;
            
% Nominal field voltage
SG1.Vfn=SG1.Rf*SG1.ifn;
% Nominal field voltage and current referred to stator
SG1.Vfn_prime=Rf_pu/Lmd_pu*SG1.Vsbase;
SG1.Ifn_prime=SG1.Isbase/Lmd_pu;

% Inertia
SG1.H= 4.5;%3.7; % sec
SG1.wm= 2*pi*50; %rad/s
SG1.J= 2*SG1.H*SG1.Pn/SG1.wm^2; % kg.m^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generator 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SG2.kfd_sg = SG2.Pn/(50*0.05); %Ganancia droop del generador síncrono (MW/Hz)

SG2.Vsbase=Vsg/sqrt(3)*sqrt(2);
SG2.Isbase=SG2.Pn/Vsg/sqrt(3)*sqrt(2);
SG2.Zsbase=Vsg^2/SG2.Pn;
SG2.Lsbase=SG2.Zsbase/wbase;

%Stator RL parameters (SI)
SG2.Rs= Rs_pu*SG2.Zsbase; %0.0031;     % resistance (ohms)
SG2.Ll= Ll_pu*SG2.Lsbase; %0.4129e-3;  % leakage inductance (H) 
SG2.Lmd=Lmd_pu*SG2.Lsbase; %4.5696e-3;  % d-axis magnetizing inductance (H)  
SG2.Lmq=Lmq_pu*SG2.Lsbase; %4.432e-3;   % q-axis magnetizing inductance (H)

% Field base values
SG2.ifn = sqrt(2/3)*Vn/Lfd_pu/wn;
SG2.Ifbase=SG2.ifn*Lmd_pu;
SG2.Vfbase=SG2.Pn/SG2.Ifbase;
SG2.Zfbase=SG2.Vfbase/SG2.Ifbase;
SG2.Lfbase=SG2.Zfbase/wbase;

% Field RL parameters (SI)
SG2.Rf= Rf_pu*SG2.Zfbase; %0.0715;    %  resistance (ohms)
SG2.Llfd= Lfd_pu*SG2.Lfbase; %0.57692; %  self inductance (H)

% Transformation ratio Ns/Nf
SG2.Ns_Nf=2/3*SG2.Ifbase/SG2.Isbase;

% Field parameters referred to the stator
SG2.Rf_prime=SG2.Rf*3/2*SG2.Ns_Nf^2;
SG2.Llfd_prime=SG2.Llfd*3/2*SG2.Ns_Nf^2;

% Damper RL parameters from Kundur Example 3.2 
SG2.Rkd   = R1d_pu*SG2.Zsbase; 
SG2.Llkd  = L1d_pu*SG2.Lsbase; 
SG2.Rkq1  = R1q_pu*SG2.Zsbase;  
SG2.Llkq1 = L1q_pu*SG2.Lsbase; 
SG2.Rkq2  = R2q_pu*SG2.Zsbase;  
SG2.Llkq2 = L2q_pu*SG2.Lsbase;
            
% Nominal field voltage
SG2.Vfn=SG2.Rf*SG2.ifn;
% Nominal field voltage and current referred to stator
SG2.Vfn_prime=Rf_pu/Lmd_pu*SG2.Vsbase;
SG2.Ifn_prime=SG2.Isbase/Lmd_pu;

% Inertia
SG2.H= 4.5;%3.7; % sec
SG2.wm= 2*pi*50; %rad/s
SG2.J= 2*SG2.H*SG2.Pn/SG2.wm^2; % kg.m^2


%Exciter SG
TR = 0;
VImin = -10; %pu Lower limint on error signal
VImax = 10; %pu Upper limit on error signal
TC = 1; % [s] Lead time constant
TB = 10; %[s] Lag time constant
KA = 200; %[pu]
TA = 0.015; %[s] Regulator time constant
VRmin = -4.53; %[pu] Minimum output
VRmax = 5.64; %[pu] Maximum regulator
s = tf('s');
tfexc = ((TC*s+1)/(TB*s+1)*KA/(TA*s+1)); %*(Rf_pu/Lmd_pu*SG1.Vsbase)
[Aexc,Bexc,Cexc,Dexc] = tf2ss(tfexc.num{1,1},tfexc.den{1,1});

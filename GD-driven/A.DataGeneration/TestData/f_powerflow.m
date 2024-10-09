function [c,ceq] = f_powerflow(x,dat,kd)

% ------------------------------- Variables -------------------------------

% ----- AC#1 -----
V1 =        x(1);
V2 =        x(2);
V3 =        x(3);
V4 =        x(4);
V5 =        x(5);
V6 =        x(6);
V7 =        x(7);
V8 =        x(8);
V9 =        x(9);
Theta1 =    x(10);
Theta2 =    x(11);
Theta3 =    x(12);
Theta4 =    x(13);
Theta5 =    x(14);
Theta6 =    x(15);
Theta7 =    x(16);
Theta8 =    x(17);
Theta9 =    x(18);
P1 =        x(19);
Q1 =        x(20);
P5 =        x(21);
P6 =        x(22);

f =         x(23);
Pe1x=       x(24);
Pe5x=      x(25);
Pe6x=      x(26);

% ------------------------------ Data needed ------------------------------

% Nominal AC voltages
Vsg1 = dat.Vsg1;
Vsg2 = dat.Vsg2;
Vvsc = dat.Vvsc;

% Impedances
% Ysgsg1 = dat.SG1.Ysgsg;
% Ysg1 = dat.SG1.Ysg;
% 
% Ysgsg2 = dat.SG2.Ysgsg;
% Ysg2 = dat.SG2.Ysg;

Y11 = dat.Y11;
Y22 = dat.Y22;
Y33 = dat.Y33;
Y44 = dat.Y44;
Y55 = dat.Y55;
Y66 = dat.Y66;
Y77 = dat.Y77;
Y88 = dat.Y88;
Y99 = dat.Y99;

Y12 = -dat.Yl;
Y21 = -dat.Yl;
Y23 = -dat.Yl;
Y24 = -dat.Yl;
Y26 = -dat.Yl;
Y32 = -dat.Yl;
Y42 = -dat.Yl;
Y45 = -dat.Yl;
Y46 = -dat.Yl;
Y54 = -dat.Yl;
Y62 = -dat.Yl;
Y64 = -dat.Yl;
Y67 = -dat.Yl;
Y68 = -dat.Yl;
Y76 = -dat.Yl;
Y78 = -dat.Yl;
Y86 = -dat.Yl;
Y87 = -dat.Yl;
Y89 = -dat.Yl;
Y98 = -dat.Yl;

% External PQ
%Pe1x=dat.Pvsc;
Pe2x=0;
Qe2x=0;
Pe3x=0;
Qe3x=0;
Pe4x=0;
Qe4x=0;
%Pe5x=0;
%Pe5bx=dat.Psg2;
Qe5x=0;
%Pe6bx=dat.Psg1;
%Pe6x=0;
Qe6x=0;
Pe7x=0;
Qe7x=0;
Pe8x=0;
Qe8x=0;
Pe9x=0;
Qe9x=0;

%Slack
epsilon2=1e-12; %small value to avoid numerical issues

% ------------------------------- Equations -------------------------------

% ----- AC#1 -----
% Node 1 (PV - KNW: P1, V1 / UNK: Theta1, Q1)
ceq(1) = P1 - V1*V1*real(Y11)...
        - V1*V2*(real(Y12)*cos(Theta1-Theta2)+imag(Y12)*sin(Theta1-Theta2));
ceq(2) = Q1 + V1*V1*imag(Y11)...
    - V1*V2*(real(Y12)*sin(Theta1-Theta2)-imag(Y12)*cos(Theta1-Theta2));
ceq(3) = V1 - Vvsc; % Generator eq



% Node 2 (PQ - KNW: Pe2, Qe2 / UNK: V2, Theta2)
ceq(4) = Pe2x - V2*V2*real(Y22)...
            - V2*V1*(real(Y21)*cos(Theta2-Theta1)+imag(Y21)*sin(Theta2-Theta1))...
            - V2*V3*(real(Y23)*cos(Theta2-Theta3)+imag(Y23)*sin(Theta2-Theta3))...
            - V2*V4*(real(Y24)*cos(Theta2-Theta4)+imag(Y24)*sin(Theta2-Theta4))...
            - V2*V6*(real(Y26)*cos(Theta2-Theta6)+imag(Y26)*sin(Theta2-Theta6));
ceq(5) = Qe2x + V2*V2*imag(Y22)...
            - V2*V1*(real(Y21)*sin(Theta2-Theta1)-imag(Y21)*cos(Theta2-Theta1))...
            - V2*V3*(real(Y23)*sin(Theta2-Theta3)-imag(Y23)*cos(Theta2-Theta3))...
            - V2*V4*(real(Y24)*sin(Theta2-Theta4)-imag(Y24)*cos(Theta2-Theta4))...
            - V2*V6*(real(Y26)*sin(Theta2-Theta6)-imag(Y26)*cos(Theta2-Theta6));
        
% Node 3 (PQ - KNW: Pe3, Qe3 / UNK: V3, Theta3)
ceq(6) = Pe3x - V3*V3*real(Y33)...
            - V3*V2*(real(Y32)*cos(Theta3-Theta2)+imag(Y32)*sin(Theta3-Theta2));
ceq(7) = Qe3x + V3*V3*imag(Y33)...
            - V3*V2*(real(Y32)*sin(Theta3-Theta2)-imag(Y32)*cos(Theta3-Theta2));
        
% Node 4 (PQ - KNW: Pe4, Qe4 / UNK: V4, Theta4)
ceq(8) = Pe4x - V4*V4*real(Y44)...
            - V4*V2*(real(Y42)*cos(Theta4-Theta2)+imag(Y42)*sin(Theta4-Theta2))...
            - V4*V5*(real(Y45)*cos(Theta4-Theta5)+imag(Y45)*sin(Theta4-Theta5))...
            - V4*V6*(real(Y46)*cos(Theta4-Theta6)+imag(Y46)*sin(Theta4-Theta6));
ceq(9) = Qe4x + V4*V4*imag(Y44)...
            - V4*V2*(real(Y42)*sin(Theta4-Theta2)-imag(Y42)*cos(Theta4-Theta2))...
            - V4*V5*(real(Y45)*sin(Theta4-Theta5)-imag(Y45)*cos(Theta4-Theta5))...
            - V4*V6*(real(Y46)*sin(Theta4-Theta6)-imag(Y46)*cos(Theta4-Theta6));
        
% Node 5 (with b) (PV - KNW: Pe5, V5 / UNK: Q5, Theta5)
ceq(10) = P5 - V5*V5*real(Y55)...
            - V5*V4*(real(Y54)*cos(Theta5-Theta4)+imag(Y54)*sin(Theta5-Theta4));
ceq(11) = Qe5x + V5*V5*imag(Y55)...
            - V5*V4*(real(Y54)*sin(Theta5-Theta4)-imag(Y54)*cos(Theta5-Theta4));
        
% Node 6 (with b) (slack - KNW: V6, Theta6 / UNK: P6, Q6)
ceq(12) = P6 - V6*V6*real(Y66)...
        - V6*V2*(real(Y62)*cos(Theta6-Theta2)+imag(Y62)*sin(Theta6-Theta2))...
        - V6*V4*(real(Y64)*cos(Theta6-Theta4)+imag(Y64)*sin(Theta6-Theta4))...
        - V6*V7*(real(Y67)*cos(Theta6-Theta7)+imag(Y67)*sin(Theta6-Theta7))...
        - V6*V8*(real(Y68)*cos(Theta6-Theta8)+imag(Y68)*sin(Theta6-Theta8));
ceq(13) = Qe6x + V6*V6*imag(Y66)...
        - V6*V2*(real(Y62)*sin(Theta6-Theta2)-imag(Y62)*cos(Theta6-Theta2))...
        - V6*V4*(real(Y64)*sin(Theta6-Theta4)-imag(Y64)*cos(Theta6-Theta4))...
        - V6*V7*(real(Y67)*sin(Theta6-Theta7)-imag(Y67)*cos(Theta6-Theta7))...
        - V6*V8*(real(Y68)*sin(Theta6-Theta8)-imag(Y68)*cos(Theta6-Theta8));

% Node 7 (PQ - KNW: Pe7, Qe7 / UNK: V7, Theta7)
ceq(14) = Pe7x - V7*V7*real(Y77)...
            - V7*V6*(real(Y76)*cos(Theta7-Theta6)+imag(Y76)*sin(Theta7-Theta6))...
            - V7*V8*(real(Y78)*cos(Theta7-Theta8)+imag(Y78)*sin(Theta7-Theta8));
ceq(15) = Qe7x + V7*V7*imag(Y77)...
            - V7*V6*(real(Y76)*sin(Theta7-Theta6)-imag(Y76)*cos(Theta7-Theta6))...
            - V7*V8*(real(Y78)*sin(Theta7-Theta8)-imag(Y78)*cos(Theta7-Theta8));
        
% Node 8 (PQ - KNW: Pe8, Qe8 / UNK: V8, Theta8)
ceq(16) = Pe8x - V8*V8*real(Y88)...
            - V8*V6*(real(Y86)*cos(Theta8-Theta6)+imag(Y86)*sin(Theta8-Theta6))...
            - V8*V7*(real(Y87)*cos(Theta8-Theta7)+imag(Y87)*sin(Theta8-Theta7))...
            - V8*V9*(real(Y89)*cos(Theta8-Theta9)+imag(Y89)*sin(Theta8-Theta9));
ceq(17) = Qe8x + V8*V8*imag(Y88)...
            - V8*V6*(real(Y86)*sin(Theta8-Theta6)-imag(Y86)*cos(Theta8-Theta6))...
            - V8*V7*(real(Y87)*sin(Theta8-Theta7)-imag(Y87)*cos(Theta8-Theta7))...
            - V8*V9*(real(Y89)*sin(Theta8-Theta9)-imag(Y89)*cos(Theta8-Theta9));

% Node 9 (PQ - KNW: Pe9, Qe9 / UNK: V9, Theta9)
ceq(18) = Pe9x - V9*V9*real(Y99)...
            - V9*V8*(real(Y98)*cos(Theta9-Theta8)+imag(Y98)*sin(Theta9-Theta8));
ceq(19) = Qe9x + V9*V9*imag(Y99)...
            - V9*V8*(real(Y98)*sin(Theta9-Theta8)-imag(Y98)*cos(Theta9-Theta8));
        

%Frequency droops
ceq(20) = P1 - (Pe1x+dat.kfd_vsc/100e6*(50-f)); % Frequency droop VSC
ceq(21) = P5 - (Pe5x+dat.SG2.kfd_sg/100e6*(50-f)); %Frequency droop SG2 
ceq(22) = P6 - (Pe6x+dat.SG1.kfd_sg/100e6*(50-f)); %Frequency droop SG1 

ceq(23) = Theta1 - epsilon2;

c=[];
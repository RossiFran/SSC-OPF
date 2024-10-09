%---------------------------------------------------------
% SS_model
% Espacio de estados del modelo VSC + generador síncrono
% Incluye: red (inductancia VSC + carga), 
% VSC: lazo de corriente, PLL, droop de frecuencia VSC, filtro primer orden
% de modulación
% Generador: generador, governor, turbina, excitador
%---------------------------------------------------------

% State Space converter line (converter filter)
Alc = [-(Rc)/(Lc) -wg10;
        wg10 -(Rc)/(Lc)];

Blc = [1/(Lc), 0, -1/(Lc), 0, -icd0;
    0, 1/(Lc), 0, -1/(Lc), icq0];
     
Clc = [1, 0;
        0, 1];

Dlc = [0, 0, 0, 0, 0;
       0, 0, 0, 0, 0];
lc_x={'ic_qx','ic_dx'};
lc_u={'vpcc_q','vpcc_d','vc_q','vc_d','w1'};
lc_y={'ic_q','ic_d'};
lc = ss(Alc,Blc,Clc,Dlc,'StateName',lc_x,'inputname',lc_u,'outputname',lc_y);

% State Space line 1
Al1 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl1 = [1/(Lac), 0, -1/(Lac), 0, -i1d0;
    0, 1/(Lac), 0, -1/(Lac), i1q0];
     
Cl1 = [1, 0;
        0, 1];

Dl1 = zeros(2,5);

l1_x={'i1_qx','i1_dx'};
l1_u={'vpcc_q','vpcc_d','v2q','v2d','w1'};
l1_y={'i1_q','i1_d'};
l1 = ss(Al1,Bl1,Cl1,Dl1,'StateName',l1_x,'inputname',l1_u,'outputname',l1_y);

% State Space line 2
Al2 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl2 = [1/(Lac), 0, -1/(Lac), 0, -i2d0;
    0, 1/(Lac), 0, -1/(Lac), i2q0];
     
Cl2 = [1, 0;
        0, 1];

Dl2 = zeros(2,5);

l2_x={'i2_qx','i2_dx'};
l2_u={'v6q','v6d','v2q','v2d','w1'};
l2_y={'i2_q','i2_d'};
l2 = ss(Al2,Bl2,Cl2,Dl2,'StateName',l2_x,'inputname',l2_u,'outputname',l2_y);

% State Space line 3
Al3 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl3 = [1/Lac, 0, -1/Lac, 0, -i3d0;
    0, 1/Lac, 0, -1/Lac, i3q0];
     
Cl3 = [1, 0;
        0, 1];

Dl3 = zeros(2,5);

l3_x={'i3_qx','i3_dx'};
l3_u={'v2q','v2d','v3q','v3d','w1'};
l3_y={'i3_q','i3_d'};
l3 = ss(Al3,Bl3,Cl3,Dl3,'StateName',l3_x,'inputname',l3_u,'outputname',l3_y);

% State Space line 4
Al4 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl4 = [1/Lac, 0, -1/Lac, 0, -i4d0;
    0, 1/Lac, 0, -1/Lac, i4q0];
     
Cl4 = [1, 0;
        0, 1];

Dl4 = zeros(2,5);

l4_x={'i4_qx','i4_dx'};
l4_u={'v4q','v4d','v2q','v2d','w1'};
l4_y={'i4_q','i4_d'};
l4 = ss(Al4,Bl4,Cl4,Dl4,'StateName',l4_x,'inputname',l4_u,'outputname',l4_y);

% State Space line 5
Al5 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl5 = [1/(Lac), 0, -1/(Lac), 0, -i5d0;
    0, 1/(Lac), 0, -1/(Lac), i5q0];
     
Cl5 = [1, 0;
        0, 1];

Dl5 = zeros(2,5);

l5_x={'i5_qx','i5_dx'};
l5_u={'v6q','v6d','v4q','v4d','w1'};
l5_y={'i5_q','i5_d'};
l5 = ss(Al5,Bl5,Cl5,Dl5,'StateName',l5_x,'inputname',l5_u,'outputname',l5_y);

% State Space line 6
Al6 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl6 = [1/(Lac), 0, -1/(Lac), 0, -i6d0;
    0, 1/(Lac), 0, -1/(Lac), i6q0];
     
Cl6 = [1, 0;
        0, 1];

Dl6 = zeros(2,5);

l6_x={'i6_qx','i6_dx'};
l6_u={'v4q','v4d','v5q','v5d','w1'};
l6_y={'i6_q','i6_d'};
l6 = ss(Al6,Bl6,Cl6,Dl6,'StateName',l6_x,'inputname',l6_u,'outputname',l6_y);

% State Space line 7
Al7 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl7 = [1/Lac, 0, -1/Lac, 0, -i7d0;
    0, 1/Lac, 0, -1/Lac, i7q0];
     
Cl7 = [1, 0;
        0, 1];

Dl7 = zeros(2,5);

l7_x={'i7_qx','i7_dx'};
l7_u={'v8q','v8d','v6q','v6d','w1'};
l7_y={'i7_q','i7_d'};
l7 = ss(Al7,Bl7,Cl7,Dl7,'StateName',l7_x,'inputname',l7_u,'outputname',l7_y);

% State Space line 8
Al8 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl8 = [1/Lac, 0, -1/Lac, 0, -i8d0;
    0, 1/Lac, 0, -1/Lac, i8q0];
     
Cl8 = [1, 0;
        0, 1];

Dl8 = zeros(2,5);

l8_x={'i8_qx','i8_dx'};
l8_u={'v6q','v6d','v7q','v7d','w1'};
l8_y={'i8_q','i8_d'};
l8 = ss(Al8,Bl8,Cl8,Dl8,'StateName',l8_x,'inputname',l8_u,'outputname',l8_y);

% State Space line 9
Al9 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl9 = [1/Lac, 0, -1/Lac, 0, -i9d0;
    0, 1/Lac, 0, -1/Lac, i9q0];
     
Cl9 = [1, 0;
        0, 1];

Dl9 = zeros(2,5);

l9_x={'i9_qx','i9_dx'};
l9_u={'v7q','v7d','v8q','v8d','w1'};
l9_y={'i9_q','i9_d'};
l9 = ss(Al9,Bl9,Cl9,Dl9,'StateName',l9_x,'inputname',l9_u,'outputname',l9_y);

% State Space line 10
Al10 = [-Rac/Lac -wg10;
        wg10 -Rac/Lac];

Bl10 = [1/Lac, 0, -1/Lac, 0, -i10d0;
    0, 1/Lac, 0, -1/Lac, i10q0];
     
Cl10 = [1, 0;
        0, 1];

Dl10 = zeros(2,5);

l10_x={'i0_qx','i0_dx'};
l10_u={'v8q','v8d','v9q','v9d','w1'};
l10_y={'i10_q','i10_d'};
l10 = ss(Al10,Bl10,Cl10,Dl10,'StateName',l10_x,'inputname',l10_u,'outputname',l10_y);

% State Space capacitor in bus 1 (PCC)
Ac1 = [0 -wg10;
        wg10 0];

Bc1 = [1/(Cac), 0;
       0, 1/(Cac)];
     
Cc1 = [1, 0;
        0, 1];

Dc1 = zeros(2,2);

c1_x={'v1_qx','v1_dx'};
c1_u={'ic1_q','ic1_d'};
c1_y={'vpcc_q','vpcc_d'};
c1 = ss(Ac1,Bc1,Cc1,Dc1,'StateName',c1_x,'inputname',c1_u,'outputname',c1_y);


% State Space load in bus 2
Ad2 = [0];

Bd2 = [0 0 0];
     
Cd2 = [0;0];

Dd2 = [1/Rd20 0 -v2q0/Rd20^2;
        0 1/Rd20 -v2d0/Rd20^2];

d2_x={''};
d2_u={'v2q','v2d','Rd2'};
d2_y={'id2_q','id2_d'};
d2 = ss(Ad2,Bd2,Cd2,Dd2,'StateName', d2_x,'inputname',d2_u,'outputname',d2_y);

% State Space capacitor in bus 2
Ac2 = [0 -wg10;
        wg10 0];

Bc2 = [1/(4*Cac), 0;
       0, 1/(4*Cac)];
     
Cc2 = [1, 0;
        0, 1];

Dc2 = zeros(2,2);

c2_x={'v2_qx','v2_dx'};
c2_u={'ic2_q','ic2_d'};
c2_y={'v2q','v2d'};
c2 = ss(Ac2,Bc2,Cc2,Dc2,'StateName',c2_x,'inputname',c2_u,'outputname',c2_y);

% State Space load in bus 3
Ad3 = [0];

Bd3 = [0 0 0];
     
Cd3 = [0;0];

Dd3 = [1/Rd30 0 -v3q0/Rd30^2;
       0 1/Rd30 -v3d0/Rd30^2];

d3_x={''};
d3_u={'v3q','v3d','Rd3'};
d3_y={'id3_q','id3_d'};
d3 = ss(Ad3,Bd3,Cd3,Dd3,'StateName', d3_x,'inputname',d3_u,'outputname',d3_y);

% State Space capacitor in bus 3
Ac3 = [0 -wg10;
        wg10 0];

Bc3 = [1/(Cac), 0;
       0, 1/(Cac)];
     
Cc3 = [1, 0;
        0, 1];

Dc3 = zeros(2,2);

c3_x={'v3_qx','v3_dx'};
c3_u={'ic3_q','ic3_d'};
c3_y={'v3q','v3d'};
c3 = ss(Ac3,Bc3,Cc3,Dc3,'StateName',c3_x,'inputname',c3_u,'outputname',c3_y);

% State Space load in bus 4
Ad4 = [0];

Bd4 = [0 0 0];
     
Cd4 = [0;0];

Dd4 = [1/Rd40 0 -v4q0/Rd40^2;
       0 1/Rd40 -v4d0/Rd40^2];

d4_x={''};
d4_u={'v4q','v4d','Rd4'};
d4_y={'id4_q','id4_d'};
d4 = ss(Ad4,Bd4,Cd4,Dd4,'StateName', d4_x,'inputname',d4_u,'outputname',d4_y);

% State Space capacitor in bus 4
Ac4 = [0 -wg10;
        wg10 0];

Bc4 = [1/(3*Cac), 0;
       0, 1/(3*Cac)];
     
Cc4 = [1, 0;
        0, 1];

Dc4 = zeros(2,2);

c4_x={'v4_qx','v4_dx'};
c4_u={'ic4_q','ic4_d'};
c4_y={'v4q','v4d'};
c4 = ss(Ac4,Bc4,Cc4,Dc4,'StateName',c4_x,'inputname',c4_u,'outputname',c4_y);

% State Space load in bus 5
Ad5 = [0];

Bd5 = [0 0 0];
     
Cd5 = [0;0];

Dd5 = [1/Rd50 0 -vsg2q0/Rd50^2;
       0 1/Rd50 -vsg2d0/Rd50^2];

d5_x={''};
d5_u={'v5q','v5d','Rd5'};
d5_y={'id5_q','id5_d'};
d5 = ss(Ad5,Bd5,Cd5,Dd5,'StateName', d5_x,'inputname',d5_u,'outputname',d5_y);

% State Space capacitor in bus 5
Ac5 = [0 -wg10;
        wg10 0];

Bc5 = [1/(Cac), 0;
       0, 1/(Cac)];
     
Cc5 = [1, 0;
        0, 1];

Dc5 = zeros(2,2);

c5_x={'v5_qx','v5_dx'};
c5_u={'ic5_q','ic5_d'};
c5_y={'v5q','v5d'};
c5 = ss(Ac5,Bc5,Cc5,Dc5,'StateName',c5_x,'inputname',c5_u,'outputname',c5_y);

% State Space load in bus 6
Ad6 = [0];

Bd6 = [0 0 0];
     
Cd6 = [0;0];

Dd6 = [1/Rd60 0 -vsg1q0/Rd60^2;
       0 1/Rd60 -vsg1d0/Rd60^2];

d6_x={''};
d6_u={'v6q','v6d','Rd6'};
d6_y={'id6_q','id6_d'};
d6 = ss(Ad6,Bd6,Cd6,Dd6,'StateName', d6_x,'inputname',d6_u,'outputname',d6_y);

% State Space capacitor in bus 6
Ac6 = [0 -wg10;
        wg10 0];

Bc6 = [1/(4*Cac), 0;
       0, 1/(4*Cac)];
     
Cc6 = [1, 0;
        0, 1];

Dc6 = zeros(2,2);

c6_x={'v6_qx','v6_dx'};
c6_u={'ic6_q','ic6_d'};
c6_y={'v6q','v6d'};
c6 = ss(Ac6,Bc6,Cc6,Dc6,'StateName',c6_x,'inputname',c6_u,'outputname',c6_y);

% State Space load in bus 7
Ad7 = [0];

Bd7 = [0 0 0];
     
Cd7 = [0;0];

Dd7 = [1/Rd70 0 -v7q0/Rd70^2;
       0 1/Rd70 -v7d0/Rd70^2];

d7_x={''};
d7_u={'v7q','v7d','Rd7'};
d7_y={'id7_q','id7_d'};
d7 = ss(Ad7,Bd7,Cd7,Dd7,'StateName', d7_x,'inputname',d7_u,'outputname',d7_y);

% State Space capacitor in bus 7
Ac7 = [0 -wg10;
        wg10 0];

Bc7 = [1/(2*Cac), 0;
       0, 1/(2*Cac)];
     
Cc7 = [1, 0;
        0, 1];

Dc7 = zeros(2,2);

c7_x={'v7_qx','v7_dx'};
c7_u={'ic7_q','ic7_d'};
c7_y={'v7q','v7d'};
c7 = ss(Ac7,Bc7,Cc7,Dc7,'StateName',c7_x,'inputname',c7_u,'outputname',c7_y);

% State Space load in bus 8
Ad8 = [0];

Bd8 = [0 0 0];
     
Cd8 = [0;0];

Dd8 = [1/Rd80 0 -v8q0/Rd80^2;
       0 1/Rd80 -v8d0/Rd80^2];

d8_x={''};
d8_u={'v8q','v8d','Rd8'};
d8_y={'id8_q','id8_d'};
d8 = ss(Ad8,Bd8,Cd8,Dd8,'StateName', d8_x,'inputname',d8_u,'outputname',d8_y);

% State Space capacitor in bus 8
Ac8 = [0 -wg10;
        wg10 0];

Bc8 = [1/(3*Cac), 0;
       0, 1/(3*Cac)];
     
Cc8 = [1, 0;
        0, 1];

Dc8 = zeros(2,2);

c8_x={'v8_qx','v8_dx'};
c8_u={'ic8_q','ic8_d'};
c8_y={'v8q','v8d'};
c8 = ss(Ac8,Bc8,Cc8,Dc8,'StateName',c8_x,'inputname',c8_u,'outputname',c8_y);

% State Space load in bus 9
Ad9 = [0];

Bd9 = [0 0 0];
     
Cd9 = [0;0];

Dd9 = [1/Rd90 0 -v9q0/Rd90^2;
       0 1/Rd90 -v9d0/Rd90^2];

d9_x={''};
d9_u={'v9q','v9d','Rd9'};
d9_y={'id9_q','id9_d'};
d9 = ss(Ad9,Bd9,Cd9,Dd9,'StateName', d9_x,'inputname',d9_u,'outputname',d9_y);

% State Space capacitor in bus 9
Ac9 = [0 -wg10;
        wg10 0];

Bc9 = [1/(Cac), 0;
       0, 1/(Cac)];
     
Cc9 = [1, 0;
        0, 1];

Dc9 = zeros(2,2);

c9_x={'v9_qx','v9_dx'};
c9_u={'ic9_q','ic9_d'};
c9_y={'v9q','v9d'};
c9 = ss(Ac9,Bc9,Cc9,Dc9,'StateName',c9_x,'inputname',c9_u,'outputname',c9_y);

% State Space sum of currents bus 1 (PCC)
Aib1 = [0];

Bib1 = [0 0 0 0];
     
Cib1 = [0;0];

Dib1 = [-1 0 -1 0;
        0 -1 0 -1];
ib1_x={''};
ib1_u={'ic_q','ic_d','i1_q','i1_d'};
ib1_y={'ic1_q','ic1_d'};
ib1 = ss(Aib1,Bib1,Cib1,Dib1,'StateName', ib1_x,'inputname',ib1_u,'outputname',ib1_y);

% State Space sum of currents bus 2
Aib2 = [0];

Bib2 = [0 0 0 0 0 0 0 0 0 0];
     
Cib2 = [0;0];

Dib2 = [1 0 1 0 -1 0 1 0 -1 0;
        0 1 0 1 0 -1 0 1 0 -1];
ib2_x={''};
ib2_u={'i1_q','i1_d','i2_q','i2_d','i3_q','i3_d','i4_q','i4_d','id2_q','id2_d'};
ib2_y={'ic2_q','ic2_d'};
ib2 = ss(Aib2,Bib2,Cib2,Dib2,'StateName', ib2_x,'inputname',ib2_u,'outputname',ib2_y);

% State Space sum of currents bus 3
Aib3 = [0];

Bib3 = [0 0 0 0];
     
Cib3 = [0;0];

Dib3 = [1 0 -1 0;
        0 1 0 -1];
ib3_x={''};
ib3_u={'i3_q','i3_d','id3_q','id3_d'};
ib3_y={'ic3_q','ic3_d'};
ib3 = ss(Aib3,Bib3,Cib3,Dib3,'StateName', ib3_x,'inputname',ib3_u,'outputname',ib3_y);

% State Space sum of currents bus 4
Aib4 = [0];

Bib4 = [0 0 0 0 0 0 0 0];
     
Cib4 = [0;0];

Dib4 = [-1 0 1 0 -1 0 -1 0;
        0 -1 0 1 0 -1 0 -1];
ib4_x={''};
ib4_u={'i4_q','i4_d','i5_q','i5_d','i6_q','i6_d','id4_q','id4_d'};
ib4_y={'ic4_q','ic4_d'};
ib4 = ss(Aib4,Bib4,Cib4,Dib4,'StateName', ib4_x,'inputname',ib4_u,'outputname',ib4_y);

% State Space sum of currents bus 5
Aib5 = [0];

Bib5 = [0 0 0 0 0 0];
     
Cib5 = [0;0];

Dib5 = [1 0 1 0 -1 0;
        0 1 0 1 0 -1];
ib5_x={''};
ib5_u={'isg2q','isg2d','i6_q','i6_d','id5_q','id5_d'};
ib5_y={'ic5_q','ic5_d'};
ib5 = ss(Aib5,Bib5,Cib5,Dib5,'StateName', ib5_x,'inputname',ib5_u,'outputname',ib5_y);

% State Space sum of currents bus 6
Aib6 = [0];

Bib6 = [0 0 0 0 0 0 0 0 0 0 0 0];
     
Cib6 = [0;0];

Dib6 = [1 0 -1 0 -1 0 1 0 -1 0 -1 0;
        0 1 0 -1 0 -1 0 1 0 -1 0 -1];
ib6_x={''};
ib6_u={'isg1q','isg1d','i2_q','i2_d','i5_q','i5_d','i7_q','i7_d','i8_q','i8_d','id6_q','id6_d'};
ib6_y={'ic6_q','ic6_d'};
ib6 = ss(Aib6,Bib6,Cib6,Dib6,'StateName', ib6_x,'inputname',ib6_u,'outputname',ib6_y);

% State Space sum of currents bus 7
Aib7 = [0];

Bib7 = [0 0 0 0 0 0];
     
Cib7 = [0;0];

Dib7 = [1 0 -1 0 -1 0;
        0 1 0 -1 0 -1];
ib7_x={''};
ib7_u={'i8_q','i8_d','i9_q','i9_d','id7_q','id7_d'};
ib7_y={'ic7_q','ic7_d'};
ib7 = ss(Aib7,Bib7,Cib7,Dib7,'StateName', ib7_x,'inputname',ib7_u,'outputname',ib7_y);

% State Space sum of currents bus 8
Aib8 = [0];

Bib8 = [0 0 0 0 0 0 0 0];
     
Cib8 = [0;0];

Dib8 = [-1 0 1 0 -1 0 -1 0;
        0 -1 0 1 0 -1 0 -1];
ib8_x={''};
ib8_u={'i7_q','i7_d','i9_q','i9_d','i10_q','i10_d','id8_q','id8_d'};
ib8_y={'ic8_q','ic8_d'};
ib8 = ss(Aib8,Bib8,Cib8,Dib8,'StateName', ib8_x,'inputname',ib8_u,'outputname',ib8_y);

% State Space sum of currents bus 9
Aib9 = [0];

Bib9 = [0 0 0 0];
     
Cib9 = [0;0];

Dib9 = [1 0 -1 0;
        0 1 0 -1];
ib9_x={''};
ib9_u={'i10_q','i10_d','id9_q','id9_d'};
ib9_y={'ic9_q','ic9_d'};
ib9 = ss(Aib9,Bib9,Cib9,Dib9,'StateName', ib9_x,'inputname',ib9_u,'outputname',ib9_y);

% State Space grid
grid_x={'ic_qx','ic_dx','i1_qx','i1_dx','i2_qx','i2_dx','i3_qx','i3_dx','i4_qx','i4_dx','i5_qx','i5_dx','i6_qx','i6_dx','i7_qx','i7_dx','i8_qx','i8_dx','i9_qx','i9_dx','i10_qx','i10_dx','v1_qx','v1_dx','v2_qx','v2_dx','v3_qx','v3_dx','v4_qx','v4_dx','vsg2_qx','vsg2_dx','vsg1_qx','vsg1_dx','v7_qx','v7_dx','v8_qx','v8_dx','v9_qx','v9_dx'};
grid_u={'isg1q','isg1d','isg2q','isg2d','vc_q','vc_d','Rd2','Rd3','Rd4','Rd5','Rd6','Rd7','Rd8','Rd9','w1'};
grid_y={'ic_q','ic_d','vpcc_q','vpcc_d','v6q','v6d','v5q','v5d'};
SS_grid = connect(lc,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,c1,d2,c2,d3,c3,d4,c4,d5,c5,d6,c6,d7,c7,d8,c8,d9,c9,ib1,ib2,ib3,ib4,ib5,ib6,ib7,ib8,ib9,grid_u,grid_y);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VSC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Espacio de estados lazo de corriente AC
AicAC=[0 0;
       0 0];
BicAC=[1 0 0 0 0 0 0;
       0 1 0 0 0 0 0];
CicAC=[-ki_i 0;
       0 -ki_i];
DicAC=[-kp_i 0 0 -wg10*Lc 1 0 -Lc*icdc0; 
       0 -kp_i wg10*Lc 0 0 1 Lc*icqc0]; 
icAC_x={'Seicq','Seicd'};
icAC_u={'eic_q','eic_d','ic_qc','ic_dc','vpcc_qc','vpcc_dc','wm'};
icAC_y={'vc_qc','vc_dc'};
icAC = ss(AicAC,BicAC,CicAC,DicAC,'StateName',icAC_x,'inputname',icAC_u,'outputname',icAC_y);

% Espacio de estados error de corriente
Aeic=[0];
Beic=[0 0 0 0];
Ceic=[0;0];
Deic=[1 0 -1 0;
      0 1 0 -1]; 
eic_x={''};
eic_u={'ic_q_ref','ic_d_ref','ic_qc','ic_dc'};
eic_y={'eic_q','eic_d'};
eic = ss(Aeic,Beic,Ceic,Deic,'StateName',eic_x,'inputname',eic_u,'outputname',eic_y);

% Espacio de estados lazo de potencia AC VSC
APac=[0];
BPac=[1];
CPac=[-ki_pac*2/3/Vpeak];
DPac=[-kp_pac*2/3/Vpeak]; 
Pac_x={'SPacx'};
Pac_u={'ePac'};
Pac_y={'ic_q_ref'};
Pac = ss(APac,BPac,CPac,DPac,'StateName',Pac_x,'inputname',Pac_u,'outputname',Pac_y);

% Espacio de estados potencia AC VSC
Ampac=[0];
Bmpac=[0 0 0 0];
Cmpac=[0];
Dmpac=[-3/2*icq0 -3/2*icd0 -3/2*vpccq0 -3/2*vpccd0];

mpac_x={''};
mpac_u={'vpcc_q','vpcc_d','ic_q','ic_d'};
mpac_y={'Pac'};
mpac = ss(Ampac,Bmpac,Cmpac,Dmpac,'StateName',mpac_x,'inputname',mpac_u,'outputname',mpac_y);

%Espacio de estados filtro de potencia
[A,B,C,D] = tf2ss(1,[tau_fp 1]);
AfiltP=A;
BfiltP=B;
CfiltP=C;
DfiltP=D;
filtP_x={'filtP'};
filtP_u={'Pac'};
filtP_y={'Pacf'};
filtP = ss(AfiltP,BfiltP,CfiltP,DfiltP,'StateName',filtP_x,'inputname',filtP_u,'outputname',filtP_y);

% Espacio de estados droop vsc
Adfvsc=[0];
Bdfvsc=[0];
Cdfvsc=[0];
Ddfvsc=[-kfd_vsc/(2*pi)];
dfvsc_x={''};
dfvsc_u={'wm'};
dfvsc_y={'Pref'};
dfvsc = ss(Adfvsc,Bdfvsc,Cdfvsc,Ddfvsc,'StateName',dfvsc_x,'inputname',dfvsc_u,'outputname',dfvsc_y);

% Espacio de estados error potencia AC VSC
Aepac=[0];
Bepac=[0 0];
Cepac=[0];
Depac=[1 -1];

epac_x={''};
epac_u={'Pref','Pacf'};
epac_y={'ePac'};
epac = ss(Aepac,Bepac,Cepac,Depac,'StateName',epac_x,'inputname',epac_u,'outputname',epac_y);

% Espacio de estados lazo de tension AC VSC
AVac=[0];
BVac=[1];
CVac=[-ki_v];
DVac=[-kp_v]; 
Vac_x={'SVacx'};
Vac_u={'eVpccf'};
Vac_y={'ic_d_ref'};
Vac = ss(AVac,BVac,CVac,DVac,'StateName',Vac_x,'inputname',Vac_u,'outputname',Vac_y);

% Espacio de estados error de tension AC VSC
Aevac=[0];
Bevac=[0 0 0];
Cevac=[0];
Devac=[1 -vpccq0/sqrt(vpccq0^2+vpccd0^2) -vpccd0/sqrt(vpccq0^2+vpccd0^2)];
evac_x={''};
evac_u={'Vac_ref','vpcc_q','vpcc_d'};
evac_y={'eVpcc'};
evac = ss(Aevac,Bevac,Cevac,Devac,'StateName',evac_x,'inputname',evac_u,'outputname',evac_y);

%Espacio de estados filtro de tension
[A,B,C,D] = tf2ss(1,[tau_fv 1]);
AfiltV=A;
BfiltV=B;
CfiltV=C;
DfiltV=D;
filtV_x={'filtV'};
filtV_u={'eVpcc'};
filtV_y={'eVpccf'};
filtV = ss(AfiltV,BfiltV,CfiltV,DfiltV,'StateName',filtV_x,'inputname',filtV_u,'outputname',filtV_y);

% Espacio de estados PLL
Apll=[0 0;
      -ki_pll 0];
Bpll=[1 0;
      -kp_pll -1];
Cpll=[-ki_pll 0;
      0 1];
Dpll=[-kp_pll 0; 0 0];

pll_x={'pllx1','pllx2'};
pll_u={'vpcc_dc','w1'};
pll_y={'wm','e_theta'};
pll = ss(Apll,Bpll,Cpll,Dpll,'StateName',pll_x,'inputname',pll_u,'outputname',pll_y);

% Espacio de estados transformada i->ic
Ai_ic=[0];
Bi_ic=[0 0 0];
Ci_ic=[0;0];
Di_ic=[cos(e_theta_c0) -sin(e_theta_c0) -sin(e_theta_c0)*icq0-cos(e_theta_c0)*icd0;
      sin(e_theta_c0) cos(e_theta_c0) cos(e_theta_c0)*icq0-sin(e_theta_c0)*icd0];
i_ic_x={'iicx1'};
i_ic_u={'ic_q','ic_d','e_theta'};
i_ic_y={'ic_qc','ic_dc'};
i_ic = ss(Ai_ic,Bi_ic,Ci_ic,Di_ic,'StateName',i_ic_x,'inputname',i_ic_u,'outputname',i_ic_y);

% Espacio de estados transformada vpcc -> vpcc_c
Av_vc=[0];
Bv_vc=[0 0 0];
Cv_vc=[0;0];
Dv_vc=[cos(e_theta_c0) -sin(e_theta_c0) -sin(e_theta_c0)*vpccq0-cos(e_theta_c0)*vpccd0;
      sin(e_theta_c0) cos(e_theta_c0) cos(e_theta_c0)*vpccq0-sin(e_theta_c0)*vpccd0];
v_vc_x={'vvcx1'};
v_vc_u={'vpcc_q','vpcc_d','e_theta'};
v_vc_y={'vpcc_qc','vpcc_dc'};
v_vc = ss(Av_vc,Bv_vc,Cv_vc,Dv_vc,'StateName',v_vc_x,'inputname',v_vc_u,'outputname',v_vc_y);

% Espacio de estados antitransformada vc->v
Avc_v=[0];
Bvc_v=[0 0 0];
Cvc_v=[0;0];
Dvc_v=[cos(e_theta_c0) sin(e_theta_c0) -sin(e_theta_c0)*vconvqc0+cos(e_theta_c0)*vconvdc0;
      -sin(e_theta_c0) cos(e_theta_c0) -cos(e_theta_c0)*vconvqc0-sin(e_theta_c0)*vconvdc0];
vc_v_x={'vcvx1'};
vc_v_u={'vc_qc_pade','vc_dc_pade','e_theta'};
vc_v_y={'vc_q','vc_d'};
vc_v = ss(Avc_v,Bvc_v,Cvc_v,Dvc_v,'StateName',vc_v_x,'inputname',vc_v_u,'outputname',vc_v_y);

%Espacio de estado Pade
[A,B,C,D] = tf2ss(1,[100e-6 1]);
Apade=A;
Bpade=B;
Cpade=C;
Dpade=D;
padeq_x={'padeq'};
padeq_u={'vc_qc'};
padeq_y={'vc_qc_pade'};
padeq = ss(Apade,Bpade,Cpade,Dpade,'StateName',padeq_x,'inputname',padeq_u,'outputname',padeq_y);

paded_x={'paded'};
paded_u={'vc_dc'};
paded_y={'vc_dc_pade'};
paded = ss(Apade,Bpade,Cpade,Dpade,'StateName',paded_x,'inputname',paded_u,'outputname',paded_y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synchronous generator 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Espacio de estados turbina
SG1.Aturb=[-1/tau_lp];
SG1.Bturb=[Klp*SG1.kfd_sg/tau_lp -Klp*SG1.kfd_sg/tau_lp/(2*pi)];
SG1.Cturb=[1/(2*pi*50)];
SG1.Dturb=[Khp*SG1.kfd_sg/(2*pi*50) -Khp*SG1.kfd_sg/(2*pi)/(2*pi*50)];
SG1.turb_x={'Pm_1x'};
SG1.turb_u={'wref1','w1'};
SG1.turb_y={'Tm1'};
SG1.turb = ss(SG1.Aturb,SG1.Bturb,SG1.Cturb,SG1.Dturb,'StateName',SG1.turb_x,'inputname',SG1.turb_u,'outputname',SG1.turb_y);

% Espacio de estados exciter
SG1.exc_x={'ex1_1', 'ex1_2'};
SG1.exc_u={'Vsg1_mag'};
SG1.exc_y={'vfd1'};
SG1.exc = ss(Aexc,Bexc,Cexc,Dexc,'StateName',SG1.exc_x,'inputname',SG1.exc_u,'outputname',SG1.exc_y);

% Espacio de estados |Vsg|
SG1.Avsg=[0];
SG1.Bvsg=[0 0];
SG1.Cvsg=[0];
SG1.Dvsg=[-vsg1q0/sqrt(vsg1q0^2+vsg1d0^2)/(Vsg*sqrt(2/3)) -vsg1d0/sqrt(vsg1q0^2+vsg1d0^2)/(Vsg*sqrt(2/3))];
SG1.vsg_x={''};
SG1.vsg_u={'v6q','v6d'};
SG1.vsg_y={'Vsg1_mag'};
SG1.vsg = ss(SG1.Avsg,SG1.Bvsg,SG1.Cvsg,SG1.Dvsg,'StateName',SG1.vsg_x,'inputname',SG1.vsg_u,'outputname',SG1.vsg_y);

% Espacio de estados generador síncrono
     
SG1.R7 = [ -SG1.Rs 0 0 0 0 0 0;
           0 -SG1.Rs 0 0 0 0 0;
           0 0 SG1.Rf_prime 0 0 0 0;
           0 0 0 SG1.Rkd 0 0 0; 
           0 0 0 0 SG1.Rkq1 0 0;
           0 0 0 0 0 SG1.Rkq2 0;
           0 0 0 0 0 0 0];
    
SG1.M7 = [-SG1.Ll-SG1.Lmq 0 0 0 SG1.Lmq SG1.Lmq 0; 
     0 -SG1.Ll-SG1.Lmd SG1.Lmd SG1.Lmd 0 0 0; 
     0 -SG1.Lmd SG1.Llfd_prime+SG1.Lmd SG1.Lmd 0 0 0;
     0 -SG1.Lmd SG1.Lmd SG1.Llkd+SG1.Lmd 0 0 0;
     -SG1.Lmq 0 0 0 SG1.Llkq1+SG1.Lmq SG1.Lmq 0;
     -SG1.Lmq 0 0 0 SG1.Lmq SG1.Llkq2+SG1.Lmq 0;
     0 0 0 0 0 0 SG1.J];

SG1.M7inv = inv(SG1.M7);

SG1.N7 = [0 -wg10*(SG1.Ll+SG1.Lmd) wg10*SG1.Lmd wg10*SG1.Lmd 0 0 (-SG1.Ll-SG1.Lmd)*isd10+SG1.Lmd*ifd10+SG1.Lmd*ikd10;
      wg10*(SG1.Ll+SG1.Lmq) 0 0 0 -wg10*SG1.Lmq -wg10*SG1.Lmq (SG1.Ll+SG1.Lmq)*isq10-SG1.Lmq*ik1q10-SG1.Lmq*ik2q10; 
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      3/2*(isd10*(SG1.Lmq-SG1.Lmd)+SG1.Lmd*ifd10+SG1.Lmd*ikd10) 3/2*(isq10*(SG1.Lmq-SG1.Lmd)-ik1q10*SG1.Lmq-SG1.Lmq*ik2q10) 3/2*isq10*SG1.Lmd 3/2*isq10*SG1.Lmd -3/2*isd10*SG1.Lmq -3/2*isd10*SG1.Lmq 0];

SG1.Asg = -SG1.M7inv*(SG1.N7+SG1.R7);
SG1.Bsg = SG1.M7inv;
SG1.Csg = eye(7);%;3/2*(isd10*(Lmq_pu-Lmd_pu)+Lmd_pu*ifd0+Lmd_pu*ikd0) 3/2*(isq0*(Lmq_pu-Lmd_pu)-ikq0*Lmq_pu) 3/2*isq0*Lmd_pu 3/2*isq0*Lmd_pu -3/2*isd0*Lmq_pu 0 0];
SG1.Dsg = zeros(7);

SG1.sg_x={'isq1x','isd1x','ifd1x','ikd1x','ik1q1','ik2q1','wg1xx'};
SG1.sg_u={'v6q','v6d','vfd1','vkd1','vk1q1','vk2q1','Tm1'};
SG1.sg_y={'isg1q','isg1d','ifd1','ikd1','ik1q1','ik2q1','w1'};
SG1.sg = ss(SG1.Asg,SG1.Bsg,SG1.Csg,SG1.Dsg,'StateName',SG1.sg_x,'inputname',SG1.sg_u,'outputname',SG1.sg_y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synchronous generator 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Espacio de estados turbina
SG2.Aturb=[-1/tau_lp];
SG2.Bturb=[Klp*SG2.kfd_sg/tau_lp -Klp*SG2.kfd_sg/tau_lp/(2*pi)];
SG2.Cturb=[1/(2*pi*50)];
SG2.Dturb=[Khp*SG2.kfd_sg/(2*pi*50) -Khp*SG2.kfd_sg/(2*pi)/(2*pi*50)];
SG2.turb_x={'Pm_2x'};
SG2.turb_u={'wref2','w2'};
SG2.turb_y={'Tm2'};
SG2.turb = ss(SG2.Aturb,SG2.Bturb,SG2.Cturb,SG2.Dturb,'StateName',SG2.turb_x,'inputname',SG2.turb_u,'outputname',SG2.turb_y);

% Espacio de estados exciter
SG2.exc_x={'ex2_1', 'ex2_2'};
SG2.exc_u={'Vsg2_mag'};
SG2.exc_y={'vfd2'};
SG2.exc = ss(Aexc,Bexc,Cexc,Dexc,'StateName',SG2.exc_x,'inputname',SG2.exc_u,'outputname',SG2.exc_y);

% Espacio de estados |Vsg|
SG2.Avsg=[0];
SG2.Bvsg=[0 0];
SG2.Cvsg=[0];
SG2.Dvsg=[-vsg2q0/sqrt(vsg2q0^2+vsg2d0^2)/(Vsg*sqrt(2/3)) -vsg2d0/sqrt(vsg2q0^2+vsg2d0^2)/(Vsg*sqrt(2/3))];
SG2.vsg_x={''};
SG2.vsg_u={'v5q','v5d'};
SG2.vsg_y={'Vsg2_mag'};
SG2.vsg = ss(SG2.Avsg,SG2.Bvsg,SG2.Cvsg,SG2.Dvsg,'StateName',SG2.vsg_x,'inputname',SG2.vsg_u,'outputname',SG2.vsg_y);

% Espacio de estados generador síncrono
SG2.R7 = [ -SG2.Rs 0 0 0 0 0 0;
           0 -SG2.Rs 0 0 0 0 0;
           0 0 SG2.Rf_prime 0 0 0 0;
           0 0 0 SG2.Rkd 0 0 0; 
           0 0 0 0 SG2.Rkq1 0 0;
           0 0 0 0 0 SG2.Rkq2 0;
           0 0 0 0 0 0 0];
    
SG2.M7 = [-SG2.Ll-SG2.Lmq 0 0 0 SG2.Lmq SG2.Lmq 0; 
     0 -SG2.Ll-SG2.Lmd SG2.Lmd SG2.Lmd 0 0 0; 
     0 -SG2.Lmd SG2.Llfd_prime+SG2.Lmd SG2.Lmd 0 0 0;
     0 -SG2.Lmd SG2.Lmd SG2.Llkd+SG2.Lmd 0 0 0;
     -SG2.Lmq 0 0 0 SG2.Llkq2+SG2.Lmq SG2.Lmq 0;
     -SG2.Lmq 0 0 0 SG2.Lmq SG2.Llkq2+SG2.Lmq 0;
     0 0 0 0 0 0 SG2.J];

SG2.M7inv = inv(SG2.M7);

SG2.N7 = [0 -wg20*(SG2.Ll+SG2.Lmd) wg20*SG2.Lmd wg20*SG2.Lmd 0 0 (-SG2.Ll-SG2.Lmd)*isd20+SG2.Lmd*ifd20+SG2.Lmd*ikd20;
      wg20*(SG2.Ll+SG2.Lmq) 0 0 0 -wg20*SG2.Lmq -wg20*SG2.Lmq (SG2.Ll+SG2.Lmq)*isq20-SG2.Lmq*ik1q20-SG2.Lmq*ik2q20; 
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      0 0 0 0 0 0 0;
      3/2*(isd20*(SG2.Lmq-SG2.Lmd)+SG2.Lmd*ifd20+SG2.Lmd*ikd20) 3/2*(isq20*(SG2.Lmq-SG2.Lmd)-ik1q20*SG2.Lmq-SG2.Lmq*ik2q20) 3/2*isq20*SG2.Lmd 3/2*isq20*SG2.Lmd -3/2*isd20*SG2.Lmq -3/2*isd20*SG2.Lmq 0];

SG2.Asg = -SG2.M7inv*(SG2.N7+SG2.R7);
SG2.Bsg = SG2.M7inv;
SG2.Csg = eye(7);%;3/2*(isd20*(Lmq_pu-Lmd_pu)+Lmd_pu*ifd0+Lmd_pu*ikd0) 3/2*(isq0*(Lmq_pu-Lmd_pu)-ikq0*Lmq_pu) 3/2*isq0*Lmd_pu 3/2*isq0*Lmd_pu -3/2*isd0*Lmq_pu 0 0];
SG2.Dsg = zeros(7);

SG2.sg_x={'isq2x','isd2x','ifd2x','ikd2x','ik1q2','ik2q2','wg2xx'};
SG2.sg_u={'v5q2','v5d2','vfd2','vkd2','vk1q2','vk2q2','Tm2'};
SG2.sg_y={'is2q2','is2d2','ifd2','ikd2','ik1q2','ik2q2','w2'};
SG2.sg = ss(SG2.Asg,SG2.Bsg,SG2.Csg,SG2.Dsg,'StateName',SG2.sg_x,'inputname',SG2.sg_u,'outputname',SG2.sg_y);

% Espacio de estados diferencia de angulo SG2-SG1
Aesg2=[0];
Besg2=[1 -1];
Cesg2=[1];
Desg2=[0 0];

esg2_x={'Dw_xx'};
esg2_u={'w2','w1'};
esg2_y={'e_theta_sg2'};
esg2 = ss(Aesg2,Besg2,Cesg2,Desg2,'StateName',esg2_x,'inputname',esg2_u,'outputname',esg2_y);

% Espacio de estados transformada vg2_g1->vg2_g2
Avg2_g=[0];
Bvg2_g=[0 0 0];
Cvg2_g=[0;0];
Dvg2_g=[cos(e_theta_sg20) -sin(e_theta_sg20) -sin(e_theta_sg20)*vsg2q0-cos(e_theta_sg20)*vsg2d0;
      sin(e_theta_sg20) cos(e_theta_sg20) cos(e_theta_sg20)*vsg2q0-sin(e_theta_sg20)*vsg2d0];
vg2_g_x={'iicx1'};
vg2_g_u={'v5q','v5d','e_theta_sg2'};
vg2_g_y={'v5q2','v5d2'};
vg2_g = ss(Avg2_g,Bvg2_g,Cvg2_g,Dvg2_g,'StateName',vg2_g_x,'inputname',vg2_g_u,'outputname',vg2_g_y);

% Espacio de estados antitransformada isg2_g2->isg2_g1
Aig2_g=[0];
Big2_g=[0 0 0];
Cig2_g=[0;0];
Dig2_g=[cos(e_theta_sg20) sin(e_theta_sg20) -sin(e_theta_sg20)*isq20+cos(e_theta_sg20)*isd20;
      -sin(e_theta_sg20) cos(e_theta_sg20) -cos(e_theta_sg20)*isq20-sin(e_theta_sg20)*isd20];
ig2_g_x={''};
ig2_g_u={'is2q2','is2d2','e_theta_sg2'};
ig2_g_y={'isg2q','isg2d'};
ig2_g = ss(Aig2_g,Big2_g,Cig2_g,Dig2_g,'StateName',ig2_g_x,'inputname',ig2_g_u,'outputname',ig2_g_y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SSmodel_u={'Rd2','Rd3','Rd4','Rd5','Rd6','Rd7','Rd8','Rd9','Vac_ref','wref1','vkd1','vk1q1','vk2q1','wref2','vkd2','vk1q2','vk2q2'};
% SSmodel_y={'ic_q','ic_d','vpcc_q','vpcc_d','vsg1q','vsg1d','vsg2q','vsg2d','i2_q','i2_d','i3_q','i3_d','i4_q','i4_d','i5_q','i5_d','i6_q','i6_d','i7_q','i7_d','i8_q','i8_d','i9_q','i9_d','i10_q','i10_d','e_theta'};
% SS_model = connect(l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,d2,d3,d4,d5,d6,d7,d8,d9,ib2,ib3,ib4,ib5,ib6,ib7,ib8,ib9,icAC,eic,Pac,epac,pll,vc_v,i_ic,v_vc,padeq,paded,SG1.turb,SG1.exc,SG1.vsg,SG1.sg,SG2.turb,SG2.exc,SG2.vsg,SG2.sg,vg2_g,ig2_g,esg2,SSmodel_u,SSmodel_y);


SSmodel_y={'ic_q','ic_d','vpcc_q','vpcc_d','v6q','v6d','v5q','v5d','e_theta'};
SS_model = connect(SS_grid,icAC,eic,Pac,mpac,filtP,dfvsc,epac,Vac,evac,filtV,pll,vc_v,i_ic,v_vc,padeq,paded,SG1.turb,SG1.exc,SG1.vsg,SG1.sg,SG2.turb,SG2.exc,SG2.vsg,SG2.sg,vg2_g,ig2_g,esg2,SSmodel_u,SSmodel_y);


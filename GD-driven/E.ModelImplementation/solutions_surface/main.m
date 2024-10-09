
clear all; close all;clc;

%% plots settings
plot_poles = 0; % 1: plot pole diagram; 0: pole diagram is not display
cond_map = 1; %Initializion of figure (leaving = 1)

plot_datagen_3d= 0; % 1: plot sampled points during the data generation process in the 3-D space; 0: sampled points are not display
plot_datagen_2d= 0; % 1: plot sampled points during the data generation process in the 2-D space; 0: sampled points are not display

%%

SG1.Pn = 50e6; %SG1 rated power
SG2.Pn = 30e6; %SG2 rated power

Rdroop= 0.05; % VSC frequency droop characteristics

%% Select the objective function:
obj_fun='Min_P_SG'; 
%obj_fun='Min_P_losses';

%% Initial Exploration of the system's operable space
p_inp=xlsread('G:\Il Mio Drive\SSC-OPF\Controls\OPF carlos\Inputs_opf_nosmallsign.xlsx');

for jj=208%1:length(Pd_samples)

    Pload_tot= p_inp(jj,1)*100e6

    Pd20 = p_inp(jj,2)*Pload_tot;
    Pd30 = p_inp(jj,3)*Pload_tot;
    Pd40 = p_inp(jj,4)*Pload_tot;
    Pd50 = p_inp(jj,5)*Pload_tot;
    Pd60 = p_inp(jj,6)*Pload_tot;
    Pd70 = p_inp(jj,7)*Pload_tot;
    Pd80 = p_inp(jj,8)*Pload_tot;
    Pd90 = p_inp(jj,9)*Pload_tot;
    
    dat.Pd20=Pd20/100e6;
    dat.Pd30=Pd30/100e6;
    dat.Pd40=Pd40/100e6;
    dat.Pd50=Pd50/100e6;
    dat.Pd60=Pd60/100e6;
    dat.Pd70=Pd70/100e6;
    dat.Pd80=Pd80/100e6;
    dat.Pd90=Pd90/100e6;


    % SG1.P0 = a_sg(jj,1).*SG1.Pn;
    % 
    % SG2.P0 = a_sg(jj,2).*SG2.Pn;

    jj_samples=jj;

    run run_PF.m
   
end


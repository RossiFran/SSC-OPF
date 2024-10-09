
%% Solver
clear all; clc;

%% plots settings
plot_poles = 0; % 1: plot pole diagram; 0: pole diagram is not display
cond_map = 1; %Initializion of figure (leaving = 1)

%%

SG1.Pn = 50e6; %SG1 rated power
SG2.Pn = 30e6; %SG2 rated power

Pd_min=1; % Minimum total demand [p.u.]
Pd_max=3; % Maximum total demand [p.u.]

%% Sample random power demand 
n_samples= 100;

Pd_samples= rand(n_samples)*(Pd_max-Pd_min)+Pd_min;

isd=[10,15,20,10,5,10,5,25]; %loads intrinsic stress directions
delta_load=0.3; %consider +-30% deviation from conventional load.
isd_up=isd*(1+delta_load);
isd_lw=isd*(1-delta_load);

loads_stress_dir_0=lhsdesign(n_samples,8,'Criterion','maximin');
loads_stress_dir=(isd_up-isd_lw).*loads_stress_dir_0+isd_lw;

for csd=1:n_samples
    sum_loads_sd(csd,1)=sum(loads_stress_dir(csd,1:end));
    stress_dir(csd,:)=loads_stress_dir(csd,:)/sum_loads_sd(csd,1);
end

%% Sample random valued of the VSC frequency droop characteristics R

Rdroop_min=0.05;
Rdroop_max=0.1;
Rdroop_samples= rand(n_samples)*(Rdroop_max-Rdroop_min)+Rdroop_min;

%% Select the objective function:
obj_fun='Min_P_SG'; 
%obj_fun='Min_P_losses';

% initialize P_SG according to the objective function
if obj_fun == "Min_P_SG"
    
    SG1.P0 = 0.055*SG1.Pn; 
    SG2.P0 = 0.055*SG2.Pn;

elseif obj_fun == "Min_P_losses"
    
    SG1.P0 = 0.9*SG1.Pn;
    SG2.P0 = 0.9*SG2.Pn;
    
end

%% Calculate n_samples OPF

for jj=1:n_samples

    Pd_tot=Pd_samples(jj)*100e6;

    Pd20 = stress_dir(jj,1)*Pd_tot;
    Pd30 = stress_dir(jj,2)*Pd_tot;
    Pd40 = stress_dir(jj,3)*Pd_tot;
    Pd50 = stress_dir(jj,4)*Pd_tot;
    Pd60 = stress_dir(jj,5)*Pd_tot;
    Pd70 = stress_dir(jj,6)*Pd_tot;
    Pd80 = stress_dir(jj,7)*Pd_tot;
    Pd90 = stress_dir(jj,8)*Pd_tot;
    
    dat.Pd20=Pd20/100e6;
    dat.Pd30=Pd30/100e6;
    dat.Pd40=Pd40/100e6;
    dat.Pd50=Pd50/100e6;
    dat.Pd60=Pd60/100e6;
    dat.Pd70=Pd70/100e6;
    dat.Pd80=Pd80/100e6;
    dat.Pd90=Pd90/100e6;

    Rdroop=Rdroop_samples(jj);

    run run_OPF.m
    run Initial_values_OPF.m

    run Eqs_SS_model.m
    disp_modes = 1;
    run Small_signal_analysis.m

    % Damping Index
    DI(jj)=1-min(damping_ratio);
    real_parts_eig(jj,:)=real_lambda;
    imag_parts_eig(jj,:)=imag_lambda;
   
    
    if plot_poles == 1
        if  cond_map == 1
            h=figure('Position',[600 500 400 275]);
            cond_map =0;
        end
        run plot_pole_diagram.m
    end


    inputs(jj,:)=[Rdroop,sol(19),sol(21),sol(22),Pd_tot/100e6,Pd20/100e6,Pd30/100e6,Pd40/100e6,Pd50/100e6,Pd60/100e6,Pd70/100e6,Pd80/100e6,Pd90/100e6,DI(jj)];
    sol_vect(jj,:)=[sol(1:end-3),EXITFLAG,fval(jj)];
   
end

inputs_table=array2table(inputs,'VariableNames',{'Rdroop','VSC','SG2','SG1','PLTOT','PL2','PL3','PL4','PL5','PL6','PL7','PL8','PL9','DI'});

solutions_table=array2table(sol_vect,'VariableNames',{'V1','V2','V3','V4','V5','V6','V7','V8','V9','Theta1','Theta2','Theta3','Theta4','Theta5','Theta6','Theta7','Theta8','Theta9',...
    'P1','Q1','P5','P6','f','Exitflag','ObjFun'});

test_data=[inputs_table,solutions_table];
filename=(['Data Set ',obj_fun,'\test_data_OPF_',obj_fun,'.xlsx']);
writetable(test_data, filename);

real_eig_table=array2table(real_parts_eig);
filename=(['Data Set ',obj_fun,'\real_parts_eigenvalues_OPF_',obj_fun,'.xlsx']);
writetable(real_eig_table,filename);

imag_eig_table=array2table(imag_parts_eig);
filename=(['Data Set ',obj_fun,'\imag_parts_eigenvalues_OPF_',obj_fun,'.xlsx']);
writetable(imag_eig_table,filename);


comp_burn=array2table(comp_burn,'VariableNames',{'time','n_iter'});
filename=(['Data Set ',obj_fun,'\comp_burn_OPF_',obj_fun,'.xlsx']);
writetable(comp_burn,filename);

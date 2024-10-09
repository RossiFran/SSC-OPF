%% Solver
clear all; clc;

%% plots settings
plot_poles = 0; % 1: plot pole diagram; 0: pole diagram is not display
cond_map = 1; %Initializion of figure (leaving = 1)

%%

SG1.Pn = 50e6; %SG1 rated power
SG2.Pn = 30e6; %SG2 rated power

Rdroop= 0.05; % VSC frequency droop characteristics

Pd_min=1; % Minimum total demand [p.u.]
Pd_max=3; % Maximum total demand [p.u.]

%% Select the objective function:
%obj_fun='Min_P_SG'; 
obj_fun='Min_P_losses';

% initialize P_SG according to the objective function
if obj_fun == "Min_P_SG"
    
    SG1.P0 = 0.055*SG1.Pn; 
    SG2.P0 = 0.055*SG2.Pn;

elseif obj_fun == "Min_P_losses"
    
    SG1.P0 = 0.9*SG1.Pn;
    SG2.P0 = 0.9*SG2.Pn;
    
end

%% Load the trained regression models
constraint = fileread('..\D. Regression Training\MARS_expression_obj_fun.txt');
predict_DI = fileread('..\D. Regression Training\MARS_expression_DIpred.txt');

%% Sample random power demand or compute the same case of the Test Data Set

samples_choice='Test_Data_Set'; %' Test_Data_Set or new_random_samples

if samples_choice=="new_random_samples"
    n_samples= 100;
    
    Pd_samples= rand(n_samples,1)*(Pd_max-Pd_min)+Pd_min;
    
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

elseif samples_choice=="Test_Data_Set"
    
    results=xlsread(['../A. Data Generation/Test Data/Data Set ',obj_fun,'/Test_Data_OPF_',obj_fun,'.xlsx']);
    
    Pd_samples=results(:,5);

    stress_dir=results(:,6:13)./Pd_samples;

    n_samples= length(results);

end

%% Calculate n_samples SSC-OPF

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
                
    run run_SSCOPF.m
    run Initial_values_PF.m

    run Eqs_SS_model_2gen.m
    disp_modes = 1;
    run Small_signal_2gen.m

    % Exact Damping Index considering all the eigenvalues
    DI(jj)=1-min(damping_ratio);
    real_parts_eig(jj,:)=real_lambda;
    imag_parts_eig(jj,:)=imag_lambda;

    %Predicted critical eigenvalues' DI 
%    DI_pred(jj)=0.984008+max(0,0.416303-dat.Pd90)*0.0876049+max(0,sol(22)-0.303393)*(-0.157552)+max(0,0.303393-sol(22))*0.1994+max(0,theta(3,1)+0.0136921)*9.31738+max(0,-0.0136921-theta(3,1))*(-10.2568)+sol(21)*(-0.147466)+max(0,dat.Pd30-0.232119)*0.0679659+max(0,0.232119-dat.Pd30)*0.068344+max(0,0.150587-dat.Pd70)*0.167272+max(0,dat.Pd40-0.367371)*0.0147017+max(0,0.367371-dat.Pd40)*0.0605988+max(0,dat.Pd50-0.194075)*0.0216427+max(0,0.194075-dat.Pd50)*0.0864888;
    DI_pred(jj)=eval(predict_DI);

    if plot_poles == 1
        if  cond_map == 1
            h=figure('Position',[600 500 400 275]);
            cond_map =0;
        end
        run plot_pole_diagram.m
    end

    inputs(jj,:)=[Rdroop,sol(19),sol(21),sol(22),Pd_tot/100e6,Pd20/100e6,Pd30/100e6,Pd40/100e6,Pd50/100e6,Pd60/100e6,Pd70/100e6,Pd80/100e6,Pd90/100e6,DI(jj),DI_pred(jj)];
    sol_vect(jj,:)=[sol(1:end-3),EXITFLAG,fval(jj)];
                

end

inputs_table=array2table(inputs,'VariableNames',{'Rdroop','VSC','SG2','SG1','PLTOT','PL2','PL3','PL4','PL5','PL6','PL7','PL8','PL9','DI','DI_pred_criteig'});

solutions_table=array2table(sol_vect,'VariableNames',{'V1','V2','V3','V4','V5','V6','V7','V8','V9','Theta1','Theta2','Theta3','Theta4','Theta5','Theta6','Theta7','Theta8','Theta9',...
    'P1','Q1','P5','P6','f','Exitflag','ObjFun'});

results=[inputs_table,solutions_table];
filename=(['Results_',obj_fun,'\results_SSCOPF_',obj_fun,'.xlsx']);
writetable(results, filename);

real_eig_table=array2table(real_parts_eig);
filename=(['Results_',obj_fun,'\real_parts_eigenvalues_SSCOPF_',obj_fun,'.xlsx']);
writetable(real_eig_table,filename);

imag_eig_table=array2table(imag_parts_eig);
filename=(['Results_',obj_fun,'\imag_parts_eigenvalues_SSCOPF_',obj_fun,'.xlsx']);
writetable(imag_eig_table,filename);

comp_burn=array2table(comp_burn,'VariableNames',{'time','n_iter'});
filename=(['Results_',obj_fun,'\comp_burn_SSCOPF_',obj_fun,'.xlsx']);
writetable(comp_burn,filename);


%% 
% Run the python script Plot_results.py to plot the comparison between the OPF and SSC-OPF solutions

%%
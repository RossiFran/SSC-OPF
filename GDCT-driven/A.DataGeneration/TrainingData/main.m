clear all; close all;clc;

%% plots settings
plot_poles = 0; % 1: plot pole diagram; 0: pole diagram is not display
cond_map = 1; %Initializion of figure (leaving = 1)

plot_datagen_3d= 1; % 1: plot sampled points during the data generation process in the 3-D space; 0: sampled points are not display
plot_datagen_2d= 1; % 1: plot sampled points during the data generation process in the 2-D space; 0: sampled points are not display
save_plot_datagen = 1;% 1: save plot; 0: do not save the plot
%%

SG1.Pn = 50e6; %SG1 rated power
SG2.Pn = 30e6; %SG2 rated power

%% Initial Exploration of the system's operable space

n_reg=9; % number of sub-regions in which the oprable space is divided

nlhs=10; %number of samples generated by Latin Hypercube Sampling (in each region) 

run sampling_initial_exploration.m % opearting points sampling into the entire space, region by region

iter_num=1;
for jj=1:length(Pd_samples)

    Pd_tot=Pd_samples(jj);

    SG1.P0 = a_sg(jj,1).*SG1.Pn;

    SG2.P0 = a_sg(jj,2).*SG2.Pn;
    
    Rdroop= Rdroop_samples(jj);

    jj_samples=jj;
   
    run run_PF.m
    
    run Initial_values_PF.m

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
 

    inputs(jj,:)=[iter_num,sol(19),sol(21),sol(22),Pd_tot/100e6,Rdroop,Pd20/100e6,Pd30/100e6,Pd40/100e6,Pd50/100e6,Pd60/100e6,Pd70/100e6,Pd80/100e6,Pd90/100e6,DI(jj)];
    sol_vect(jj,:)=[sol,EXITFLAG];
       
    if plot_datagen_3d==1
        figure(1)
        if inputs(jj,15)>=1
            scatter3(Rdroop,(SG1.P0+SG2.P0)/100e6,dat.Pvsc,'r','filled')
        else
            scatter3(Rdroop,(SG1.P0+SG2.P0)/100e6,dat.Pvsc,'green','filled')
        end
        xlabel('R')
        ylabel('P_{SG}')
        zlabel('P_{IBR}')
        hold on
    end
    
    if plot_datagen_2d==1
        figure(2)
        if inputs(jj,15)>=1
            scatter((SG1.P0+SG2.P0)/100e6,dat.Pvsc,'r','filled')
        else
            scatter((SG1.P0+SG2.P0)/100e6,dat.Pvsc,'green','filled')
        end
        xlabel('P_{SG}')
        ylabel('P_{IBR}')    
        hold on
    end
end

%% Calculate Entropy of each subregion after initial space exploration

entropy_summary=zeros(n_reg,3); %initialize subregion's entropy equal to zero

i_reg=1;

for ss_ind=2:length(SG_grid)
    sg_min=SG_grid(ss_ind-1);
    sg_max=SG_grid(ss_ind);
    for vv=0:sqrt(n_reg)-1
        di_c=1;
        for ii=1:length(inputs)
%             pltot=inputs(ii,5);
            sg_sum=inputs(ii,3)+inputs(ii,4);
            if (sg_sum)>=sg_min && (sg_sum)<=sg_max
                 ibr_min=P_IBR_lim(sg_sum)+dibr*vv;
                 ibr_max=P_IBR_lim(sg_sum)+dibr*(vv+1);
                if inputs(ii,2)>=ibr_min && inputs(ii,2)<=ibr_max 
%                     reg(ii,1)=i_reg;
                    DI_reg(di_c,1)=inputs(ii,15);
                    DI_reg(di_c,2)=inputs(ii,6);
                    di_c=di_c+1;
                end
            end
        end    
        cs=1e-12;
        cu=1e-12;
        for dd=1:length(DI_reg)
           if DI_reg(dd,1)<1
                cs=cs+1;
            else
                cu=cu+1;
            end
        end
        cs=cs/length(DI_reg);
        cu=cu/length(DI_reg);
        entropy=-cs*log(cs)-cu*log(cu);
        entropy_summary(i_reg,1)=i_reg;
        entropy_summary(i_reg,2)=entropy;
        entropy_summary(i_reg,3)=di_c-1;
        i_reg=i_reg+1
        clear DI_reg
    end
end

n_reg_sm=0; %n_region in the stability margin (Entropy > 0)

for ii=1:length(entropy_summary)
    if entropy_summary(ii,2)>=1e-2
        n_reg_sm=n_reg_sm+1;
    end
end

%%

jj=jj+1;
excluded_reg=[];
iter_num=2;

while length(excluded_reg)<n_reg_sm
   nlhs2=20;
   
   if iter_num==2
        run sampling_second_iteration.m
   else
       run sampling_successive_iterations.m
   end

   for jj1=1:length(Pd_samples)

        Pd_tot=Pd_samples(jj1);
    
        SG1.P0 = a_sg(jj1,1).*SG1.Pn;
    
        SG2.P0 = a_sg(jj1,2).*SG2.Pn;
        
        Rdroop= Rdroop_samples(jj1);
    
        jj_samples= jj1;

        run run_PF.m
        run Initial_values_PF.m
    
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
 

        inputs(jj,:)=[iter_num,sol(19),sol(21),sol(22),Pd_tot/100e6,Rdroop,Pd20/100e6,Pd30/100e6,Pd40/100e6,Pd50/100e6,Pd60/100e6,Pd70/100e6,Pd80/100e6,Pd90/100e6,DI(jj)];
        sol_vect(jj,:)=[sol,EXITFLAG];
                    
        if plot_datagen_3d==1
            figure(1)
    
            if inputs(jj,15)>=1
                scatter3(Rdroop,(SG1.P0+SG2.P0)/100e6,dat.Pvsc,'r','filled','d','MarkerEdgeColor','k')
            else
                scatter3(Rdroop,(SG1.P0+SG2.P0)/100e6,dat.Pvsc,'d','filled','g','MarkerEdgeColor','k')
            end
            xlabel('R')
            ylabel('P_{SG}')
            zlabel('P_{IBR}')
            hold on
        end
        
        if plot_datagen_2d==1
            figure(2)
            if inputs(jj,15)>=1
                scatter((SG1.P0+SG2.P0)/100e6,dat.Pvsc,'r','filled','d','MarkerEdgeColor','k')
            else
                scatter((SG1.P0+SG2.P0)/100e6,dat.Pvsc,'green','filled','g','MarkerEdgeColor','k')
            end
            xlabel('P_{SG}')
            ylabel('P_{IBR}')
            hold on
        end
        
        jj=jj+1;
    end
        iter_num=iter_num+1;
        length(excluded_reg)

end

if plot_datagen_2d==1 && save_plot_datagen ==1
    
    saveas(gcf,'DataSet\Training_DataSet_GDCT_2D.png')
end

if plot_datagen_3d==1 && save_plot_datagen ==1
    
    saveas(gcf,'DataSet\Training_DataSet_GDCT_3D.png')
end

inputs_table=array2table(inputs,'VariableNames',{'Iter_num','VSC','SG2','SG1','PLTOT','Rdroop','PL2','PL3','PL4','PL5','PL6','PL7','PL8','PL9','DI'});

solutions_table=array2table(sol_vect,'VariableNames',{'V1','V2','V3','V4','V5','V6','V7','V8','V9','Theta1','Theta2','Theta3','Theta4','Theta5','Theta6','Theta7','Theta8','Theta9',...
    'P1','Q1','P5','P6','f','Exitflag'});

training_data=[inputs_table,solutions_table];
filename=(['DataSet\training_data_LHS',num2str(nlhs),'_',num2str(nlhs2),'_nreg',num2str(n_reg),'.xlsx']);
writetable(training_data, filename);

real_eig_table=array2table(real_parts_eig);
filename=(['DataSet\real_parts_eigenvalues_LHS',num2str(nlhs),'_',num2str(nlhs2),'_nreg',num2str(n_reg),'.xlsx']);
writetable(real_eig_table,filename);

imag_eig_table=array2table(imag_parts_eig);
filename=(['DataSet\imag_parts_eigenvalues_LHS',num2str(nlhs),'_',num2str(nlhs2),'_nreg',num2str(n_reg),'.xlsx']);
writetable(imag_eig_table,filename);

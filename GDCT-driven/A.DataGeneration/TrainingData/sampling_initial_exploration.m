%% Define upper and lower limits of the space dimensions P_SG, P_IBR, Rdroop

Pd_min=1; % Minimum total demand [p.u.]
Pd_max=3; % Maximum total demand [p.u.]

P_SG_min=0.05*(SG1.Pn+SG2.Pn)/100e6;
P_SG_max=0.95*(SG1.Pn+SG2.Pn)/100e6;

dsg=(-P_SG_min+P_SG_max)/sqrt(n_reg);
SG_grid=[P_SG_min:dsg:P_SG_max];

P_IBR_min=Pd_min-P_SG_min;
P_IBR_max=Pd_max-P_SG_min;
P_IBR_lim=@(x)(P_IBR_min+(P_SG_max-P_SG_min)/(P_IBR_min-Pd_min-P_SG_max)*(x-P_SG_min));

dibr=(P_IBR_max-P_IBR_min)/sqrt(n_reg);

Rdroop_min=0.05;
Rdroop_max=0.1;

%%

for ii_stab_marg=1:n_reg
        
    ss_next=ceil(ii_stab_marg/sqrt(n_reg));
    vv_next=ii_stab_marg-(ss_next-1)*sqrt(n_reg)-1;
    sampling_reg=ii_stab_marg;
    
    samples=lhsdesign(nlhs,3);
    
    P_SG_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1)=samples(:,1).*dsg+SG_grid(ss_next);

    P_IBR_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1)=P_IBR_lim(P_SG_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1))+dibr*(vv_next)+dibr*samples(:,2);
    
    Rdroop_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1)=(Rdroop_max-Rdroop_min)*samples(:,3)+Rdroop_min;
    
    Pd_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1)=(P_IBR_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1)+P_SG_samples(nlhs*(ii_stab_marg-1)+1:nlhs*ii_stab_marg,1))*100e6;
    
end

%%
% Share the quantity P_SG among the SGs in the grid. (a_sg(.,i): fraction of the
% total power P_SG to be injected by the i-th SG.

n_sg=2; %number of SGs
a_sg=zeros(length(P_SG_samples),n_sg);
Psg_max=[SG1.Pn SG2.Pn];

for kk=1:length(P_SG_samples)
    count_sg=0;
    Pd_res=P_SG_samples(kk,1)*100e6;
    I_sg=[1:n_sg];
   
    while count_sg<=n_sg
        if count_sg<n_sg && Pd_res>0
            flag1=1;
            ii=randi(length(I_sg));
            i_sg=I_sg(ii);
            I_sg_left=I_sg(1:ii-1);
            I_sg_right=I_sg(ii+1:end);
            I_sg=[I_sg_left I_sg_right];
            Psg_max_act=Psg_max(1,I_sg);
            a_isg_max=min(0.95,(Pd_res-0.05*sum(Psg_max_act(1,:)))/Psg_max(i_sg));
            a_isg=(a_isg_max-0.05)*rand(1)+0.05;
            Pd_res=Pd_res - a_isg*Psg_max(i_sg);
            count_sg=count_sg+1;
            a_sg(kk,i_sg)=a_isg;
        elseif count_sg==n_sg && Pd_res>0
            flag2=1;
            [a_isg,i_sg]=min(a_sg(kk,:));
            if Pd_res <= (0.95-a_isg)*Psg_max(i_sg)
                flag3=1;
                a_isg=a_isg+Pd_res/Psg_max(i_sg);
                a_sg(kk,i_sg)=a_isg;
                count_sg=count_sg+1;
            else
                flag4=1;
                delta_aisg=0.95-a_isg;
                a_isg=0.95;
                Pd_res=Pd_res-delta_aisg*Psg_max(i_sg);
                a_sg(kk,i_sg)=a_isg;
                if isempty(a_sg(1:i_sg-1))
                    [a_isg]=min(a_sg(kk,i_sg+1:end));
                    i_sg=find(a_sg(kk,:)==a_isg);
                elseif isempty(a_sg(kk,i_sg+1:end))
                    [a_isg]=min(a_sg(kk,1:i_sg-1));
                    i_sg=find(a_sg(kk,:)==a_isg);
                else
                    [a_isg]=min(a_sg(kk,1:i_sg-1),a_sg(kk,i_sg+1:end));
                    i_sg=find(a_sg(kk,:)==a_isg);
                end
                a_isg=a_isg+Pd_res/Psg_max(i_sg);
                a_sg(kk,i_sg)=a_isg;
                count_sg=count_sg+1;
            end
    
        end
    end
    clear flag1 flag2 flag3 flag4
end

%% Add the exteme values for each dimension

a_sg_bond=[0.05,0.05;0.05,0.95;0.95,0.95;0.95,0.05];
P_IBR_bond(1:4,1)=1-(a_sg_bond(:,1)*SG1.Pn/100e6+a_sg_bond(:,2)*SG2.Pn/100e6);
P_IBR_bond(5:8,1)=3-(a_sg_bond(:,1)*SG1.Pn/100e6+a_sg_bond(:,2)*SG2.Pn/100e6);
a_sg=[a_sg_bond;a_sg_bond;a_sg_bond;a_sg_bond;a_sg];
P_IBR_samples=[P_IBR_bond;P_IBR_bond;P_IBR_samples;];
Rdroop_samples=[Rdroop_min*ones(8,1);Rdroop_max*ones(8,1);Rdroop_samples];
Pd_samples=[ones(4,1)*1e8*Pd_min;ones(4,1)*1e8*Pd_max;ones(4,1)*1e8*Pd_min;ones(4,1)*1e8*Pd_max;Pd_samples];

%% Share Pd among the loads in the grid
isd=[10,15,20,10,5,10,5,25]; %loads intrinsic stress directions
delta_load=0.3; %consider +-30% deviation from conventional load.
isd_up=isd*(1+delta_load);
isd_lw=isd*(1-delta_load);

loads_stress_dir_0=lhsdesign(length(a_sg),8,'Criterion','maximin');
loads_stress_dir=(isd_up-isd_lw).*loads_stress_dir_0+isd_lw;

clear stress_dir

for csd=1:length(a_sg)
    sum_loads_sd(csd,1)=sum(loads_stress_dir(csd,1:end));
    stress_dir(csd,:)=loads_stress_dir(csd,:)/sum_loads_sd(csd,1);
end
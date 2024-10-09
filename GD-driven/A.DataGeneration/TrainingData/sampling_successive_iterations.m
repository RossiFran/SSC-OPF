%% Recalculate subregion's Entropy

P_SG_min_subreg=SG_grid(ss_next);
P_SG_max_subreg=SG_grid(ss_next+1);
di_c=1;
for ii=1:length(inputs)
    sg_sum=inputs(ii,3)+inputs(ii,4);
    if (sg_sum)>=P_SG_min_subreg && (sg_sum)<=P_SG_max_subreg
        P_IBR_min_subreg=P_IBR_lim(sg_sum)+dibr*vv_next;
        P_IBR_max_subreg=P_IBR_lim(sg_sum)+dibr*(vv_next+1);
        if inputs(ii,2)>=P_IBR_min_subreg && inputs(ii,2)<=P_IBR_max_subreg 
            DI_reg(di_c,1)=inputs(ii,14);
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

%% Calculate delta Entropy of the subregion, w.r.t. Entropy at previous iteration
delta_entr=entropy-entropy_summary(sampling_reg,2);

if delta_entr>0
    entropy_summary(sampling_reg,2)=entropy;
    entropy_summary(sampling_reg,3)=di_c-1;
else
    excluded_reg(length(excluded_reg)+1,1)=sampling_reg;
    entropy_summary(sampling_reg,2)=entropy;
    entropy_summary(sampling_reg,3)=di_c;

end

clear DI_reg

%% Select the subregion where sampling, i.e. the one with maximum entropy
    
entr_summ_sort=sortrows(entropy_summary,2,'descend');

ii_max_entr=0;
flag_excl=1;

while flag_excl==1
    ii_max_entr=ii_max_entr+1;
    flag_excl=ismember(entr_summ_sort(ii_max_entr,1),excluded_reg);
end

sampling_reg=entr_summ_sort(ii_max_entr,1);

%% Sampling
ss_next=ceil(sampling_reg/sqrt(n_reg));
vv_next=sampling_reg-(ss_next-1)*sqrt(n_reg)-1;

samples=lhsdesign(nlhs2,3);

P_SG_samples=samples(:,1).*dsg+SG_grid(ss_next);

P_IBR_samples=P_IBR_lim(P_SG_samples)+dibr*(vv_next)+dibr*samples(:,2);
    
Pd_samples=(P_IBR_samples+P_SG_samples)*100e6;

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

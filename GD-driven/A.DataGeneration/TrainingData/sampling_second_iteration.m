[max_entr, ii_max_entr]=max(entropy_summary(:,2));

ss_next=ceil(ii_max_entr/sqrt(n_reg));
vv_next=ii_max_entr-(ss_next-1)*sqrt(n_reg)-1;
sampling_reg=ii_max_entr;

samples=lhsdesign(nlhs2,2);

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

clear stress_dir loads_stress_dir

loads_stress_dir_0=lhsdesign(nlhs2,8,'Criterion','maximin');
loads_stress_dir=(isd_up-isd_lw).*loads_stress_dir_0+isd_lw;

for csd=1:nlhs2
    sum_loads_sd(csd,1)=sum(loads_stress_dir(csd,1:end));
    stress_dir(csd,:)=loads_stress_dir(csd,:)/sum_loads_sd(csd,1);
end

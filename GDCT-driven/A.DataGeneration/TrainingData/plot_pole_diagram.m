PF_min = 0.3;
color2=['r','m','g','c','b','k'];
figure(h)
hold on
for iiPF = 1:length(P)
    ii_imp = find(nPF(:,iiPF)>PF_min);   
    %Grid
    ii_ig = 0;
    %SG
    ii_is = 0;
    ii_wx = 0;
    ii_pmec = 0;
    ii_exc = 0;
    %VSC
    ii_ic = 0;
    ii_iq = 0;
    ii_id = 0;
    ii_Seic = 0;
    ii_pll = 0;
    ii_pade = 0;
    ii_vac = 0;
    ii_pac = 0;
    ii_grid = 0;
    
    for ind_imp=1:length(ii_imp)   
        if ['isq1x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['isd1x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ifd1x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ikd1x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ik1q1']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['ik2q1']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['isq2x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['isd2x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ifd2x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ikd2x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_id = 1;
        elseif ['ik1q2']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['ik2q2']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_is = 1;
            ii_iq = 1;
        elseif ['Pm_1x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pmec = 1;
        elseif ['wg1_x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_wx = 1;
        elseif ['ex1_1']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_exc = 1;
        elseif ['ex1_2']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_exc = 1;
        elseif ['Pm_2x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pmec = 1;
        elseif ['wg2_x']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_wx = 1;
        elseif ['ex2_1']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_exc = 1;
        elseif ['ex2_2']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_exc = 1;
        elseif ['Dw_xx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_wx = 1;
        %VSC    
        elseif ['ic_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ic = 1;
        elseif ['ic_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ic = 1;
        elseif ['Seicq']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_Seic = 1;
        elseif ['Seicd']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_Seic = 1;  
        elseif ['pllx1']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pll = 1; 
        elseif ['pllx2']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pll = 1;
        elseif ['padeq']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pade = 1;
        elseif ['paded']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pade = 1;
        elseif ['SVacx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_vac = 1;
        elseif ['filtV']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_vac = 1;
        elseif ['SPacx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pac = 1;
        elseif ['filtP']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_pac = 1;    
        %Grid    
        elseif ['i2_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i2_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i3_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i3_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i4_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i4_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i5_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i5_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i6_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i6_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i7_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i7_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i8_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i8_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i9_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i9_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        elseif ['i0_qx']==char(SS_model.StateName(ii_imp(ind_imp)))
            ii_ig = 1;
        elseif ['i0_dx']==char(SS_model.StateName(ii_imp(ind_imp)))
        ii_ig = 1;
        end
    end
    
    color = [0 0 0];
    ii_vsc = 0;

%Colores simples
    if ii_ic == 1 
        color = [0 0 1];
    end;
    if ii_ig == 1 
        color = [0.6 0.6 0.6];
    end
    if  ii_Seic==1 || ii_pll==1 || ii_pade==1 || ii_vac ==1 || ii_pac ==1
        color = [153 204 255]/255;
        ii_vsc = 1;
    end;
    if ii_is == 1 
        color = [1 0 0];
    end;
    if ii_exc == 1
        color = [0.9 0.9 0];
    end;   
    if  ii_wx == 1 || ii_pmec ==1
        color = [0 0.5 0];
    end;
    
    %Colores combinados
    if ii_ic == 1 && ii_vsc==1
        color = [0 0 102]/255;
    end;
    if ii_exc == 1 && ii_vsc==1
        color = [0.6 1 0.8];
    end;
    if ii_is ==1
        if ii_ic == 1
            color = [0.6 0.2 1];
        end;
        if ii_vsc ==1
            color = [1 0.4 1];
        end;
        if ii_vsc ==1 && ii_ic == 1
            color = [0.8 0.6 1];
        end;
        if ii_exc == 1
            color = [1 0.6 0.4];
            if ii_vsc ==1
            color = [0 0.75 0.75];
            end;
        end;
        if ii_wx == 1
            color = [0.6 0.6 0];
            if ii_vsc ==1
            color = [0.4 0.6 0];
            end;
        end;    
    end;

    hold on
    if jj1==1
        plot(real(P(iiPF))',imag(P(iiPF))','o','MarkerSize',7,'Color',color2(jpl),'MarkerFaceColor',color2(jpl));
    elseif jj1==2
        plot(real(P(iiPF))',imag(P(iiPF))','*','MarkerSize',7,'Color',color2(jpl),'MarkerFaceColor',color2(jpl));
    elseif jj1==3
        plot(real(P(iiPF))',imag(P(iiPF))','x','MarkerSize',7,'Color',color2(jpl),'MarkerFaceColor',color2(jpl));
    elseif jj1==4
        plot(real(P(iiPF))',imag(P(iiPF))','s','MarkerSize',7,'Color',color2(jpl),'MarkerFaceColor',color2(jpl));
    end
    
    %legend('Pd=100MW,PSG=0%','Pd=100MW,PSG=25%','Pd=100MW,PSG=50%',...
%         'Pd=100MW,PSG=100%','Pd=200MW,PSG=0%','Pd=200MW,PSG=25%','Pd=200MW,PSG=50%',...
%         'Pd=200MW,PSG=100%','Pd=300MW,PSG=0%','Pd=300MW,PSG=25%','Pd=300MW,PSG=50%','Pd=300MW,PSG=100%',...
%         'Pd=400MW,PSG=0%','Pd=400MW,PSG=25%','Pd=400MW,PSG=50%','Pd=400MW,PSG=100%',...
%         'Pd=500MW,PSG=0%','Pd=500MW,PSG=25%','Pd=500MW,PSG=50%','Pd=500MW,PSG=100%')
%         
            
end

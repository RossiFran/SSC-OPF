# -*- coding: utf-8 -*-
"""
Created on Sat Apr  6 11:16:05 2024

@author: Francesca
"""

import matplotlib.pyplot as plt
import pandas as pd
from math import pi
import numpy as np
from sklearn.metrics import mean_absolute_error
from matplotlib.gridspec import GridSpec
from matplotlib import gridspec
import matplotlib.pyplot as plt
from sklearn.metrics import r2_score

plt.rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Palatino"],
})

#%% Set Objective Fun.
obj_fun='Min_P_losses'#'Min_P_SG'#

#%% SG and VSC parameters

SG_p_min=0.05
SG_p_max=0.95
SG1_Pn=0.5
SG2_Pn=0.3

#%% Load SSC_OPF Results

df_real=pd.read_excel('./Results_'+obj_fun+'/real_parts_eigenvalues_SSCOPF_'+obj_fun+'.xlsx')
df_imag=pd.read_excel('./Results_'+obj_fun+'/imag_parts_eigenvalues_SSCOPF_'+obj_fun+'.xlsx')

n_cases= len(df_real)

crit_eig_real=np.zeros([n_cases,2])
crit_eig_imag=np.zeros([n_cases,2])

for ii in range(0,n_cases):
    im=df_imag.iloc[ii]
    im=pd.DataFrame(im.loc[im>350])
    im=im.T    
    re=df_real.iloc[ii][[col.replace('imag','real') for col in im.columns]]
    crit_eig_real[ii,0]=re.loc[re>=-120][0]
    crit_eig_imag[ii,0]=np.array(im[re.loc[re>=-120].index[0].replace('real','imag')])
    
    im=df_imag.iloc[ii]
    im=pd.DataFrame(im.loc[im<-350])
    im=im.T    
    re=df_real.iloc[ii][[col.replace('imag','real') for col in im.columns]]
    crit_eig_real[ii,1]=re.loc[re>=-120][0]
    crit_eig_imag[ii,1]=np.array(im[re.loc[re>=-120].index[0].replace('real','imag')])

res_sscopf=pd.read_excel('./Results_'+obj_fun+'/Results_SSCOPF_'+obj_fun+'.xlsx')
comp_sscopf=pd.read_excel('./Results_'+obj_fun+'/comp_burn_SSCOPF_'+obj_fun+'.xlsx')
comp_sscopf['PLTOT']=res_sscopf['PLTOT']
comp_sscopf=comp_sscopf.sort_values(by='PLTOT').reset_index(drop=True)

res_sscopf=res_sscopf.sort_values(by='PLTOT')
perc_VSC_sscopf=np.array(res_sscopf[['VSC']])/np.array(res_sscopf[['PLTOT']])*100
sgtot_sscopf=(np.array(res_sscopf[['SG1']])+np.array(res_sscopf[['SG2']])-SG_p_min*(SG1_Pn+SG2_Pn))/SG_p_max/(SG1_Pn+SG2_Pn)*100
obj_fun_val_sscopf=res_sscopf[['ObjFun']]*100

''' Exact DI of critical eigenvalues: '''
DI_Exact_crit_eig_SSCOPF=1-(-crit_eig_real[:,0]/np.sqrt(crit_eig_real[:,0]**2+crit_eig_imag[:,0]**2))
DI_Exact_crit_eig_SSCOPF=DI_Exact_crit_eig_SSCOPF[res_sscopf.index]

''' Preicted DI of critical eigenvalues: '''
DI_Pred_crit_eig_SSCOPF=res_sscopf['DI_pred_criteig'].reset_index(drop=True)

''' Exact DI of considering all the eigenvalues: '''
DI_SSCOPF=res_sscopf['DI'].reset_index(drop=True)

avg_obj_fun_sscopf=res_sscopf['ObjFun'].mean()*100
std_obj_fun_sscopf=res_sscopf['ObjFun'].std()*100

avg_DI_Exact_crit_eig_sscopf=DI_Exact_crit_eig_SSCOPF.mean()
std_DI_Exact_crit_eig_sscopf=DI_Exact_crit_eig_SSCOPF.std()

avg_N_iter_sscopf=comp_sscopf['n_iter'].mean()
std_N_iter_sscopf=comp_sscopf['n_iter'].std()

avg_comp_time_sscopf=comp_sscopf['time'].mean()
std_comp_time_sscopf=comp_sscopf['time'].std()

r2=r2_score(DI_Exact_crit_eig_SSCOPF,DI_Pred_crit_eig_SSCOPF)

#%% Load OPF Results

df_real=pd.read_excel('../A.DataGeneration/TestData/DataSet'+obj_fun+'/real_parts_eigenvalues_OPF_'+obj_fun+'.xlsx')
df_imag=pd.read_excel('../A.DataGeneration/TestData/DataSet'+obj_fun+'/imag_parts_eigenvalues_OPF_'+obj_fun+'.xlsx')

n_cases= len(df_real)

crit_eig_real=np.zeros([n_cases,2])
crit_eig_imag=np.zeros([n_cases,2])

for ii in range(0,n_cases):
    im=df_imag.iloc[ii]
    im=pd.DataFrame(im.loc[im>350])
    im=im.T    
    re=df_real.iloc[ii][[col.replace('imag','real') for col in im.columns]]
    crit_eig_real[ii,0]=re.loc[re>=-120][0]
    crit_eig_imag[ii,0]=np.array(im[re.loc[re>=-120].index[0].replace('real','imag')])
    
    im=df_imag.iloc[ii]
    im=pd.DataFrame(im.loc[im<-350])
    im=im.T    
    re=df_real.iloc[ii][[col.replace('imag','real') for col in im.columns]]
    crit_eig_real[ii,1]=re.loc[re>=-120][0]
    crit_eig_imag[ii,1]=np.array(im[re.loc[re>=-120].index[0].replace('real','imag')])

res_opf=pd.read_excel('../A.DataGeneration/TestData/DataSet'+obj_fun+'/Test_data_OPF_'+obj_fun+'.xlsx')
comp_opf=pd.read_excel('../A.DataGeneration/TestData/DataSet'+obj_fun+'/comp_burn_OPF_'+obj_fun+'.xlsx')
comp_opf['PLTOT']=res_opf['PLTOT']
comp_opf=comp_opf.sort_values(by='PLTOT').reset_index(drop=True)

res_opf=res_opf.sort_values(by='PLTOT')
perc_VSC_opf=np.array(res_opf[['VSC']])/np.array(res_opf[['PLTOT']])*100

sgtot_opf=(np.array(res_opf[['SG1']])+np.array(res_opf[['SG2']])-SG_p_min*(SG1_Pn+SG2_Pn))/SG_p_max/(SG1_Pn+SG2_Pn)*100
obj_fun_val_opf=res_opf[['ObjFun']]*100

''' Exact DI of critical eigenvalues: '''
DI_crit_eig_OPF=1-(-crit_eig_real[:,0]/np.sqrt(crit_eig_real[:,0]**2+crit_eig_imag[:,0]**2))
DI_crit_eig_OPF=DI_crit_eig_OPF[res_opf.index]

''' Exact DI of considering all the eigenvalues: '''
DI_SSCOPF=res_sscopf['DI'].reset_index(drop=True)

# avg_obj_fun_opf=sol_opf['ObjFun'].mean()*100
# std_obj_fun_opf=sol_opf['ObjFun'].std()*100

avg_obj_fun_opf=res_opf['ObjFun'].mean()*100
std_obj_fun_opf=res_opf['ObjFun'].std()*100

avg_DI_crit_eig_OPF=DI_crit_eig_OPF.mean()
std_DI_crit_eig_OPF=DI_crit_eig_OPF.std()

avg_N_iter_opf=comp_opf['n_iter'].mean()
std_N_iter_opf=comp_opf['n_iter'].std()

avg_comp_time_opf=comp_opf['time'].mean()
std_comp_time_opf=comp_opf['time'].std()

#%%
# print('GD-driven SSC-OPF with '+obj_fun+' Obj. Fun\nSummary of the results:\n')

# from tabulate import tabulate

# # Data for the table
# data = [
#     [obj_fun, "OPF", str(avg_obj_fun_opf)+" $\pm$ "+str(std_obj_fun_opf), str(avg_DI_crit_eig_OPF)+" $\pm$ "+str(std_DI_crit_eig_OPF), "", str(avg_N_iter_opf)+" $\pm$ "+str(std_N_iter_opf), str(avg_comp_time_opf)+ " $\pm$ "+str(std_comp_time_opf)],
#     ["", "GD-driven SSC-OPF", str(avg_obj_fun_sscopf)+" $\pm$ "+str(std_obj_fun_sscopf), str(avg_DI_Exact_crit_eig_sscopf)+" $\pm$ "+str(std_DI_Exact_crit_eig_sscopf), str(r2), str(avg_N_iter_sscopf)+" $\pm$ "+str(std_N_iter_sscopf), str(avg_comp_time_sscopf)+ " $\pm$ "+str(std_comp_time_sscopf)]
# ]

# # Column headers
# headers = ["", "", "Obj. Function [MW]", "DI", "$R^2$", "N. of iterations", "Computing time [s]"]

# # Print the table
# print(tabulate(data, headers, tablefmt="grid"))


#%%
if obj_fun=='Min_P_SG':
    
    fig = plt.figure(figsize=(8,7))
    gs_lower=GridSpec(3,1)
    
    ax = fig.add_subplot(gs_lower[0])
    ax1 = fig.add_subplot(gs_lower[1])
    ax.scatter(res_opf[['PLTOT']]*100,DI_crit_eig_OPF,c='r',linewidth=3, label='OPF')
    ax1.scatter(res_opf[['PLTOT']]*100,sgtot_opf,c='r',linewidth=5)#, linestyle='dotted')
   
    ax.plot(res_opf[['PLTOT']]*100,DI_Pred_crit_eig_SSCOPF,c='y',linewidth=2, linestyle='dotted', label='Predicted SSC-OPF DI')
    ax.scatter(res_opf[['PLTOT']]*100,DI_Exact_crit_eig_SSCOPF,c='g',linewidth=3, label='SSC-OPF')
    ax1.scatter(res_opf[['PLTOT']]*100,sgtot_sscopf,c='g',linewidth=3)
    
    ax.tick_params(axis='x', labelsize= 20)
    ax.tick_params(axis='y', labelsize= 20)
    ax.set_ylabel(r'$DI$',fontsize=20)
    ax.set_xlabel(r'$P_{D}$ [MW]',fontsize=20)
    ax.grid()
        
    ax1.tick_params(axis='x', labelsize= 20)
    ax1.tick_params(axis='y', labelsize= 20)
    ax1.set_xlabel(r'$P_{D}$ [MW]',fontsize=20)#,labelpad=20)#, loc='left')
    ax1.set_yticks([0,50,100])
    ax1.set_yticklabels(['$P_{SG,NR}^{min}$',' ','$P_{SG,NR}^{max}$'])
    ax1.grid()
    
    ax1_2=fig.add_subplot(gs_lower[2])
    ax1_2.scatter(res_opf[['PLTOT']]*100,comp_opf[['n_iter']],c='r',linewidth=3)
    ax1_2.scatter(res_opf[['PLTOT']]*100,comp_sscopf[['n_iter']],c='g',linewidth=3)
    ax1_2.tick_params(axis='x', labelsize= 20)
    ax1_2.tick_params(axis='y', labelsize= 20)
    ax1_2.set_xlabel(r'$P_{D} [MW]$',fontsize=20)#,labelpad=20)#, loc='left')
    ax1_2.set_ylabel(r'$N. of iter.$',fontsize=20, labelpad=15)
    ax1_2.grid()
        
    ax.set_title('GD-driven Case - min\{$P_{SG,NR}$\} problem', fontsize=20)
    
    fig.legend(loc='lower center', ncol=3, fontsize=18)
    fig.tight_layout()
    gs_lower.update(top=0.95,bottom=0.25,hspace=0.7)
        
elif obj_fun=='Min_P_losses':    

    fig = plt.figure(figsize=(8,11))
    gs_upper=GridSpec(4,1)
    
    ax2 = fig.add_subplot(gs_upper[0])
    ax3 = fig.add_subplot(gs_upper[1])
    ax4 = fig.add_subplot(gs_upper[2])
    ax1_2 = fig.add_subplot(gs_upper[3])
    
    ax2.scatter(res_opf[['PLTOT']]*100,DI_crit_eig_OPF,c='r',linewidth=4, label='OPF')
    ax3.scatter(res_opf[['PLTOT']]*100,obj_fun_val_opf,c='r',linewidth=4)
    ax4.scatter(res_opf[['PLTOT']]*100,sgtot_opf,c='r',linewidth=4)

    ax2.scatter(res_opf[['PLTOT']]*100,DI_Exact_crit_eig_SSCOPF,c='g',linewidth=3,label='SSC-OPF')
    ax2.plot(res_opf[['PLTOT']]*100,DI_Pred_crit_eig_SSCOPF,c='y',linewidth=2,linestyle='dotted',label='Predicted SSC-OPF DI')
    ax3.scatter(res_opf[['PLTOT']]*100,obj_fun_val_sscopf,c='g',linewidth=3)
    ax4.scatter(res_opf[['PLTOT']]*100,sgtot_sscopf,c='g',linewidth=3)
    
    ax2.tick_params(axis='x', labelsize= 20)
    ax2.tick_params(axis='y', labelsize= 20)
    ax2.set_ylabel(r'$DI$',fontsize=20)#, labelpad=20)
    ax2.set_xlabel(r'$P_{D}$ [MW]',fontsize=20)#,labelpad=20)#, loc='left')
    ax2.grid()

    ax3.tick_params(axis='x', labelsize= 20)
    ax3.tick_params(axis='y', labelsize= 20)
    ax3.set_ylabel(r'$P_{losses}$ [MW]',fontsize=20)#, labelpad=20)
    ax3.set_xlabel(r'$P_{D}$ [MW]',fontsize=20)#,labelpad=20)#, loc='left')
    ax3.grid()

    ax4.tick_params(axis='x', labelsize= 20)
    ax4.tick_params(axis='y', labelsize= 20)
    ax4.set_xlabel(r'$P_{D}$ [MW]',fontsize=20)#,labelpad=20)#, loc='left')
    ax4.set_yticks([80,95])
    ax4.set_ylim([80,98])
    ax4.set_yticklabels(['80\%','$P_{SG,NR}^{max}$'])
    ax4.grid()
    
    ax1_2.scatter(res_opf[['PLTOT']]*100,comp_opf[['n_iter']],c='r',linewidth=3)
    ax1_2.scatter(res_opf[['PLTOT']]*100,comp_sscopf[['n_iter']],c='g',linewidth=3)
    ax1_2.tick_params(axis='x', labelsize= 20)
    ax1_2.tick_params(axis='y', labelsize= 20)
    ax1_2.set_xlabel(r'$P_{D} [MW]$',fontsize=20)#,labelpad=20)#, loc='left')
    ax1_2.set_ylabel(r'$N. of iter.$',fontsize=20, labelpad=15)
    ax1_2.grid()

    ax2.set_title('GD-driven Case - min\{$P_{losses}$\} problem', fontsize=20)
    fig.legend(loc='lower center', ncol=3, fontsize=18)
    
    gs_upper.update(left=0.15,right=0.98,top=0.95,bottom=0.17,hspace=0.55)
    
plt.savefig('results_plot_'+obj_fun, format="pdf")

fig.savefig('results_plot_'+obj_fun+'.png')

#%%



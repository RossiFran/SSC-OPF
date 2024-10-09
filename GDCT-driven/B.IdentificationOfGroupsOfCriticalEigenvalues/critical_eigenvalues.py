import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

from sklearn.model_selection import train_test_split

#%% Load Trainig Data Set

df_real=pd.read_excel('../A. Data Generation/Training Data/Data Set/real_parts_eigenvalues_LHS10_20_nreg9.xlsx')
df_imag=pd.read_excel('../A. Data Generation/Training Data/Data Set/imag_parts_eigenvalues_LHS10_20_nreg9.xlsx')

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
    
#%%    
fig=plt.figure()
ax=fig.add_subplot()
ax.scatter(df_real,df_imag, label='Eigenvalues')
ax.scatter(crit_eig_real,crit_eig_imag, label='Critical Eigenvalues')
ax.set_xlabel('Real Axis',fontsize=25)
ax.set_ylabel('Imaginary Axis',fontsize=25)
ax.set_title('Complete Modal Map', fontsize=25)
ax.tick_params(labelsize=20)
ax.legend(loc='lower center',bbox_to_anchor=(0.45, -0.65),fontsize=15, ncol=2)
fig.tight_layout()
plt.grid()

fig.savefig('Training_Complete_Modal_Map.png')

fig=plt.figure()
ax=fig.add_subplot()
ax.scatter(df_real,df_imag, label='Eigenvalues')
ax.scatter(crit_eig_real,crit_eig_imag, label='Critical Eigenvalues')
ax.set_xlabel('Real Axis',fontsize=25)
ax.set_ylabel('Imaginary Axis',fontsize=25)
ax.set_title('Zoom', fontsize=25)
ax.tick_params(labelsize=20)
ax.set_xlim([-120,100])
ax.set_ylim([-650,650])
ax.legend(loc='lower center',bbox_to_anchor=(0.45, -0.65),fontsize=15, ncol=2)
fig.tight_layout()
plt.grid()

fig.savefig('Training_Zoom_on_critical_eigenvalues.png')


#%%

DI_crit_eig=1-(-crit_eig_real[:,0]/np.sqrt(crit_eig_real[:,0]**2+crit_eig_imag[:,0]**2))

inputs=pd.read_excel('../A. Data Generation/Training Data/Data Set/training_data_LHS10_20_nreg9.xlsx')
inputs['DI_crit']=DI_crit_eig
pd.DataFrame.to_csv(inputs,'Training_inputs_DI_crit_LHS10_20_nreg9.csv', index=False)

#%% Load Test Data Set

#obj_fun='Min_P_SG'
obj_fun='Min_P_losses'

df_real=pd.read_excel('../A. Data Generation/Test Data/Data Set '+obj_fun+'/real_parts_eigenvalues_OPF_'+obj_fun+'.xlsx')
df_imag=pd.read_excel('../A. Data Generation/Test Data/Data Set '+obj_fun+'/imag_parts_eigenvalues_OPF_'+obj_fun+'.xlsx')

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

#%%
fig=plt.figure()
ax=fig.add_subplot()
ax.scatter(df_real,df_imag, label='Eigenvalues')
ax.scatter(crit_eig_real,crit_eig_imag, label='Critical Eigenvalues')
ax.set_xlabel('Real Axis',fontsize=25)
ax.set_ylabel('Imaginary Axis',fontsize=25)
ax.set_title('Complete Modal Map', fontsize=25)
ax.tick_params(labelsize=20)
ax.legend(loc='lower center',bbox_to_anchor=(0.45, -0.65),fontsize=15, ncol=2)
fig.tight_layout()
plt.grid()

fig.savefig(obj_fun+'_Complete_Modal_Map.png')

fig=plt.figure()
ax=fig.add_subplot()
ax.scatter(df_real,df_imag, label='Eigenvalues')
ax.scatter(crit_eig_real,crit_eig_imag, label='Critical Eigenvalues')
ax.set_xlabel('Real Axis',fontsize=25)
ax.set_ylabel('Imaginary Axis',fontsize=25)
ax.set_title('Zoom', fontsize=25)
ax.tick_params(labelsize=20)
ax.set_xlim([-120,100])
ax.set_ylim([-650,650])
ax.legend(loc='lower center',bbox_to_anchor=(0.45, -0.65),fontsize=15, ncol=2)
fig.tight_layout()
plt.grid()

fig.savefig(obj_fun+'Zoom_on_critical_eigenvalues.png')

#%%
DI_crit_eig=1-(-crit_eig_real[:,0]/np.sqrt(crit_eig_real[:,0]**2+crit_eig_imag[:,0]**2))

inputs=pd.read_excel('../A. Data Generation/Test Data/Data Set '+obj_fun+'/test_data_OPF_'+obj_fun+'.xlsx')
inputs['DI_crit']=DI_crit_eig
pd.DataFrame.to_csv(inputs,'Test_data'+obj_fun+'_inputs_DI_crit.csv', index=False)

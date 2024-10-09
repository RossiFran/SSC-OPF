from pyearth import Earth
from pyearth import export
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import r2_score
from sklearn.linear_model import LinearRegression, Lasso, Ridge, ElasticNet

plt.rcParams.update({
    "text.usetex": True,
    "font.family": "serif",
    "font.serif": ["Palatino"],
})

# %% Load Training Data

Training_data = pd.read_csv(
    '../B.IdentificationOfGroupsOfCriticalEigenvalues/Training_inputs_DI_crit_LHS10_20_nreg9.csv').drop(
    ['Iter_num', 'DI', 'PLTOT','f', 'Exitflag'], axis=1)

# %% Remove correlated variables

corr_matrix = abs(Training_data.drop(['V1', 'Theta1'], axis=1).corr())
corr_matrix = corr_matrix.sort_values(by='DI_crit', ascending=False)
corr_matrix = corr_matrix.drop('DI_crit', axis=0)
uncorr_var = Training_data.drop(['V1', 'Theta1', 'DI_crit'], axis=1).columns

for var in corr_matrix.index:
    if var not in corr_matrix.index:
        continue
    corrs = corr_matrix[[var]].drop(var, axis=0)
    corrs_var = corrs.query('{var}>=0.9'.format(var=var)).index
    uncorr_var = list(set(uncorr_var) - set(corrs_var))
    corr_matrix = corr_matrix.drop(corrs_var, axis=0)

# %% Train MARS model

Xtrain = Training_data[uncorr_var]
ytrain = Training_data['DI_crit']
mars_model = Earth(feature_importance_type='gcv')  # smooth=False, max_degree=2)
mars_model.fit(Xtrain, ytrain)

mars_model_expression = export.export_sympy(mars_model)
mars_model_expression = str(mars_model_expression).replace('Max', 'max')
a_file = open('MARS_expression.txt', 'w')
a_file.write(mars_model_expression)
a_file.close()
print(export.export_sympy(mars_model))

#%%
# translate the expression to be used in matlab
#for the objective function
import re
var=mars_model.xlabels_
var_rename=list()
for ii in range(0,len(var)):
    if var[ii].startswith('PL'):
        var_rename.append('dat.Pd'+re.findall(r'\d+\.?\d*', var[ii])[0]+'0')
    elif var[ii].startswith('SG'):
        if re.findall(r'\d+\.?\d*', var[ii])[0] =='1':
            var_rename.append('P6')
        elif re.findall(r'\d+\.?\d*', var[ii])[0] =='2':
            var_rename.append('P5')
    elif var[ii].startswith('V'):
        var_rename.append('V('+re.findall(r'\d+\.?\d*', var[ii])[0]+',1)')
    elif var[ii].startswith('Theta'):
        var_rename.append('theta('+re.findall(r'\d+\.?\d*', var[ii])[0]+',1)')

for ii in range(0,len(var)):
    mars_model_expression=mars_model_expression.replace(var[ii],var_rename[ii])
a_file = open('MARS_expression_obj_fun.txt', 'w')
a_file.write(mars_model_expression)
a_file.close()
print(export.export_sympy(mars_model))

#evaluate predicted DI in matlab
import re
var=mars_model.xlabels_
var_rename=list()
for ii in range(0,len(var)):
    if var[ii].startswith('PL'):
        var_rename.append('dat.Pd'+re.findall(r'\d+\.?\d*', var[ii])[0]+'0')
    elif var[ii].startswith('SG'):
        if re.findall(r'\d+\.?\d*', var[ii])[0] =='1':
            var_rename.append('sol(22)')
        elif re.findall(r'\d+\.?\d*', var[ii])[0] =='2':
            var_rename.append('sol(21)')
    elif var[ii].startswith('V'):
        var_rename.append('V('+re.findall(r'\d+\.?\d*', var[ii])[0]+',1)')
    elif var[ii].startswith('Theta'):
        var_rename.append('theta('+re.findall(r'\d+\.?\d*', var[ii])[0]+',1)')

mars_model_expression = export.export_sympy(mars_model)
mars_model_expression = str(mars_model_expression).replace('Max', 'max')

for ii in range(0,len(var)):
    mars_model_expression=mars_model_expression.replace(var[ii],var_rename[ii])
a_file = open('MARS_expression_DIpred.txt', 'w')
a_file.write(mars_model_expression)
a_file.close()
print(export.export_sympy(mars_model))

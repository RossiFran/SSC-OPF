# Test Data Generation
This subfolder contains the code to generate data to test the accuracy of the regressions. A different data set is generated for each optimization problem, i.e. according to the Optimal Power Flow (OPF) objective function. In the case study, two cases are implemented: minimizing active power losses (*Min_P_losses*) and minimizing power injected by the synchronous generators (SGs) (*Min_P_SG*).

## Data and Usage
The *main.m* script implements the required steps by invoking the other scripts located in the folder. Next, the steps are described, along with the indication of the corresponding scripts where they are implemented.

In the *main.m* script:
1. Define the operable space to be explored.
2. Sample random values of power demand (i.e. the demand variables P of the OPF) by Latin Hypercube Sampling (LHS)
3. Select the OPF objective function
For each sampled point execute steps 4-5:
4. Calculate the OPF solution (in *run_OPF.m*)
5. Perform the Small-signal stability assessment of the OPF solution:
  * Obtain the equilibrium point of the system (in *Initial_values_OPF.m*)
  * Calculate the state-space linear model around the equilibrium point (in *Eqs_SS_model.m*)
  * Calculate the eigenvalues of the system state matrix (in *Small_signal_analysis.m*)
  * Store the results in the data base (DB) (in *main.m*): store the solution of the OPF, i.e. the demand variables (P: loads power), the control variables (U: generators power and converter controllers parameters), and the state variables (X: magnitude and phase of buses voltage), and the real and imaginary parts of the eigenvalues (λs).
  * Store information about the computing burden related to the OPF solution (in *main.m*): the computing time and the number of iterations required.
    
Save the results in Excel files, in the Data Set folder of the corresponding objective function:
* test_data_OPF_*obj_fun*.xlsx: collects values of the demand variables (P: loads power), the control variables (U: generators power), and the state variables (X: magnitude and phase of buses voltage) as calculated by PF for each sampled operating point.
* real_parts_eigenvalues_OPF_*obj_fun*.xlsx: collects the real parts of the eigenvalues calculated for each sampled operating point.
* imag_parts_eigenvalues_OPF_*obj_fun*.xlsx: collects the imaginary parts of the eigenvalues calculated for each sampled operating point.
* comp_burn_OPF_*obj_fun*.xlsx: collects the computing time and the number of iterations required to solve the OPF of each sampled operating point.

*obj_fun*: objective function.

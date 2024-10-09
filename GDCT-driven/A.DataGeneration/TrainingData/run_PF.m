
%% Run power flow analysis
run VSC_SGs_params.m
run PF_param

V1_0 = 1;
V2_0 = 1;
V3_0 = 1;
V4_0 = 1;
V5_0 = 1;
V6_0 = 1;
V7_0 = 1;
V8_0 = 1;
V9_0 = 1;
Theta1_0 = 0;
Theta2_0 = 0;
Theta3_0 = 0;
Theta4_0 = 0;
Theta5_0 = 0;
Theta6_0 = 0;
Theta7_0 = 0;
Theta8_0 = 0;
Theta9_0 = 0;
P6_0 = SG1.P0/100e6;
Q1_0 = 0;
Q5_0 = 0;
Q6_0 = 0;
P5_0 = SG2.P0/100e6;
f_0 = 50;
P1_0 = dat.Pvsc;

ifd_0 = 0;
vfd_0 = 0;

x0 = [V1_0 V2_0 V3_0 V4_0 V5_0 V6_0 V7_0 V8_0 V9_0...
    Theta1_0 Theta2_0 Theta3_0 Theta4_0 Theta5_0 Theta6_0 Theta7_0 Theta8_0 Theta9_0...
    P1_0 Q1_0 P5_0 P6_0 f_0];
    
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlincon = @(x)f_powerflow(x,dat);
fun = @(x)obj_fun(x);

options = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',10000,'Algorithm','interior-point','MaxIterations',10000,'FunctionTolerance',1e-12);

[sol,FVAL,EXITFLAG,OUTPUT] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlincon, options);

V = [sol(1:9)'];
theta = [sol(10:18)'];
f0 = sol(23); 

% Power flow calculation
results_branch = zeros(length(branch),6);
for ii = 1:length(branch)
    results_branch(ii,1:2)= branch(ii,1:2);
    Vi = V(branch(ii,1))*cos(theta(branch(ii,1)))+i*V(branch(ii,1))*sin(theta(branch(ii,1)));
    Vj = V(branch(ii,2))*cos(theta(branch(ii,2)))+i*V(branch(ii,2))*sin(theta(branch(ii,2)));
    R = branch(ii,3);
    X = branch(ii,4);
    B = branch(ii,5);
    S = Vi*conj((Vi-Vj)/((R+i*X)/Zb) + Vi*(i*B)*Zb);
    results_branch(ii,3:4)= [real(S),imag(S)];
    S = Vj*conj((Vj-Vi)/((R+i*X)/Zb) + Vj*(i*B)*Zb);
    results_branch(ii,5:6)= [real(S),imag(S)];
end

%External powers calculation

results_bus = zeros(length(V),2);
results_bus(:,1) = V;
results_bus(:,2) = theta;
for ii = 1:length(V)
    Vi = V(ii)*cos(theta(ii))+i*V(ii)*sin(theta(ii));
    Iij = Vi*dat.Yii(ii);
    [index,col]=find(branch(:,1:2)==ii);
    i_col = 1;
    for iii = index'
        if col(i_col) == 1
            ind = 2;
        else
            ind = 1;
        end
    i_col = i_col+1;
    Vj = V(branch(iii,ind))*cos(theta(branch(iii,ind)))+i*V(branch(iii,ind))*sin(theta(branch(iii,ind)));
    R = branch(iii,3);
    X = branch(iii,4);
    Iij = Iij+Vj/(-(R+i*X)/Zb);
    end
    
    S = Vi*conj(Iij);
    results_bus(ii,3:4)= [real(S),imag(S)];
end
% results_bus

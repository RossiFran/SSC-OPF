
%% Run power flow analysis
run VSC_SGs_params.m
run PF_param.m

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
Q5_0 = 0;

Q6_0 = 0;
f_0 = 50;
P1_0 = dat.Pvsc;

Pe1x_0=dat.Pvsc;
Pe5x_0=SG2.P0/100e6;
Pe6x_0=SG1.P0/100e6;

Rdroop_0=0.051;

x0 = [V1_0 V2_0 V3_0 V4_0 V5_0 V6_0 V7_0 V8_0 V9_0...
    Theta1_0 Theta2_0 Theta3_0 Theta4_0 Theta5_0 Theta6_0 Theta7_0 Theta8_0 Theta9_0...
    P1_0 Q1_0 P5_0 P6_0 f_0 Pe1x_0 Pe5x_0 Pe6x_0, Rdroop_0];
    
A = [];
b = [];
Aeq = [];
beq = [];

lb = [0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,-360,-360,-360,-360,-360,-360,-360,-360,-360,...
      -5,-5,0.05*SG2.Pn/100e6,0.05*SG1.Pn/100e6,50,-5,0.05*SG2.Pn/100e6,0.05*SG1.Pn/100e6, 0.05];
ub = [1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,360,360,360,360,360,360,360,360,360,...
     5,5,0.95*SG2.Pn/100e6,0.95*SG1.Pn/100e6,50,5,0.95*SG2.Pn/100e6,0.95*SG1.Pn/100e6, 0.1];

nonlincon = @(x)f_sscoptpowerflow(x,dat);

if obj_fun == "Min_P_SG"
    
    fun = @(x)Min_P_SG_penalty(x,dat,constraint);

elseif obj_fun == "Min_P_losses"
    
    fun = @(x)Min_P_losses_penalty(x,dat,branch,constraint);
    
end

options = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',50000,'Algorithm','interior-point','MaxIterations',20000,'FunctionTolerance',1e-6,'ConstraintTolerance',1e-5);

tic();
[X_pre,FVAL,EXITFLAG,OUTPUT] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlincon, options);
comp_burn(jj,1)=toc();
comp_burn(jj,2)=OUTPUT.iterations;

flag_vect(jj) = EXITFLAG;

sol = X_pre;

V = [sol(1:9)'];
theta = [sol(10:18)'];
f0 = sol(23); 
Rdroop=sol(27);
dat.kfd_vsc = Sn/(50*Rdroop);
kfd_vsc = Sn/(50*Rdroop);


if obj_fun == "Min_P_SG"
    
    fval(jj) = Min_P_SG_fval(sol);

elseif obj_fun == "Min_P_losses"
    
    fval(jj) = Min_P_losses_fval(sol,dat,branch);
    
end

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

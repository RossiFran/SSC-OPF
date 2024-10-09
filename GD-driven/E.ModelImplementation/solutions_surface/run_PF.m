
%% Run power flow analysis
run VSC_SG_2gen_param
run PF_param

m = 50;
Z = zeros(m);
Zdev = zeros(m);

P_SG1_min=0.05*SG1.Pn;
P_SG1_max=0.95*SG1.Pn;
P_SG2_min=0.05*SG2.Pn;
P_SG2_max=0.95*SG2.Pn;

SG1_range = linspace(P_SG1_min, P_SG1_max, m);
SG2_range = linspace(P_SG2_min, P_SG2_max, m);
for idx_Z_sg1 = [1:1:length(SG1_range)]
    SG1.P0 = SG1_range(idx_Z_sg1);

    for idx_Z_sg2 = [1:1:length(SG2_range)]
        SG2.P0 = SG2_range(idx_Z_sg2);

        dat.Psg1 = SG1.P0/100e6;
        dat.Psg2 = SG2.P0/100e6;
        dat.Pvsc = Pload_tot/100e6-dat.Psg1-dat.Psg2;
    
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
        fun = @(x)feasibility_obj_fun(x);
        
        options = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',10000,'Algorithm','interior-point','MaxIterations',10000,'FunctionTolerance',1e-12);
        
        [sol,FVAL,EXITFLAG,OUTPUT] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlincon, options);
        
        if obj_fun == "Min_P_SG"
    
            Fobj(idx_Z_sg2,idx_Z_sg1) = Min_P_SG_penalty(sol,dat);

        elseif obj_fun == "Min_P_losses"
    
            Fobj(idx_Z_sg2,idx_Z_sg1) = Min_P_losses_penalty(sol,dat,branch);
    
        end

    end
end

figure
surf(SG1_range/1e6,SG2_range/1e6,Fobj)
xlabel('Active Power SG1 [MW]')
%xticks([0, m/3, 2*m/3,m])
%xticklabels([0.025, (0.475-.025)/3 + .025, (0.475-.025)*2/3 + .025, 0.475])
ylabel('Active Power SG2 [MW]')
zlabel('Obj. Fun.')
glob_opt=min(min(Fobj));
[y_opt,x_opt]=find(Fobj==glob_opt);

SG2_opt=SG2_range(y_opt);
SG1_opt=SG1_range(x_opt);

hold on

scatter3(SG1_opt/1e6,SG2_opt/1e6,glob_opt,100,'filled','r')

%% Run SSC-OPF

% initialize P_SG according to the objective function
if obj_fun == "Min_P_SG"
    
    SG1.P0 = 0.055*SG1.Pn; 
    SG2.P0 = 0.055*SG2.Pn;

elseif obj_fun == "Min_P_losses"
    
    SG1.P0 = 0.9*SG1.Pn;
    SG2.P0 = 0.9*SG2.Pn;
    
end

dat.Psg1 = SG1.P0/100e6;
dat.Psg2 = SG2.P0/100e6;
dat.Pvsc = Pload_tot/100e6-dat.Psg1-dat.Psg2;

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

Pe1x_0=dat.Pvsc;
Pe5x_0=SG2.P0/100e6;
Pe6x_0=SG1.P0/100e6;


ifd_0 = 0;
vfd_0 = 0;

x0 = [V1_0 V2_0 V3_0 V4_0 V5_0 V6_0 V7_0 V8_0 V9_0...
    Theta1_0 Theta2_0 Theta3_0 Theta4_0 Theta5_0 Theta6_0 Theta7_0 Theta8_0 Theta9_0...
    P1_0 Q1_0 P5_0 P6_0 f_0 Pe1x_0 Pe5x_0 Pe6x_0];
    
A = [];
b = [];
Aeq = [];
beq = [];
lb = [0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,-360,-360,-360,-360,-360,-360,-360,-360,-360,...
      -5,-5,0.05*SG2.Pn/100e6,0.05*SG1.Pn/100e6,50,-5,0.05*SG2.Pn/100e6,0.05*SG1.Pn/100e6];
ub = [1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,1.1,360,360,360,360,360,360,360,360,360,...
     5,5,0.95*SG2.Pn/100e6,0.95*SG1.Pn/100e6,50,5,0.95*SG2.Pn/100e6,0.95*SG1.Pn/100e6];


nonlincon = @(x)f_sscoptpowerflow(x,dat);

if obj_fun == "Min_P_SG"
    
    fun = @(x)Min_P_SG_penalty(x,dat);

elseif obj_fun == "Min_P_losses"
    
    fun = @(x)Min_P_losses_penalty(x,dat,branch);
    
end

options = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',50000,'Algorithm','interior-point','MaxIterations',20000,'FunctionTolerance',1e-6,'ConstraintTolerance',1e-5);

[sol,FVAL,EXITFLAG,OUTPUT] = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, nonlincon, options);

SG2_sscopf=sol(21)*100;
SG1_sscopf=sol(22)*100;

if obj_fun == "Min_P_SG"
    
    sscopf_opt = Min_P_SG_penalty(sol,dat);

elseif obj_fun == "Min_P_losses"
    
    sscopf_opt = Min_P_losses_penalty(sol,dat,branch);
    
end


hold on

scatter3(SG1_sscopf,SG2_sscopf,sscopf_opt,50,'filled','b')

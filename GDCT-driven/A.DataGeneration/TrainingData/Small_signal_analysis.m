%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Small-signal model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[P,Z]=pzmap(SS_model);
%plot(real(P)',imag(P)','x','LineWidth',2,'Color',color(ii,:));%color1);

% Small-signal analysis
[RV,D] = eig(SS_model.a);  %RV: matriz de right eigenvectors (columnas)
                    %D: matriz diagonal de valores propios
LV=inv(RV);         %matriz de left eigenvectors (filas)
lambda = diag(D);    %vector columna de valores propios

% Parámetros de cada modo
omega = abs(imag(lambda)); %rad/s
freq = omega/(2*pi); %Hz
damping_ratio = -real(lambda)./abs(lambda);
real_lambda=real(lambda)';
imag_lambda=imag(lambda)';

% Factores de participación
PF=LV.'.*RV; %LV transpuesta, multiplicada por RV componente a componente
nPF=abs(PF*diag(1./max(abs(PF)))); %factores de participación normalizados (de cada columna, el más grande valdrá 1)
nPF2 = abs(PF);

nPF = (nPF>=0.001).*nPF;

if disp_modes == 1
    
    for ii_mat = 1:length(lambda)
        PFmatrix(1,ii_mat+5) = sprintf("Mode %d", ii_mat);
    end
    PFmatrix(1,1)='PLTOT';
    PFmatrix(1,2)='SG1';
    PFmatrix(1,3)='SG2';
    PFmatrix(1,4)='kd';
    PFmatrix(1,5)='var_name';
   
    PFmatrix = [PFmatrix;
                
                num2cell(Pd_tot/100e6*ones(length(nPF),1)) num2cell(SG1.P0/100e6*ones(length(nPF),1)) num2cell(SG2.P0/100e6*ones(length(nPF),1)) num2cell(Rdroop*ones(length(nPF),1)) SS_model.StateName num2cell(nPF);];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is used to calculate electromagnetic field for TM incidence based on RCWA 
% Dr. Zhuomin Zhang's group at Georgia Tech
% Last modified by Bo Zhao (September 2014)
% Last modified by Bo Zhao (September 2017)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RCWA for TM wave
%Multiyayer Grating

function [Ref,Tran]=RCWA_Multi_TM(N, e_m_x,e_m_y,e_m_z,ff, Period, d, e, lambda, theta, Num_ord)
% Output: Reflectance, Transmittance
% Input: N: layer number, 
%        e_m: permittivity of ridge region
%        e_d: permittivity of groove region
%        f1:  normalized position for left-end of metal strip
%        f2:  normalized position for right-end of metal strip
%        d:   thickness of each layer [um]
%        e:   permittivity of incident e(1) and substrate media e(2)
%        lambda: wavelength in [um]
%        theta: angle of incidence [rad]
%        Num_ord: number for the highest diffraction order

    ordMax = Num_ord;
    ordMin = -Num_ord;
    ordDif = ordMax-ordMin+1; %total order of Fourier component including 0th
    i = [ordMin:ordMax];      %-50 to 50

    % Matrix needed for calculation
    I = eye(ordDif);                % n-by-n identity matrix.
    Dirac_del = zeros(ordDif,1);    % matrix of zeros
    Dirac_del(1+Num_ord) = 1;       % 1 for 0th order

    k0 = 2*pi/lambda;               % wavevector in space
    kxi = k0*(sqrt(e(1))*sin(theta)+i*lambda/Period(1)); % Floquet condtion, kxi (1_by_i vector)
    
    for ind=1:N
        [Q{ind},V{ind},W{ind}] = Matrix_Gen_TM(e_m_x{ind},e_m_y{ind},e_m_z{ind}, ff{ind},Period(1), e(1), lambda, theta, Num_ord);
        X{ind} = diag(exp(-k0*d(ind)*eig(Q{ind})));
        O{ind}=[W{ind}, W{ind}; V{ind}, -V{ind}];
    end

    Kz1 = sqrt(e(1)*k0*k0-kxi.^2);
    Kz3 = sqrt(e(2)*k0*k0-kxi.^2);  
    
    %From here, we solove the matrix formulation
    % TM
    Yinc = diag(Kz1/k0/e(1));   %First medium: air (or dielectric)
    Ysub = diag(Kz3/k0/e(2));   %Last medium: substrate

    f{N+1}=I;
    g{N+1}=j*Ysub;
    for ind=N:-1:1
        Mat_ab=inv(O{ind})*[f{ind+1}; g{ind+1}];
        a{ind}=Mat_ab(1:ordDif,:);
        b{ind}=Mat_ab(ordDif+1:2*ordDif,:);
        f{ind}=W{ind}*(I+X{ind}*a{ind}*inv(b{ind})*X{ind});
        g{ind}=V{ind}*(-I+X{ind}*a{ind}*inv(b{ind})*X{ind});
    end
    T1=inv(j*Yinc*f{1}+g{1})*(j*Yinc*Dirac_del+j*sqrt(e(1))*cos(theta)*Dirac_del/e(1));
    R=f{1}*T1-Dirac_del;
    
    T=T1;
    for ind=1:N
        T=inv(b{ind})*X{ind}*T;
    end
        
    %TM
    DEr = R.*conj(R).*real(Kz1)'/(k0*sqrt(e(1))*cos(theta));
    DEt = T.*conj(T).*real((Kz3/e(2)))'/(k0*sqrt(e(1))*cos(theta)/e(1));

    Ref=sum(DEr);
    Tran=sum(DEt);
    

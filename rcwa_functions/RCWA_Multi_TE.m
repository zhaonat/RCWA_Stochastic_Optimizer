%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is used to calculate electromagnetic field for TM incidence based on RCWA 
% Dr. Zhuomin Zhang's group at Georgia Tech
% Last modified by Bo Zhao (September 2014)
% Last modified by Bo Zhao (September 2017)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RCWA for TE wave
%Multiyayer Grating

function [Ref,Tran]=RCWA_Multi_TE(N, e_m,ff, Period, d, e, lambda, theta, Num_ord)
                                  
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
    ordDif = ordMax-ordMin+1; %total order of diffraction including 0th
    i = [ordMin:ordMax];    %-40 to 40

    % Matrix needed for calculation
    I = eye(ordDif);
    Dirac_del=zeros(ordDif,1);
    Dirac_del(1+Num_ord)=1;

    k0 = 2*pi/lambda;
    kxi = k0*(sqrt(e(1))*sin(theta)+i*lambda/Period(1)); %kxi (1_by_i vector)
    
    for ind=1:N
        [Q{ind},V{ind},W{ind}]=Matrix_Gen_TE(e_m{ind},ff{ind},Period(ind), e(1), lambda, theta, Num_ord);
        X{ind} = diag(exp(-k0*d(ind)*eig(Q{ind})));
        O{ind}=[W{ind}, W{ind}; V{ind}, -V{ind}];
    end

    Kz1 = sqrt(e(1)*k0*k0-kxi.^2);
    Kz3 = sqrt(e(2)*k0*k0-kxi.^2);  
    
    %From here, we solve the matrix formulation
    % TE
    Yinc = diag(Kz1/k0);   %First medium: air (or dielectric)
    Ysub = diag(Kz3/k0);   %Last medium: substrate
    
    f{N+1}=I;
    g{N+1}=j*Ysub;
    for ind = N:-1:1
        Mat_ab = inv(O{ind})*[f{ind+1}; g{ind+1}];
        a{ind} = Mat_ab(1:ordDif,:);
        b{ind} = Mat_ab(ordDif+1:2*ordDif,:);
        f{ind} = W{ind}*(I+X{ind}*a{ind}*inv(b{ind})*X{ind});
        g{ind} = V{ind}*(-I+X{ind}*a{ind}*inv(b{ind})*X{ind});
    end
    T1 = inv(j*Yinc*f{1}+g{1})*(j*Yinc*Dirac_del+j*sqrt(e(1))*cos(theta)*Dirac_del);
    R = f{1}*T1-Dirac_del;
    
    T = T1;
    for ind = 1:N
        T = inv(b{ind})*X{ind}*T;
    end
        
    %TE
    DEr = R.*conj(R).*real(Kz1)'/(k0*sqrt(e(1))*cos(theta));
    DEt = T.*conj(T).*real(Kz3)'/(k0*sqrt(e(1))*cos(theta));
   
    Ref=sum(DEr);
    Tran=sum(DEt);
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is the main program of RCWA method to calculate the spectral directional radiative properties for TE and TM incidence 
% Dr. Zhuomin Zhang's group at Georgia Tech
% Last modified by Bo Zhao (September 2014)
% Last modified by Bo Zhao (September 2017)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;

e0=8.854187817e-12;
sheet_thickness = 0.34e-9;                  % units9 of meters
c0 = 299792458;                             % speed of light in space, [m/s]
theta =0;                                           % angle of incidence, [rad]
%wn = linspace(3500,25000,300) ; % wavenumber, [1/cm]
lambda_range =2:0.2:30;                           % wavelength, [um]
w = 1e6*2*pi*c0./lambda_range;            % angular frequency, [rad/s]
theta = 0;

num_layers = 4;
lattice_constant = 0.5;

%% specification of an individual
structure = layered_structure_class(num_layers, lattice_constant);
d  = cell2mat(structure.thickness_of_each_layer);
[f, periods] = structure.convert_to_RCWA();
N = length(d);                                   % # of layers
e = [1,1];
Num_ord = 25;                                  % number for the highest diffraction order
for i =1:length(lambda_range)  %um microns
    for k = 1:structure.num_layers
         if(structure.material_2d_bool(k)  == 1)
              %graphene
              slits = structure.layer_structure_specification{k};
              indicators = slits(1,:);
              for j = 1:length(indicators)
                  if(indicators(j) == 1)
                      tau = 5e-12;
                      Ef = 0.64;
                      [~, ~, sigma]= GraphenepropertiesBo(w(i),300,Ef,tau);
                      epsilon = 1+1i*(sigma/(w(i)*e0*0.34e-9));
                      e_m_x{k}(j) = epsilon; e_m_y{k}(j) = epsilon; e_m_z{k}(j) = epsilon;

                  else
                      e_m_x{k}(j) = 1+1e-12*1i; e_m_y{k}(j) =1+1e-12*1i; e_m_y{k}(j) = 1+1e-12*1i;
                  end
              end
          elseif(structure.material_2d_bool(k) == 2)
              %hBN
              [epsilonv, epsilonh]=hBNNEW(lambda_range(i));                    
              slits = structure.layer_structure_specification{k};
              indicators = slits(1,:);
              for j = 1:length(indicators)
                  if(indicators(j) == 1)
                     e_m_x{k}(j) = epsilonh;
                     e_m_y{k}(j) = epsilonh;
                     e_m_z{k}(j) = epsilonv;
                  else
                     e_m_x{k}(j) = 1+1e-12*1i; e_m_y{k}(j) =1+1e-12*1i; e_m_z{k}(j) = 1+1e-12*1i;
                  end
              end

          else
              %air
              e_m_x{k}(1) = 1+1e-12*1i; e_m_x{k}(2) = 1+1e-12*1i; %1 will lead to singularities
              e_m_y{k}(1) = 1+1e-12*1i; e_m_y{k}(2) = 1+1e-12*1i;
              e_m_z{k}(1) = 1+1e-12*1i; e_m_z{k}(2) = 1+1e-12*1i;
          end %exit material conditional
    end %exit layer loop
    
    [Ref(i), Tran(i)] = RCWA_Multi_TM(N, e_m_x,e_m_y,e_m_z,f, periods, d, e, ...
        lambda_range(i), theta, Num_ord); 
    disp(strcat('lambda=',num2str(lambda_range(i)),', R=', num2str(Ref(i)), ', T= ', num2str(Tran(i))));
end

%% evaluate the fitness HERE
absorption = 1-Ref-Tran;
figure()
plot(lambda_range, Tran)
hold on;
plot(lambda_range, Ref)
plot(lambda_range, absorption)
xlabel('wavelength (microns)')
ylabel('emittance (unitless)')
legend('trans', 'ref', 'aborption')
drawnow()







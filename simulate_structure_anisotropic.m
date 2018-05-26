
function [Ref, Tran] = simulate_structure_anisotropic(structure, lambda, theta,  Num_ord, e)
    e0=8.854187817e-12;
    c0 = 299792458;                             % speed of light in space, [m/s]
    %wn = linspace(3500,25000,300) ; % wavenumber, [1/cm]
    w = 1e6*2*pi*c0./lambda;            % angular frequency, [rad/s]

    %% start simulation
    d  = cell2mat(structure.thickness_of_each_layer);
    [f, periods] = structure.convert_to_RCWA();
    N = length(d);                                   % # of layers
    Ref = []; Tran = [];


    for i =1:length(lambda)  %um microns
        for k = 1:structure.num_layers
             if(strcmp(structure.materials_2D_list{k},'graphene'))
                  %graphene
                  slits = structure.layer_structure_specification{k};
                  indicators = slits(1,:);
                  for j = 1:length(indicators)
                      if(indicators(j) == 1)
                          tau = structure.layer_materials_properties{k}.tau;
                          Ef = structure.layer_materials_properties{k}.mu;
                          [~, ~, sigma]= GraphenepropertiesBo(w(i),300,Ef,tau);
                          epsilon = 1+1i*(sigma/(w(i)*e0*0.34e-9));
                          e_m_x{k}(j) = epsilon; e_m_y{k}(j) = epsilon; e_m_z{k}(j) = epsilon;

                      else
                          e_m_x{k}(j) = 1+1e-12*1i; e_m_y{k}(j) =1+1e-12*1i; e_m_y{k}(j) = 1+1e-12*1i;
                      end
                  end
              elseif(strcmp(structure.materials_2D_list{k},'hBN'))
                  %hBN
                  [epsilonv, epsilonh]=hBNNEW(lambda(i));                    
                  slits = structure.layer_structure_specification{k};
                  indicators = slits(1,:);
                  for j = 1:length(indicators)
                      if(indicators(j) == 1)
                         e_m_x{k}(j) = epsilonh;
                         e_m_y{k}(j) = epsilonh;
                         e_m_z{k}(j) = epsilonv;
                      else
                         e_m_x{k}(j) = 1+1e-12*1i; e_m_y{k}(j) =1+1e-12*1i; 
                         e_m_z{k}(j) = 1+1e-12*1i;
                      end
                  end

              else
                  %dielectric
                  eps = structure.layer_materials_properties{k};
                  e_m_x{k}(1) =  eps+1e-12*1i; e_m_x{k}(2) = eps+1e-12*1i; %1 will lead to singularities
                  e_m_y{k}(1) =  eps+1e-12*1i; e_m_y{k}(2) = eps+1e-12*1i;
                  e_m_z{k}(1) =  eps+1e-12*1i; e_m_z{k}(2) = eps+1e-12*1i;
              end %exit material conditional
        end %exit layer loop

        [Ref(i), Tran(i)] = RCWA_Multi_TM(N, e_m_x,e_m_y,e_m_z,f, periods, d, e, ...
            lambda(i), theta, Num_ord); 
        disp(strcat('lambda=',num2str(lambda(i)),', R=', num2str(Ref(i)), ', T= ', num2str(Tran(i))));
    end
    
end



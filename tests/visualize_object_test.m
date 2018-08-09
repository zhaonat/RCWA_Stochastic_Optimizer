
%% test the layered structure class and population
clear 
close all

num_layers = 2;
c0=3e8;
num_wavelengths = 400;
lambda_scan = linspace(1.5, 3, num_wavelengths);


w_scan = 2*pi*c0./lambda_scan*1e6;
omega_p = 1e15; %units of inverse seconds;
gamma = 5.513e12;
metal_gold = metal_dielectric(w_scan, omega_p, gamma);

dielectric_tensor_array = repmat(eye(3,3), 1,1,num_wavelengths);

metal_tensor_array =  construct_tensor_volume(metal_gold);

lattice_constant = 1;
silicon = 12*ones(1, num_wavelengths);
air = 1*ones(1, num_wavelengths);
glass = 3*ones(1, num_wavelengths);;

silicon = construct_tensor_volume(silicon);
air = construct_tensor_volume(air);
glass = construct_tensor_volume(glass);

layer1 = {silicon, air, silicon};
layer2 = {glass, air, glass};
layer3 = {12*dielectric_tensor_array,dielectric_tensor_array,...
    12*dielectric_tensor_array};

structure1 = {layer1, layer2};
structure2 = {layer2, layer1};

%requirement...always make each layer have a sum equal to lattice constant
scaling = 1/3;
layer_structure_specification = {scaling*[1,1,1], scaling*[1,1,1]};

layer_thicknesses = [1,2];
layer_dielectric_tensors = {layer3, layer3};

structure = layered_structure_class(num_layers, lattice_constant, ...
              layer_dielectric_tensors, layer_structure_specification, layer_thicknesses);

%since we specify the lambda_scan at the BEGINNING of the whole thing
%, we can have the structure store a frequency dependent tensor as a
%multidim array
          
% get rcwa spec
[f, periods] = convert_to_RCWA(structure);
          

%% simulate the structuret
Num_ord = 10;
theta = 0;
e = [1,1];
[Ref, Tran] = simulate_structure_anisotropic(structure, lambda_scan,...
    theta,  Num_ord, e);

figure();
plot(lambda_scan, Ref);
hold on; plot(lambda_scan, Tran);

%% visualize structure
visualize_structure(structure)





%% test the layered structure class and population
clear 
close all

num_layers = 2;
lattice_constant = 1;
silicon = 12*eye(3);
air = eye(3);
glass = 3*eye(3);
layer1 = {silicon, air, silicon};
layer2 = {glass, air, glass};

structure1 = {layer1, layer2};
structure2 = {layer2, layer1};

%requirement...always make each layer have a sum equal to lattice constant
scaling = 1/3;
layer_structure_specification = {scaling*[1,1,1], scaling*[1,1,1]};

layer_thicknesses = [1,2];
layer_dielectric_tensors = {layer1, layer2};

structure = layered_structure_class(num_layers, lattice_constant, ...
              layer_dielectric_tensors, layer_structure_specification, layer_thicknesses);

% get rcwa spec
[f, periods] = convert_to_RCWA(structure);
          

%% simulate the structuret
Num_ord = 10;
theta = 0;
lambda_scan = linspace(1.5, 3, 400);
e = [1,1];
[Ref, Tran] = simulate_structure_anisotropic(structure, lambda_scan,...
    theta,  Num_ord, e);

figure();
plot(lambda_scan, Ref);
hold on; plot(lambda_scan, Tran);

%% population test
num_individuals = 10;
num_layers_range = [2,2]; 
thickness_range = [0.5, 1];

layer_dielectric_tensor_distribution = {structure1, structure2};
layer_structure_distribution = {layer_structure_specification};

population = population_initializer(num_individuals,...
    lattice_constant, num_layers_range, thickness_range, ...
    layer_dielectric_tensor_distribution, layer_structure_distribution)


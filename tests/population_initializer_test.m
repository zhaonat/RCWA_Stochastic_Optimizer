
%% DEMONSTRATION of the population initializer


%% =======================================================================
% Specifications
L0 =1e-6;
num_individuals = 100;
lattice_constant = 1;
thickness_range = [0.5, 1]; %L0

%% =======================================================================
%% LAYER DIELECTRIC TENSOR DISTRIBUTION
layer1 = {silicon, silicon}; % NOTE EVEN IF A LAYER IS UNIFORM, NEED 2 specs
layer2 = {glass, glass};

dielectric_tensors_list = {layer1, layer2};
max_layers = 10;
min_layers = 4;
num_samples = 100;
layer_dielectric_tensor_distribution = generate_dielectric_layers(num_samples,min_layers, max_layers, dielectric_tensors_list);



%% =======================================================================
%% LAYER STRUCTURES
layer_structure_distribution = {scaling*[1,1]}; %% EVERYTHING IS UNIFORM;

%% =======================================================================
%% GENERATE THE POP
[population] = population_initializer(num_individuals,...
    lattice_constant, thickness_range, ...
    layer_dielectric_tensor_distribution, layer_structure_distribution)

%% CHECK THE POPULATION OUT
for i = 1:num_individuals
    population.immature_population{i}.layer_thicknesses
end
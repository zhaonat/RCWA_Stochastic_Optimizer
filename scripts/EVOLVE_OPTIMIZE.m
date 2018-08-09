clear 
close all

%% ==========================  USER SPECIFICATION BOX ===================%%

%% load distribution of structures and dielectric tensors you want here
% ideally, you want these somewhere else

silicon = 12*eye(3);
air = eye(3);
glass = 3*eye(3);

layer1 = {silicon, air, silicon};
layer2 = {glass, air, glass};

structure1 = {layer1, layer2};
structure2 = {layer2, layer1};

scaling = (1/3);
layer_structure_specification = {scaling*[1,1,1], scaling*[1,1,1]};

% for frequency dependent dielectric, the elements in each layer should be 
% be a function, not a tensor

%% specify parameters of the simulation
lattice_constant = 1; %microns
lambda_range = linspace(1.5, 2.5, 100); %also microns
num_ord = 10;
theta = 0; % angle of incidence
e = [1,1];

%% specify parameters of the population and the genetic evolution
num_individuals = 4; %always specify num_individuals to be divisible by 4
epochs = 100;
selection_rate = 0.8; %1 indicates only individuals from the top half are taken
perturbation = 0.5;
mutation_rate = 0.1;

%% initialize population
num_layers_range = [2,2]; 
thickness_range = [0.5, 1];
layer_dielectric_tensor_distribution = {structure1, structure2};
layer_structure_distribution = {layer_structure_specification};

population = population_initializer(num_individuals,...
    lattice_constant, num_layers_range, thickness_range, ...
    layer_dielectric_tensor_distribution, layer_structure_distribution);

%% specify and plot the desired spectra for (Reflection)
desired_reflection = abs(sin(linspace(-pi, pi, length(lambda_range))));
desired_reflection(50:90) = 1;
desired_reflection(1:50) = 0;
fig = figure();
plot(lambda_range, desired_reflection, 'linewidth', 2)
drawnow()
hold on;
%% =======================================================================%%
% beyond this point, the code should take care of itself


%% run epochs
best_individuals = cell(1);
fitness_history = [];

for t = 1:epochs
    disp(strcat('EPOCH: ', num2str(t)));
    
    % at every epoch, simulate the population
    immature_population = population.immature_population;
    mature_population = cell(1);
    
    %% ======================= fitness evaluation cell ===================%
    for i = 1:length(immature_population)
        % simulate each individual in the population (special function)
        individual = immature_population{i};
        [Ref, Tran] = simulate_structure_anisotropic(individual, ...
        lambda_range, theta, num_ord, e);
        %convert Reflection and Transmission to a fitness
        individual.Fitness = evaluate_fitness(Ref, desired_reflection);
        
        %add individual to mature section
        mature_population{i} = individual; 
        disp(strcat('Individual #',num2str(i), ' simulated'));
    end
    plot(lambda_range, Ref);drawnow();
    %once we are done, we should delete the immature population to make it
    %ready accept the next generation
    population.immature_population = cell(1);
    
    % remember, we want to APPEND the new individuals simulated
    population.mature_population = ...
        [population.mature_population; mature_population.'];
    
    %% ===================== selection cell =============================%%
    % now that every individual has a fitness, perform selection
    [reduced_population, max_individual, fitnesses] = ...
        selection(population.mature_population, selection_rate);
    best_individuals{t} = max_individual;
    fitness_history= [fitness_history; mean(fitnesses), max(fitnesses)]
    % after selection, perform mating
    
    population.mature_population = reduced_population.';
    
    %% ================== mating cell ===================================%%
    offspring = mate_population(population.mature_population);
    
    %% ================== mutation cell ================================%%
    %mutated_offspring = mutate_group(offspring, perturbation, mutation_rate);
    
    %% ==============add the new offspring to the population =============%%
    population.immature_population = offspring;

    % perform mutations on the matured population and ADD them to the
    % immature (MAYBE, this isn't representative of reproductive mutation)
    
    disp(strcat('best_fitness at epoch #', num2str(t), ': ',' ',  ...
        num2str(max_individual.Fitness)));
    disp(strcat('pop_mature: ', num2str(length(population.mature_population)), ...
        ' pop_immature: ', num2str(length(population.immature_population))));
    
end
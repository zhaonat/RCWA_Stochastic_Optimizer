
%% generate dielectric distributions

num_layers = 2;
c0=3e8;
num_wavelengths = 400;
lambda_scan = linspace(1.5, 3, num_wavelengths);
w_scan = 2*pi*c0./lambda_scan*1e6;

lattice_constant = 1;

%% =================== construct tensor volumes =========================%%
silicon = 12*ones(1, num_wavelengths);
air = 1*ones(1, num_wavelengths);
glass = 3*ones(1, num_wavelengths);;

silicon = construct_tensor_volume(silicon);
air = construct_tensor_volume(air);
glass = construct_tensor_volume(glass);


% need to create a layer repository
layer1 = {silicon, silicon}; % NOTE EVEN IF A LAYER IS UNIFORM, NEED 2 specs
layer2 = {glass, glass};

structure1 = {layer1, layer2}; %stack of layers
structure2 = {layer2, layer1};

%% structure specs
scaling = 1/2;
layer_structure_specification = {scaling*[1,1], scaling*[1,1]};

% for frequency dependent dielectric, the elements in each layer should be 
% be a function, not a tensor

%% specify parameters of the simulation
lattice_constant = 1; %microns
lambda_range = linspace(1.0, 2.5, 100); %also microns
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
desired_reflection(75:90) = 1;
desired_reflection(1:75) = 0;
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


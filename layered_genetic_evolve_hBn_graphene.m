clear 
close all

%% specify parameters of the simulation
lattice_constant = 0.5; %microns
lambda_range = 5:0.1:15; %also microns
num_ord = 10;
theta = 0; % angle of incidence

%% specify parameters of the population and the genetic evolution
num_individuals = 4; %always specify num_individuals to be divisible by 4
num_layers = 20;
material_proportions = [0.1, 0.9, 0];
population = population_class_anisotropic(num_individuals);
population = population.initialize_population(num_layers, lattice_constant, material_proportions);
epochs = 100;
selection_rate = 0.8; %1 indicates only individuals from the top half are taken
perturbation = 0.5;
mutation_rate = 0.1;

%% specify and plot the desired spectra for (Reflection)
desired_reflection = abs(sin(linspace(-pi, pi, length(lambda_range))));
desired_reflection(50:90) = 1;
desired_reflection(1:50) = 0;
fig = figure();
plot(lambda_range, desired_reflection, 'linewidth', 2)
drawnow()
hold on;

%% run epochs
best_individuals = cell(1);
fitness_history = [];

for t = 1:epochs
    disp(strcat('EPOCH: ', num2str(t)));
    
    % at every epoch, simulate the population
    immature_population = population.immature_population;
    mature_population = cell(1);
    
    parfor i = 1:length(immature_population)
        % simulate each individual in the population (special function)
        individual = immature_population{i};
        [Ref, Tran] = simulate_structure_anisotropic(individual, lambda_range, theta, num_ord);
        
        %put the Reflection and Transmission spectra into each individual
        individual.Ref = Ref;
        individual.Tran = Tran;
%         plot(Ref); hold on;
%         plot(Tran)
        %convert Reflection and Transmission to a fitness
        individual.Fitness = evaluate_fitness(Ref, desired_reflection);
        
        %add individual to mature section
        mature_population{i} = individual; 
        disp(strcat('Individual #',num2str(i), ' simulated'));
    end

    %once we are done, we should delete the immature population to make it
    %ready accept the next generation
    population.immature_population = cell(1);
    
    % remember, we want to APPEND the new individuals simulated
    population.mature_population = ...
        [population.mature_population; mature_population.'];
    
    % now that every individual has a fitness, perform selection
    [reduced_population, max_individual, fitnesses] = ...
        selection(population.mature_population, selection_rate);
    best_individuals{t} = max_individual;
    fitness_history= [fitness_history; mean(fitnesses), max(fitnesses)]
    % after selection, perform mating
    
    plot(lambda_range, max_individual.Ref);
    drawnow()
    savefig(fig, 'spectra_match.fig');
    %visualize_structure(max_individual);
    population.mature_population = reduced_population.';
    
    offspring = mate_population(population.mature_population);
    % add all the offspring to the offspring
    
    % after mating, perform mutations on the offspring in the immature
    % section
    mutated_offspring = mutate_group(offspring, perturbation, mutation_rate);
    
    population.immature_population = mutated_offspring;

    % perform mutations on the matured population and ADD them to the
    % immature (MAYBE, this isn't representative of reproductive mutation)
    
    disp(strcat('best_fitness at epoch #', num2str(t), ': ',' ',  ...
        num2str(max_individual.Fitness)));
    disp(strcat('pop_mature: ', num2str(length(population.mature_population)), ...
        ' pop_immature: ', num2str(length(population.immature_population))));
    
end
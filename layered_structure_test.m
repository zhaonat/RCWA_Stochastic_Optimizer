num_layers = 4;
lattice_constant = 0.8;
material_fractions = [0.1, 0.5, 0.4];
structures = layered_structure_class();
structures = structures.initialize_random_structure(num_layers, ...
    lattice_constant, material_fractions);
lambda_range = 5:0.2:15;

visualize_structure(structures)

% test mutations
perturbation = 0.5; mutation_rate = 1;
mutant = mutate_individual_2D_pattern(structures, perturbation, mutation_rate);
visualize_structure(mutant)
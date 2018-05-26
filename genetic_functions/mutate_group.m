function mutated_population = mutate_group(population, perturbation, mutation_rate)
    %MUTATE_GROUP Summary of this function goes here
    %   Detailed explanation goes here
     mutated_population = [];
     l = length(population);

     for i = 1:l
        individual = population{i}; 
        mutant = mutate_individual_2D_pattern(individual, perturbation, mutation_rate);
        mutated_population{i} = mutant;
     end
    

end


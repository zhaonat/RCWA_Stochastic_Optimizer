function mutated_population = mutate_population(population, mutation_rate)
    %MUTATE_GROUP Summary of this function goes here
    %   Detailed explanation goes here
    % mutation_rate: proportion of individuals to mutate
    % perturbation = strength of the mutation (how drastic is the change)
     mutated_population = [];
     l = length(population);
        
     for i = 1:l
        structure = population{i}; 
        
        if(rand() < mutation_rate)
            %% ======== insert your mutation function right here ============
            perturbation = 0.01;
            mutant = mutate_layer_thicknesses(structure, perturbation); % mutant = individual does nothing

            %% ===============================================================
        else
            mutant = structure; % mutant = individual does nothing
        end
        mutated_population{i} = mutant;
     end
    

end


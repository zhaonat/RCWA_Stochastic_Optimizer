
function optimized_individuals = line_search_individual(layered_structure_instance, ...
    lambda_scan, theta, num_ord, e, desired_reflection)
    
    %probe slight variations of the thickness, if it improves upont the
    %fitness, add the 
    max_optimized_individuals = 5;
    optimized_individuals = cell(1);
    num_searches = 20;
    c = 1;
    for i = 1:length(layered_structure_instance.num_layers)
        original_thickness = layered_structure_instance.layer_thicknesses(i);
        alpha = 0.5;
        deviation = original_thickness*alpha;
        original_fitness = layered_structure_instance.Fitness
        for delta = linspace(-deviation, deviation, num_searches)
            structure_copy = layered_structure_instance;
            structure_copy.layer_thicknesses(i) = original_thickness+delta;
            [Ref, ~] = simulate_structure_anisotropic(structure_copy, ...
                lambda_scan, theta, num_ord, e);
            fitness = evaluate_fitness(Ref, desired_reflection)
            if(fitness>original_fitness)
                optimized_individuals{c} = structure_copy;
                c = c+1;
            end
            
        end
        if(c> max_optimized_individuals)
           break; 
        end
        
    end

end
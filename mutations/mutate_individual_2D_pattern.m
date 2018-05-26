
% ====================MUTATION DESCRIPTION ===========================%
% only modulate the grating pattern on the graphene slab
% layers
% ==================================================================%
function mutant = mutate_individual_2D_pattern(structure, perturbation, mutation_rate)
    mutant = structure;
    indicator = structure.material_2d_bool; %will change when we add hbn;
    layers = mutant.layer_structure_specification; %(2xN) matrix
    
    for i = 1:length(layers)
        p = rand();
        if(p < mutation_rate && indicator(i) > 0)
           sign = 2*randi([0,1], 1)-1;
           grating = layers{i};
           mutation_size = grating(2,2)*perturbation;
           grating(2,1) = grating(2,1) -sign*mutation_size/2;
           grating(2,2) = grating(2,2)+ sign*mutation_size;
           grating(2,3) = grating(2,3) - mutation_size/2;
           mutant.layer_structure_specification{i} = grating;
        end
    end
    
end
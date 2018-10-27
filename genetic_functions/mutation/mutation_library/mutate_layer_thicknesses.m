
function mutant = mutate_layer_thicknesses(structure, perturbation)
    
    assert(abs(perturbation) < 1, 'perturbation must be less than 1')
    mutant = structure;
    mutant.layer_thicknesses = mutant.layer_thicknesses*(1+perturbation);

end
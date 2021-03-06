
% function which mixes layers

function [child1, child2] = mix_layer_thicknesses(structure1, structure2)
    
    %% assert that structure 1 and structure 2 always have same number of layers
    assert(length(structure1.layer_thicknesses) == length(structure.layer_thicknesses), ...
        'input parents do not have same number of layers');

    %% characteristics of parent1
    ls1 = structure1.layer_structures;
    lt1 = structure1.layer_thicknesses;
    ldt1 = structure1.layer_dielectric_tensors; %specifies dielectric tensor for each layer
  
    %% characteristics of parent 2
    ls2 = structure2.layer_structures;
    lt2 = structure2.layer_thicknesses;
    ldt2 = structure2.layer_dielectric_tensors;
    
    %% split generator, of where to cut the structure in half
    l1 = length(ls1); l2 = length(ls2);
    
    %% generate splits so that the split is never the first layer or the last layer
    split1 = randi([1+1, l1-1],1);
    split2 = split1; % this enforces that the number of layers never changes
    
    % split the layer structure, which is the grating
    %[ls3, ls4] = partition_cell(ls1, ls2, split1, split2);
    %partition thicknesses
    
    [lt3, lt4] = partition_array(lt1, lt2, split1, split2);
    
    % partition dielectric tensors
    %[ldt3, ldt4] = partition_cell(ldt1, ldt2, split1, split2);
    
    lattice_constant = structure1.lattice_constant;
    num_layers1 = length(ls3);
    num_layers2 = length(ls4);
    child1 = layered_structure_class(num_layers1, lattice_constant, ...
              ldt1, ls1, lt3);
    child2 = layered_structure_class(num_layers2, lattice_constant, ...
              ldt2, ls2, lt4);
    
end
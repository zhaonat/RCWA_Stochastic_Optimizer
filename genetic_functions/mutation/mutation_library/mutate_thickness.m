
%% ================================================================
%function which takes an individual structure class and goes through generating
%random changes in the thicknesses
%% ================================================================

function structure = mutate_thickness(structure)
    
    %% inputs
    % structure: this is a layered_structure class instance
    % perturbations trength: number from 0 to 1 indicating how strong or
    % weak the perburation 0 = no perturbation, 1 = strong

    thicknesses = structure.layer_thicknesses;
    
    %iterate through each layer
    for i = 1:length(thicknesses)
        %generate pertrubation
        perturbation = rand()*thicknesses(i)
        new_thickness = thicknesses(i)+perturbation;
        structure.layer_thicknesses(i) = new_thickness;
        
    end
end
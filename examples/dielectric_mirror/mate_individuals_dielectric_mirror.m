
% ====================MATING DESCRIPTION ===========================%
% our first try will be very simple: we will only recombine layers
% ==================================================================%

function children = mate_individuals_dielectric_mirror(structure1, structure2)

    child1 = structure1;
    child2 = structure2;
    children = {child1, child2};
    
%       layer_structures = cell(1); %specifies grating of each structure
%       layer_thicknesses = cell(1);
    
    
    %% every reproduction method selects to mix the two parents
    % characteristics in a stochastic manner
    %% mix the layer structures by the half and half method
    
    p1_layer_structures = structure1.layer_structures;
    p2_layer_structures = structure1.layer_structures;

    
    
end

% ====================MATING DESCRIPTION ===========================%
% our first try will be very simple: we will only recombine layers
% ==================================================================%

function children = mate_individuals(structure1, structure2)
    % remember that num_layers specifies one graphene, one dielectric
    % segment
    num_layers_1 = structure1.num_layers;
    num_layers_2 = structure2.num_layers;
    
    % determe the cuts; factor of two because the num_layers specify duples
    % this might change when we add hbn;
    cut1 = randi([1, num_layers_1-1], 1); %requires that there are more than 2 layers, which is okay
    cut2 = randi([1, num_layers_2-1], 1);

    % the hard part, now we need to create tow children classes
    child1 = structure1; % matlab's child1 can be modified without affecting the parent
    child2 = structure2;
    
    % there are four variables which we have to modify
    % graphene_bool -- THIS WILL LIKELY be different when we add hbn
%     layer_structure_specification
%     layer_specification
%     thickness of each layer

    child1.material_2d_bool = [structure1.material_2d_bool(1:cut1), structure2.material_2d_bool(cut2+1:end)];
    child2.material_2d_bool = [structure2.material_2d_bool(1:cut2), structure1.material_2d_bool(cut1+1:end)];

    child1.layer_specification = [structure1.layer_specification(1:cut1), structure2.layer_specification(cut2+1:end)];
    child2.layer_specification = [structure2.layer_specification(1:cut2), structure1.layer_specification(cut1+1:end)];

    child1.layer_materials_properties = [structure1.layer_materials_properties(1:cut1),...
        structure2.layer_materials_properties(cut2+1:end)];
    child2.layer_materials_properties = [structure2.layer_materials_properties(1:cut2),...
        structure1.layer_materials_properties(cut1+1:end)];

    
    child1.thickness_of_each_layer = ...
        [structure1.thickness_of_each_layer(1:cut1), structure2.thickness_of_each_layer(cut2+1:end)];
    child2.thickness_of_each_layer = ...
        [structure2.thickness_of_each_layer(1:cut2), structure1.thickness_of_each_layer(cut1+1:end)];

    child1.layer_structure_specification = ...
        [structure1.layer_structure_specification(1:cut1), structure2.layer_structure_specification(cut2+1:end)];
    child2.layer_structure_specification = ...
        [structure2.layer_structure_specification(1:cut2), structure1.layer_structure_specification(cut1+1:end)];
    
    %update layer info
    child1.num_layers = length(child1.material_2d_bool);
    child2.num_layers = length(child2.material_2d_bool);
    % get rid of the fitness information since these structures are
    % different
    child1.Ref = cell(1); child1.Tran = cell(1); child1.Fitness = -Inf;
    child2.Ref = cell(1); child2.Tran = cell(1); child2.Fitness = -Inf;
    children = {child1, child2};
    
end
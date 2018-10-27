
%% initializes population given a size, a lattice_constant, thickness_range
%% layer_dielectric_tensor_distribution and structure_distributions are
%% CELLS containing a pool of initial structures which are LEFT UP TO THE USER 

function [population] = population_initializer(num_individuals,...
    lattice_constant, thickness_range, ...
    layer_dielectric_tensor_distribution, layer_structure_distribution)
        %{
            in order for this function to have a broad level of
            generalizability, YOU must generate your own distribution or 
            list of dielectric tensors and layer structures that you want
            to input
    
            num_individuals = pop size
            lattice_constant is fixed obviously
            thickness_range: [min, max]
    
            % these are ARRAYS of cells, each cell has a layer dielectric
            tensor
            layer_dielectric_tensors
            layer_structures
        %}
    
    %1) initialize population
    population = population_class(num_individuals);
    
    %2) start adding individuals
    for ind = 1:num_individuals
        

        %% selection of the dielectric tensor arrangement: determines num_layers
        l1 = length(layer_dielectric_tensor_distribution);
        sampled_index = randi([1, l1], 1);
        layer_dielectric_tensors = ...
            layer_dielectric_tensor_distribution{sampled_index};
        
        num_layers = length(layer_dielectric_tensors);

        %% generate thickness r of layers and select layer distribution
        layer_thicknesses = [];
        layer_structure = cell(1);
        for layer = 1:num_layers
            %generate thickness
            Delta = thickness_range(1)+rand(1)*abs(diff(thickness_range));
            layer_thicknesses(layer) = Delta;
            
            % select the layer structure from distribution
            sample = randi([1,length(layer_structure_distribution)],1);
            layer_structure{layer} = layer_structure_distribution{sample};
            
        end
        
       
        
        %% generate individual and add to the pop list
        individual_i = layered_structure_class(num_layers, lattice_constant, ...
              layer_dielectric_tensors, layer_structure, layer_thicknesses);
        population.immature_population{ind} = individual_i;
          
    end
    
       
end
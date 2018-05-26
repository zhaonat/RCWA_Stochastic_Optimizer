classdef population_class_anisotropic
    %POPULATION_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % mature = has been simulated
        mature_population
        % immature = has not been simulated
        immature_population
        num_individuals 

    end
    
    methods
        function obj = population_class_anisotropic(num_individuals)
            %POPULATION_CLASS Construct an instance of this class
            %   Detailed explanation goes here
            obj.num_individuals = num_individuals;
        end
        
        function obj = initialize_population(obj, num_layers, lattice_constant, material_proportions)
            %store population in a cell array, since everything is a string
            population = cell(obj.num_individuals, 1);
            for i = 1:obj.num_individuals
               %generate individual
               initial = layered_structure_class();
               population{i} = initial.initialize_random_structure(num_layers, lattice_constant, material_proportions);
            end
            obj.immature_population = population;
         
        end
        
        
    end
end


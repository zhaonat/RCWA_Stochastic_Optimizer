%%matlab class for general specificiation of a 1D structure for RCWA

classdef layered_structure_class
    
   properties
      num_layers
      lattice_constant    
      frozen_unfrozen_layer_bool %freezes a layer in the optimization
      
      layer_dielectric_tensors= cell(1); %specifies dielectric tensor for each layer
      %every dielectric tensor is a 3x3 matrix
      % each cell element is a cell array with one tensor for each medium 
      
      layer_structures = cell(1); %specifies grating of each structure
      layer_thicknesses = cell(1);
      
      % evaluation fields (only when a simulation is performed)
      Fitness
      
   end
   
   methods
      % CONSTRUCTOR
      % do not want too much dielectric spacers, mostly just graphene
      function obj = layered_structure_class(num_layers, lattice_constant, ...
              layer_dielectric_tensors, layer_structure_specification, layer_thicknesses )
          
          %% check that the layer structure specification is valid
          for i = 1:length(layer_structure_specification)
             assert(sum(layer_structure_specification{i}) == lattice_constant);
          end
          assert(length(layer_thicknesses) == num_layers, 'number of thickness not equal to num_layers');
          assert(length(layer_dielectric_tensors) == num_layers, 'number of tensor cells not equal to num_layers');
          assert(length(layer_structure_specification) == num_layers, 'number of structure cells not equal to num_layers');
 
          obj.num_layers = num_layers;
          obj.lattice_constant = lattice_constant;
          obj.layer_dielectric_tensors = layer_dielectric_tensors;
          obj.layer_structures = layer_structure_specification;
          obj.layer_thicknesses = layer_thicknesses;
      end

      
      function [f, periods] = convert_to_RCWA(obj)
          %{
            Bo's code requires a weird format so we have to cater to that
          %}
          f = cell(1); periods = [];
          for i = 1:length(obj.layer_structures)
            periods = [periods, obj.lattice_constant];
            layer_material_lengths =obj.layer_structures{i};
            layer_material_lengths2 = obj.convert_layer_lengths(layer_material_lengths);
            periodl = layer_material_lengths2(end);
            f{i}=  layer_material_lengths2/periodl;
            f{i} = f{i}(1:end-1);
          end
          
      end
      
      function converted_lengths = convert_layer_lengths(~,layer_lengths)
            converted_lengths = [];
            cur_length = 0;
            for i  = 1:length(layer_lengths)
                cur_length = cur_length+layer_lengths(i);
                converted_lengths = [converted_lengths, cur_length];
            end
      end
      
   end
end
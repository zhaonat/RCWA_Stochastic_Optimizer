%%matlab class for general specificiation of the 2d material

classdef layered_structure_class
    
   properties
      num_layers
      lattice_constant    
  
      material_2d_bool%2d material or not?
      materials_2D_list = cell(1); %alternative to the bool
      
      patterned_unpatterned_bool %specifies whether to pattern the layer
      frozen_unfrozen_layer_bool %freezes a layer in the optimization
      
      layer_specification = cell(1); %specifies dielectric tensor
      layer_materials_properties = cell(1);
      layer_structure_specification = cell(1);
      thickness_of_each_layer = cell(1);
      
      % evaluation fields (only when a simulation is performed)
      Ref 
      Tran
      Fitness
   end
   
   methods
      % CONSTRUCTOR
      % do not want too much dielectric spacers, mostly just graphene
      function obj = layered_structure_class()
          
      end
      
      function obj = initialize_random_structure(obj,num_layers, lattice_constant, material_proportions)
          
          % generate a random number between 4 and num_layers  (for extra
          % diversity)
          num_layers = randi([2, num_layers], 1);
          obj.layer_materials_properties = cell(1, num_layers);
          obj.num_layers = num_layers;
          obj.lattice_constant = lattice_constant;
          
          %now we do not explicitly enforce that every graphene layer must
          % have a dielectric spacer
          obj.material_2d_bool = obj.generate_material_bool_2d(material_proportions);%randi([0,2], 1,num_layers);
          %obj.material_2d_bool = repmat([1,2], 1,num_layers/2);
          for i = 1:num_layers %num_layers should be even
               if(obj.material_2d_bool(i) >0)
                   structure = obj.generate_symmetric_structure(obj.lattice_constant);
                   obj.layer_structure_specification{i} = structure;
                   if(obj.material_2d_bool(i) ==1)
                      obj.thickness_of_each_layer{i} = 0.34e-3;
                      obj.layer_specification{i} =  'graphene';
                      obj.layer_materials_properties{i} = graphene();
                   else
                      obj.thickness_of_each_layer{i} = 0.6e-3;
                      obj.layer_specification{i} =  'hBN';

                   end
               else
                   eps_r = randi([obj.dielectric_range(1), obj.dielectric_range(2)],1);
                   obj.layer_specification{i} =  eps_r;
                   obj.thickness_of_each_layer{i} = obj.spacing_range(1) + ...
                       (obj.spacing_range(2)-obj.spacing_range(1))*rand();
                   obj.layer_structure_specification{i} = lattice_constant/2*[1,1];
               end
          end
      end
      
%       function structure = generate_custom_structure()
%       
%       end
      
      %for now, we generate just single slit structures
%       function structure = generate_structure(~,lattice_constant)
%             indicator = [1,0,1];
%             lengths = rand(1, 3);
%             lengths(2) = (lengths(1)+lengths(3))/10; % 5 times smaller
%             initial_length = sum(lengths);
%             ratio = lattice_constant/initial_length;
%             lengths = lengths*ratio;
%             structure = [indicator; lengths];
%       end
      
      function structure = generate_symmetric_structure(~, lattice_constant)
            indicator = [1,0,1];
            slit = rand()*lattice_constant/2;
            edge = (lattice_constant-slit)/2;
            lengths = [edge, slit, edge];
            structure = [indicator; lengths];          
      end
      
      function [f, periods] = convert_to_RCWA(obj)
          f = cell(1); periods = [];
          for i = 1:length(obj.layer_structure_specification)
            periods = [periods, obj.lattice_constant];
            if(mod(i,2) == 1)
                layer_material_lengths =obj.layer_structure_specification{i};
                layer_material_lengths2 = obj.convert_layer_lengths(layer_material_lengths);
                periodl = layer_material_lengths2(end);
                f{i}=  layer_material_lengths2/periodl;
                f{i} = f{i}(1:end-1);
            else
                f{i} = obj.lattice_constant/2;
            end
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
      
      function material_bool_2d = generate_material_bool_2d(obj, proportions)
          %proportions is an array of numbers less than 1 that indicates
          %probabilities
          p = rand(1, obj.num_layers);
          material_bool_2d = [];
          for i = 1:length(p)
              if(p(i)< proportions(1))
                   material_bool_2d(i) = 0; %diel
              elseif(p(i)>proportions(1))
                   material_bool_2d(i) = 1; %graphene
              else 
                   material_bool_2d(i) = 2; %hbn   
              end
          end
      end
   end
end
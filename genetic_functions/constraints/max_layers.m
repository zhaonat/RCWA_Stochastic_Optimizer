
function population = max_layers(population, maximum_layers)
    %%function which truncates structure to some maximum layer number
   
    for ind = 1:length(population)
       structure = population{ind};
       if(structure.num_layers <= maximum_layers)
           population{ind} = structure;
       else
           
           structure.layer_thicknesses = structure.layer_thicknesses(1:maximum_layers);
           structure.layer_structures = {structure.layer_structures{1:maximum_layers}};
           structure.layer_dielectric_tensors = {structure.layer_dielectric_tensors{1:maximum_layers}};
           structure.num_layers = maximum_layers;
           population{ind} = structure;
       end
       
    end

end
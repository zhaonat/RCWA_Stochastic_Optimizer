%% simple function to generate a large number of random permutations of
% dielectrics in a layer


function [layer_dielectric_tensor_distribution] = generate_dielectric_layers(num_samples, min_layers, max_layers, dielectric_tensors_list)

    num_dielectrics = length(dielectric_tensors_list);
    layer_dielectric_tensor_distribution= cell(1);
    for i = 1:num_samples
        structure = cell(1);
        num_layers =  randi([min_layers, max_layers], 1);
        for j = 1:num_layers
            dielectric_index = randi([1, num_dielectrics], 1);
            structure{j} = dielectric_tensors_list{dielectric_index};
        end
        
       layer_dielectric_tensor_distribution{i} = structure; 
    end

end
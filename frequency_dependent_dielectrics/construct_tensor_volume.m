
function[tensor_vol] = construct_tensor_volume(dielectric_1d_array)
    %% targeted for uniform dielectrics or isotropic 
    % takes an array and constructs a 3x3xnumwavelength tensor
    N_lambda = length(dielectric_1d_array);
    tensor_vol =repmat(eye(3,3), 1,1,N_lambda);

    for i = 1:N_lambda
        tensor_vol(:,:,i) = dielectric_1d_array(i)*tensor_vol(:,:,i);
    end
    
end
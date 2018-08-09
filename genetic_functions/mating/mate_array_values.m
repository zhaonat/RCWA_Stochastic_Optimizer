
% function which tries to mate the thicknesses of different layers
% inputs are assumed to be arrays, so don't try putting cells in here

function [mean,upper_perturbation1, bottom_perturbation1, ...
    upper_perturbation2, bottom_perturbation2] = mate_array_values(array1, array2)

    mean = (array1+array2)/2;
    upper_perturbation1 = array1+0.01*array1;
    bottom_perturbation1 = array1-0.01*array1;
    upper_perturbation2 = array2+0.01*array2;
    bottom_perturbation2 = array2-0.01*array2;
    %we can generate a huge number of children..., which could be bad
    
    
end
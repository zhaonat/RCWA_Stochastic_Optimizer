# RCWA_Stochastic_Optimizer
Stochastic Optimization with rigorous-coupled-wave-analysis (RCWA)
Basically a brute force type optimization whereby we generate a large set of structures, simulate them, evaluate how close they are to our desired 
objective, trim the population based on this objective, and then 'mate' the good structures to generate a 'fitter' population.
Repeat until good.

## API Definition
'layered_structure_class' specifies a single individual
  1) num_layers
  2) lattice_constant    
  3) frozen_unfrozen_layer_bool %freezes a layer in the optimization

  4) layer_dielectric_tensors= cell(1); %specifies dielectric tensor for each layer
  %every dielectric tensor is a 3x3 matrix
  % each cell element is a cell array with one tensor for each medium 

  5) layer_structures = cell(1); %specifies grating of each structure
  6) layer_thicknesses = cell(1);

  7) Fitness

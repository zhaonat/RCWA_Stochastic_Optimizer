# RCWA_Stochastic_Optimizer
Stochastic Optimization with rigorous-coupled-wave-analysis (RCWA)
Basically a brute force type optimization whereby we generate a large set of structures, simulate them, evaluate how close they are to our desired 
objective, trim the population based on this objective, and then 'mate' the good structures to generate a 'fitter' population.
Repeat until good.

## API Definition
'layered_structure_class' specifies a single individual
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

# RCWA_Stochastic_Optimizer
Stochastic Optimization with rigorous-coupled-wave-analysis (RCWA)
Basically a brute force type optimization whereby we generate a large set of structures, simulate them, evaluate how close they are to our desired 
objective, trim the population based on this objective, and then 'mate' the good structures to generate a 'fitter' population.
Repeat until good.

## API Definition
'layered_structure_class' specifies a single individual


% ====================MATING DESCRIPTION ===========================%
% our first try will be very simple: we will only recombine layers
% ==================================================================%

function children = mate_individuals(structure1, structure2)

    child1 = structure1;
    child2 = structure2;
    children = {child1, child2};
    
end
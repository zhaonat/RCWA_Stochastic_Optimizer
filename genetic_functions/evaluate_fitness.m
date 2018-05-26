
%calculate euclidean distance between spectra and desired spectra

function fitness = evaluate_fitness(spectra, desired_spectra, weights)
     if ~exist('weights','var')
         % third parameter does not exist, so default it to something
          weights = ones(1,length(spectra));
     end
     
     %negative sign because we want to maximize while distance should be 0
     % at optimum
     fitness = -sum((weights.*sqrt((spectra - desired_spectra).^2)));

end
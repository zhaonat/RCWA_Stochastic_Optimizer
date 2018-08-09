
function generation_offspring = mate_population(population)
     l = length(population);
     generation_offspring = cell(1);
     c = 1;
     for i = 1:2:l
         if(mod(l,2) == 1 && i == l) %in case the populatoin is odd
             break;
         end
         parent1 = population{i};
         parent2 = population{i+1};
         
         %% ============================================================%%
         % want to carefully engineer this
         children  = mate_individuals(parent1, parent2);
         %% ============================================================%%
         
         generation_offspring{c} = children{1};
         c = c+1;
         generation_offspring{c} = children{2};
         c = c+1;
     end
end
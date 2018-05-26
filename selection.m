
% =================================================
% population: this is a cell array containing each individual
% where the fitness for each individual has been evaluated
% individual in population
% =====================

function [reduced_population, max_individual, fitnesses] = selection(population, selection_rate)
    %always take the top 50% with the HIGHEST fitness
    %first, get all fitnesses into a list (we'll just use it to get the
    %median)
    fitnesses = [];
    for i = 1:length(population)
        fitnesses(i) = population{i}.Fitness;
    end

    cutoff = median(fitnesses);

    % now iterate through the population again and sort individuals into
    % two halves
    top_half = cell(1); bottom_half = cell(1);
    th = 1; bh = 1;
    max_fitness = -Inf; max_individual = 0;
    for i = 1:length(population)
        if(population{i}.Fitness > max_fitness)
           max_individual = population{i}; 
           max_fitness = population{i}.Fitness;
        end
        %want to enforce a 50/50 split
        if(population{i}.Fitness >= cutoff && th <= length(population)/2)
           top_half{th} = population{i};
           th = th+1;
        else
           bottom_half{bh} = population{i};
           bh = bh+1;
        end
    end
    
    % now select the selection rate percent of the top half
    top_cut = randi([1,length(top_half)], 1, round(selection_rate*length(top_half)));
    bottom_cut = randi([1,length(bottom_half)], ...
        1,round((1-selection_rate)*length(bottom_half)));

    reduced_population = [top_half(top_cut), bottom_half(bottom_cut)];
    
end
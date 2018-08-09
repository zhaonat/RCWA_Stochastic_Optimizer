
% acccept two cell arrays, and split and mix

function [c1, c2] = partition_cell(p1, p2, split1, split2)

    l1 = length(p1);
    l2 = length(p2);
%     split1 = randi([1, l1],1);
%     split2 = randi([1, l2],1);
    
    c1 = [p1(1:split1), p2(split2+1:end)];
    c2 = [p1(split1+1:end), p2(1:split2)];
    
end
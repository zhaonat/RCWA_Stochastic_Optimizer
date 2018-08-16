function [c1, c2] = partition_array(p1, p2, split1, split2)
    % p1: some array in matlab, for example, the thicknesses of each layer
    % corresponding to parent 1
    % p2: some array in matlab, but for the second parent
    % split1; INTEGER FROM 1 TO LENGTH(P1)
    % split2; integer from 1 to length of p2

    % ===================================
    %this segment here is optional, it was here so the function would
    %generate the split, but that's not the best idea 
%     l1 = length(p1);
%     l2 = length(p2);
%     split1 = randi([1, l1],1);
%     split2 = randi([1, l2],1);
    % ================================================
    
    
    %% perform mixing
    c1 = [p1(1:split1), p2(split2+1:end)];
    c2 = [p1(split1+1:end), p2(1:split2)];
    
end
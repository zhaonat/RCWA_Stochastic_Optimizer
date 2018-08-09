
function [] = visualize_structure(structure)
    y = 0;
    figure()
    for i = 1:length(structure.layer_thicknesses)
        d = structure.layer_thicknesses(i);
        a = structure.layer_structures{i}; 
        x = 0;
        color = rand()*[1,1,1];
        for j = 1:length(a)
            segment = a(j);
            %[x_corner, y_corner, width, height]
            if(mod(j,2) == 0)
               rectangle('Position',[x, y, segment, d], 'FaceColor', 1-color);
            else
               rectangle('Position',[x, y, segment, d], 'FaceColor', color);
            end
            x = x+segment;

        end

        drawnow()
        hold on;
        y = y+d;

    end
end

function [] = visualize_structure(structure)
    %take the thickness specifications
    y = 0;
    figure()
    lattice_constant = structure.lattice_constant
    for i = 1:length(structure.thickness_of_each_layer)
        d = structure.thickness_of_each_layer{i};
        if(structure.material_2d_bool(i) == 1)
            a = structure.layer_structure_specification{i}; seg_spec = size(a);
            rectangle('Position',[0, y, lattice_constant, d], 'FaceColor', 'blue');
            x = 0;
            for j = 1:seg_spec(2)
                segment = a(2,j);
                if(a(1,j) == 0)
                    rectangle('Position',[x, y, segment, d], 'FaceColor', 'white');
                end
                x = x+segment;
            end
        elseif(structure.material_2d_bool(i) == 2)
            a = structure.layer_structure_specification{i}; seg_spec = size(a);
            rectangle('Position',[0, y, lattice_constant, d], 'FaceColor', 'green');
            x = 0;
            for j = 1:seg_spec(2)
                segment = a(2,j);
                if(a(1,j) == 0)
                    rectangle('Position',[x, y, segment, d], 'FaceColor', 'white');
                end
                x = x+segment;
            end
        else
            eps_r = structure.layer_specification{i};
            rectangle('Position',[0, y, lattice_constant, d], 'FaceColor', (eps_r/12)*[1,1,1]);

        end
        drawnow()
        hold on;
        y = y+d;

    end
end
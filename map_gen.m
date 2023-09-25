close all;
clear;
clc;

%% Generate map
% Value of truth map relates to the height of object
map_sz = [6.8 5];
resolution = 0.01; %grid_size

grid_num = ceil(map_sz / resolution);
% add 2 more rows and collumn for wall
grid_num = grid_num + [2 2];

truth_map = zeros(grid_num);

% Add wall
truth_map (1:end, 1) = -length_to_cell(1, resolution);
truth_map (1, 1:end) = -length_to_cell(1, resolution);
truth_map (end, 1:end) = -length_to_cell(1, resolution);
truth_map (1:end, end) = -length_to_cell(1, resolution);
% Add column 
col_loc = vertcat(grid_num/2,grid_num/2) + [-15 -15; 15 15];
col_loc = round (col_loc);
truth_map (col_loc(1,1):col_loc(2,1),col_loc(1,2):col_loc(2,2)) = -length_to_cell(1, resolution);
%% Add obstacle
 truth_map = add_obj ([1 -2.1], 0.2, 1, truth_map, resolution);
 truth_map = add_obj ([3 -2.5], 0.15, 1, truth_map, resolution);
 truth_map = add_obj ([2 -3], 0.2, -1, truth_map, resolution);
 truth_map = add_obj ([2 -4.2], 0.15, 1, truth_map, resolution);
 truth_map = add_obj ([4 -3], 0.15, -1, truth_map, resolution);
 truth_map = add_obj ([1 -4], 0.15, 1, truth_map, resolution);
 truth_map = add_obj ([1.2 -3.5], 0.15, -1, truth_map, resolution);

world.height_map = truth_map;
world.resolution = resolution;

a = draw_map(truth_map);

function ret = draw_map (map)
    img_rot = imrotate(map, 90);
    imagesc(img_rot)
    grid on
    axis equal
    ret = 1;
end

function new_map = add_obj (loc, radius, type, map, res)
    % 1 for a positive obj, -a is a negative obj
    grid_per_dia = round(2 * radius / res);
    x = -radius:res:radius;
    y = x;
    z = zeros(size(x,2),size(x,2));
    for i = 1:size(x,2)
        for j = 1:size(y,2)
            test = radius^2 - x(i)^2 - y(j)^2;
            if test > 0
                z(j,i) = -type * sqrt(test)/res;
            end
        end
    end
    loc(2) = - loc(2);
    top_left_loc = (loc - [radius, radius])/res;
    bot_right_loc = top_left_loc + [size(x,2)-1,size(x,2)-1];
    new_map = map;
    new_map (top_left_loc(1):bot_right_loc(1), top_left_loc(2):bot_right_loc(2)) = z;
end

function grid_count = length_to_cell (len, res)
    grid_count = len/res;
end


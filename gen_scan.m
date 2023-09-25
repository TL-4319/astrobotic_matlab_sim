function scan = gen_scan(cam_pose, cam, world)
    hor_ang = -cam.hfov/2:cam.angular_res*3:cam.hfov/2;
    ver_ang = -cam.vfov/2:cam.angular_res:cam.vfov/2;
    scan = [0,0,0];
    cam_pose.pos(2) = - cam_pose.pos(2);
    % ray tracing to generate scan
    parfor i = 1:size(hor_ang,2)
        for j = 1:size(ver_ang,2)
            ray_ang = [cam_pose.att(2) + ver_ang(j), cam_pose.att(3) + hor_ang(i)];
            %ray_ang = [cam_pose.att(2) + 0, cam_pose.att(3) + 0];
            zrot_mat = [cos(deg2rad(ray_ang(2)))    sin(deg2rad(ray_ang(2)))       0;
                                -sin(deg2rad(ray_ang(2)))   cos(deg2rad(ray_ang(2)))        0;
                                0                   0               1];
            yrot_mat = [cos(deg2rad(ray_ang(1)))  0   sin(deg2rad(ray_ang(1)));
                0           1       0         ;
            -sin(deg2rad(ray_ang(1))) 0   cos(deg2rad(ray_ang(1)))];
            rot_mat = zrot_mat * yrot_mat;
            % Propagate along ray
            for k = 0.3:0.02:cam.max_range
                ray_vec = rot_mat * [k;0;0];
                test_point = cam_pose.pos' + ray_vec;
                grid_cell = [round(test_point(1)/world.resolution), round(test_point(2)/world.resolution)];
                grid_cell(1) = max(1, grid_cell(1));
                grid_cell(1) = min (size(world.height_map,1),grid_cell(1));
                grid_cell(2) = max(1, grid_cell(2));
                grid_cell(2) = min (size(world.height_map,2),grid_cell(2));
                height_data = world.height_map(grid_cell(1), grid_cell(2)) * world.resolution;
                if test_point(3) > height_data
                    %scan = vertcat(scan, [test_point(1),test_point(2),height_data]);
                    scan = vertcat(scan, [test_point(1),test_point(2),test_point(3)]);
                    break
                end
                %plot3 ([cam_pose.pos(1),test_point(1)],[cam_pose.pos(2), test_point(2)], [cam_pose.pos(3),test_point(3)],'.');
                %grid on
            end
        end
    end
    scan(:,2) = -scan(:,2);
end
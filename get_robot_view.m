function scan_body = get_robot_view(scan, camera_pose)
    % Get rid of the [0, 0, 0]
    scan(1,:) = [];
    heading = camera_pose.att(3);
    zrot_mat = [cos(deg2rad(heading))    sin(deg2rad(heading))       0;
                                -sin(deg2rad(heading))   cos(deg2rad(heading))        0;
                                0                   0               1];
    scan_body = scan;
    for i = 1:size(scan,1)
        temp = zrot_mat * scan(i,:)';
        temp(1) = temp(1) + camera_pose.pos(2);
        temp(2) = temp(2) - camera_pose.pos(1);
        scan_body(i,:) = temp';
    end
end
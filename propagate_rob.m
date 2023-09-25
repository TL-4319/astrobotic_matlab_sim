function pred_pose = propagate_rob(current_pose, cmd, dt)
    vb_cmd = cmd(1);
    omega_cmd = cmd(2);
    current_pos = current_pose.pos;
    current_att = current_pose.att;
    att = current_att;
    psi_dot = omega_cmd;
    x_dot = vb_cmd * cosd(current_att(3));
    y_dot = vb_cmd * sind(current_att(3));
    pos = current_pos;
    pos(1) = current_pos(1) + x_dot * dt;
    pos(2) = current_pos(2) + y_dot * dt;
    att(3) = att(3) + psi_dot * dt;
    pred_pose.pos = pos;
    pred_pose.att = att;
end


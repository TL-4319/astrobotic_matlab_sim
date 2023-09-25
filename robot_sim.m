close all;
clear;
clc;

load world.mat;

%% Test camera
camera.vfov = 70;
camera.hfov = 110;
camera.angular_res = 1;
camera.max_range = 3;
camera_pose.pos = [2 0 -0.4];
camera_pose.att = [0 -20 -90];
tic
scan = gen_scan(camera_pose, camera, world);
scan_rob_frame = get_robot_view (scan, camera_pose);
toc

% figure
% plot3(scan(:,1), scan(:,2),scan(:,3),'.');
% hold on
% plot3([0 6.8],[0 -5],[0 -2],'.');
% grid on
% set(gca,"ZDir","reverse")
% set(gca,"YDir","reverse")
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')

figure(1)
a = draw_map(world.height_map);

% figure()
% plot3(scan_rob_frame(:,1), scan_rob_frame(:,2),scan_rob_frame(:,3),'.');
% grid on
% set(gca,"ZDir","reverse")
% set(gca,"YDir","reverse")
% axis equal
% xlabel('X')
% ylabel('Y')
% zlabel('Z')

while (1)
    tic
    camera_pose = propagate_rob(camera_pose, [0.1 0], 0.2);
    scan = gen_scan(camera_pose, camera, world);
    scan_rob_frame = get_robot_view (scan, camera_pose);
    rob_ground = scan_rob_frame (abs(scan_rob_frame(:,3)) < 0.02,:);
    rob_pos = scan_rob_frame (scan_rob_frame(:,3) <= -0.02,:);
    rob_neg = scan_rob_frame (scan_rob_frame(:,3) >= 0.02,:);
    figure(2)
    plot(rob_ground(:,1),rob_ground(:,2),'g.');
    hold on
    plot(rob_pos(:,1),rob_pos(:,2),'r.');
    plot(rob_neg(:,1),rob_neg(:,2),'k.');
    xlim([-0 5]);
    ylim([-2.5 2.5]);
    set(gca,"YDir","reverse")
    hold off
    axis equal;
    drawnow;
    toc
end

% figure()
% a = draw_map(world.height_map);

function ret = draw_map (map)
    img_rot = imrotate(map, 90);
    imagesc(img_rot)
    grid on
    axis equal
    ret = 1;
end
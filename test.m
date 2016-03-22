
% constants
dt = 20/1000;

%speed
motor_speed = 0;
speed_idx = 0;
speed_vec = zeros(8, 1);


% result
while 1
    [speed_vec, motor_speed, mean_rotation] = getMotorSpeed(0, dt, speed_vec, speed_idx);
    speed_idx = speed_idx + 1;
end

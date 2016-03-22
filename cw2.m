
% setup environment
clc;
clear;
lego = legoev3('usb');

% setup connections
lmotor = motor(lego, 'D');
rmotor = motor(lego, 'A');
motors = [lmotor rmotor];
gyro = gyroSensor(lego);
clearLCD(lego);

% reset
resetRotation(lmotor);
resetRotation(rmotor);
resetRotationAngle(gyro);




%%%%%%%% Main loop %%%%%%%%

% start motors with speed 0
for I = motors
    I.Speed = 0;
    start(I);
    
end

% constants
refpos = 0;
radius = 55/2000;
dt = 20/1000;

%speed
magical_speed = 1;
motor_speed = 0;
speed_idx = 0;
speed_vec = zeros(8, 1);

% angle
gyro_mean = 0; % needs to be calibrated
ang = 0;

%pid
last_combined = 0;
cumulative_err = 0;

%set power
steering = 0;

t0 = clock;

while 1
    while etime(clock,t0) > (dt*1)
        clc
        % reset timer
        t0 = clock;

        %%% position %%% SPEED?
        refpos = refpos + (dt*magical_speed*0.002);


        %%% read encoders %%%
        [speed_vec, motor_speed, mean_rotation] = getMotorSpeed(motors, dt, speed_vec, speed_idx);
        speed_idx = speed_idx + 1;

        % compute robot position and speed
        c = 57.3;
        robot_position = (radius*mean_rotation)/c;
        robot_speed = (radius*motor_speed)/c;


        disp('---');
        %%% read gyro %%%
        curr_angle_val = gyroFiler(gyro);
        c = dt * 0.2;
        gyro_mean = (gyro_mean*(1-c))+(curr_angle_val*c);
        angle_vel = curr_angle_val - gyro_mean;
        ang = ang + (dt*angle_vel);
        
        
        motor_diff_position = robot_position - refpos;
        combined = combineSensorValues(ang, angle_vel, motor_diff_position, robot_speed);
        
        
        clearLCD(lego);
        writeLCD(lego, num2str(ang), 3, 5);
        writeLCD(lego, num2str(angle_vel), 5, 5);
        writeLCD(lego, num2str(robot_speed), 7, 5);
        


        %%% PID %%%
        [pid_output, cumulative_err] = get_pid(dt, combined, last_combined, cumulative_err);

        % store last error
        last_combined = combined;
        disp(pid_output);


        %%% POWER %%%
        power = pid_output*dt/radius;
        lmotor.Speed = power;
        rmotor.Speed = power;
%         disp(power);
        
    end
    
end






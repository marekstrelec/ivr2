function cw2
    % setup environment
    clc;
    clear all;
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
    keep_running = 1;
    
    % show figure
    f = figure;
    set(f,'Resize','off');
    set(f, 'menubar', 'none');
    set(f,'PaperPositionMode','auto')
    set(f,'Position',[450 500 250 200]);
   
    btn_start = uicontrol('Parent', f, 'Style', 'pushbutton',...
        'String', 'Startit',...
        'Position', [50 100 150 50],...
        'Callback', @startit);
        
    btn_terminate = uicontrol('Parent', f, 'Style', 'pushbutton',...
        'String', 'Terminate',...
        'Position', [50 50 150 50],...
        'Callback', @setaction);


    function setaction(source, callbackdata)
        keep_running = 0;
        close all;
        
        for K = motors
            stop(K);
        end
    end  

    function startit(source, callbackdata)
        % start motors with speed 0
        for K = motors
            K.Speed = 0.0;
            start(K);
        end

        % constants
        refpos = 0.0;
        radius = 55.0/2000.0;
        dt = 20.0/1000;

        %speed
        magical_speed = 1.0;
        motor_speed = 0.0;
        speed_idx = 0.0;
        speed_vec = zeros(8, 1);

        % angle
        gyro_mean = 1.0; % needs to be calibrated
        ang = 1.0;

        %pid
        last_combined = 0.0;
        cumulative_err = 0.0;

        %set power
        steering = 0.0;

        t0 = clock;
        while keep_running == 1
            drawnow % important for updating variables
            while etime(clock,t0) > (dt*20)
                clearLCD(lego);
                clc
                disp(keep_running);
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
                curr_angle_val = double(gyroFiler(gyro));
                fprintf('filter: %d \n', curr_angle_val);

                c = dt * 0.2;
                gyro_mean = double((gyro_mean*(1-c))+(curr_angle_val*c));
                angle_vel = curr_angle_val - gyro_mean;
                ang = ang + (dt*angle_vel);


                motor_diff_position = robot_position - refpos;
                % filter = -40 - 40
                % ang_vel = -50 - 50
                % ang = -15 - 15 and is returning slowly back to zero
                % motor_speed = 0.1 (20 cm)
                % motor_position = 0.1 in (20cm)
                % motor_ref_pos =  
                combined = combineSensorValues(ang, angle_vel, motor_diff_position, robot_speed);


                fprintf('angle: %d \n', ang);
                fprintf('angle_vel: %d \n', angle_vel);
                fprintf('robot_position: %d \n', robot_position);
                fprintf('robot_speed: %f \n', robot_speed);

                % filter = -10 - 10
                % ang only positive and stays the same
                % robot_position 0
                % robot_speed 0.8



                %%% PID %%%
                [pid_output, cumulative_err] = get_pid(dt, combined, last_combined, cumulative_err);

                % store last error
                last_combined = combined;
        %         disp(pid_output);


                %%% POWER %%%
                power =(pid_output*dt/radius)*0.1;
                lmotor.Speed = power;
                rmotor.Speed = power;

        %         writeLCD(lego, num2str(power), 9, 5);

            end
        end
        
    end


end






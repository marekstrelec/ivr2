function [ result, cumulative_err ] = get_pid( dt, curr_err, prev_err, cumulative_err )

    % constants
    kp = 0.6;
    ki = 14;
    kd = 0.005;
    
    cumulative_err = cumulative_err + (curr_err*dt);
    dif_err = (curr_err - prev_err)/dt;
    
    a = kd * dif_err;
    b = ki * dif_err;
    c = kp * curr_err;
    
    result = a + b + c;
    

end


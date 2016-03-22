function [ result, cumulative_err ] = get_pid( dt, curr_err, prev_err, cumulative_err )

    % constants
    kp = 0.6;
    ki = 14.0;
    kd = 0.005;
    
    cumulative_err = double(cumulative_err + (curr_err*dt));
    dif_err = double((double(curr_err) - double(prev_err))/dt);
    
    a = kd * dif_err;
    b = ki * dif_err;
    c = kp * double(curr_err);
    
    result = double(a + b + c);
    

end


function [ result_speed_vec, result_speed, mean_rotation ] = getMotorSpeed( motors, dt, speed_vec, speed_index)

    % compute rotation mean
    lrotation = readRotation(motors(1));
    rrotation = readRotation(motors(2));
%     lrotation = uint8(rand()*10)+2;
%     rrotation = uint8(rand()*10)+2;
    mean_rotation = (lrotation+rrotation)/2;
    
    % get indexes
    vec_len = length(speed_vec);
    idx = mod(speed_index, vec_len) + 1;
    cmp_idx = mod(speed_index + 1, vec_len) + 1;
    
    % save new value
    speed_vec(idx, 1) = mean_rotation;
    result_speed_vec = speed_vec;
    
    % compute speed
    c = speed_vec(idx, 1);
    d = speed_vec(cmp_idx, 1);
    result_speed = (c-d)/(vec_len*dt);
    

end


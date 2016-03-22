function [ ] = move( motors, speed, duration )
    % Controls movement of motors

    for I = motors
        start(I);
        I.Speed = speed;
    end
    
    pause(duration);
    
    for I = motors
        stop(I);
    end


end


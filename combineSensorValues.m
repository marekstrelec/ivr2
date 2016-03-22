function [ result ] = combineSensorValues( angle, angular_velocity, motor_diff_position, motor_speed )

    % set constants
    gain_angle = 25.0;
    gain_angular_velocity = 1.3;
    gain_motor_position = 350.0;
    gain_motor_speed = 75.0;
    
    % combine
    a = double(gain_angle * angle);
    b = double(gain_angular_velocity * angular_velocity);
    % c = gain_motor_position*(motor_position-motor_reference_position);
    c = double(gain_motor_position*motor_diff_position);
    d = double(gain_motor_speed * motor_speed);
    
    result = a + b + c + d;

end


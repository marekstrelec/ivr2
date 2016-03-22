function [ result ] = combineSensorValues( angle, angular_velocity, motor_diff_position, motor_speed )

    % set constants
    gain_angle = 25;
    gain_angular_velocity = 1.3;
    gain_motor_position = 350;
    gain_motor_speed = 75;
    
    % combine
    a = gain_angle * angle;
    b = gain_angular_velocity * angular_velocity;
    % c = gain_motor_position*(motor_position-motor_reference_position);
    c = gain_motor_position*motor_diff_position;
    d = gain_motor_speed * motor_speed;
    
    result = a + b + c + d;

end


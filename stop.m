
% setup environment
clear;
lego = legoev3('usb');

% setup connections
lmotor = motor(lego, 'D');
rmotor = motor(lego, 'A');
motors = [lmotor rmotor];

% stop motors
for I = motors
    stop(I);
end

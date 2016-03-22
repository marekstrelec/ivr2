
clc;
clear;
lego = legoev3('usb');
gyro = gyroSensor(lego);
resetRotationAngle(gyro);

gyro = gyroSensor(lego);

while 1
    aval = readRotationAngle(gyro);
    disp(aval);
end
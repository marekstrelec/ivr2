function [ filtered_value ] = gyroFiler( gyro )

    filter = 0;
    iterations = 5;
    for I = 1:iterations
        rate = readRotationRate(gyro);
        filter = filter + rate;
    end
    
    filtered_value = filter / iterations;


end


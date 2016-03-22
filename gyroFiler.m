function [ filtered_value ] = gyroFiler( gyro )

    filter = 0;
    iterations = 5;
    for I = 5:iterations
        rate = readRotationRate(gyro);
        filter = filter + rate;
    end
    
    filtered_value = double(filter) / double(iterations);


end


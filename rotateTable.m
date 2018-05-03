function rotateTable(arduino,clkPin,numberOfSteps)
%ROTATESTEP Summary of this function goes here
%   Detailed explanation goes here
    for id=1:numberOfSteps
        writeDigitalPin(arduino, clkPin, 0);
        pause(0.06);
        writeDigitalPin(arduino, clkPin, 1);
        pause(0.06);
    end
end


function rotation_height = calcRotationAndHeight(verticalVector,horizontalVector,positionVector)
%CALCROTATIONANDHEIGHT Summary of this function goes here
%   Detailed explanation goes here

%--------------------------------------------
% TODO - check x,y coordinates
%--------------------------------------------
A = [verticalVector(1) horizontalVector(1);
     verticalVector(2) horizontalVector(2)];
b = positionVector';
rotation_height = A\b;
end


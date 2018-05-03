imgSize = size(laserMask1);
imgHeight = imgSize(1);
imgWidth  = imgSize(2);

% the first coordinate is the radius in [mm]
% the second coordinate is the height in [mm]
polarPointSet1_mm = zeros([rotations imgHeight 2]);
for iy = 1:imgHeight
    pointCounter = 0;
    pointLocation = zeros([1 1]);
    for ix = 1:imgWidth
        if laserMask1(iy,ix) == 1
            pointCounter  = pointCounter + 1;
            pointLocation = pointLocation + [iy ix];
        end    
    end
    if pointCounter ~= 0
       pointLocation = pointLocation / pointCounter;
       positionVector = pointLocation - rotationAxisOrigo; % y,x
       rotation_height = calcRotationAndHeight(verticalVector,horizontalVector,positionVector); 
       polarPointSet1_mm(idr,iy,:) = rotation_height;
    end       
end


polarPointSet2_mm = zeros([rotations imgHeight 2]);
for iy = 1:imgHeight
    pointCounter = 0;
    pointLocation = zeros([1 1]);
    for ix = 1:imgWidth
        if laserMask2(iy,ix) == 1
            pointCounter  = pointCounter + 1;
            pointLocation = pointLocation + [iy ix];
        end    
    end
    if pointCounter ~= 0
       pointLocation = pointLocation / pointCounter;
       positionVector = pointLocation - rotationAxisOrigo; % y,x
       rotation_height = calcRotationAndHeight(verticalVector,horizontalVector,positionVector); 
       polarPointSet2_mm(idr,iy,:) = rotation_height;
    end       
end
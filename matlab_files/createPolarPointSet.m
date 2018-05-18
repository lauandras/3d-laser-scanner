function polarPointSet_mm=createPolarPointSet(tfLaserMask,polarPointSet_mm,idr,xdata,ydata)
imgSize = size(tfLaserMask);
imgHeight = imgSize(1);
imgWidth  = imgSize(2);

% the first coordinate is the radius in [mm]
% the second coordinate is the height in [mm]
for iy = 1:imgHeight
    pointCounter = 0;
    pointLocation = 0;
    for ix = 1:imgWidth
        if tfLaserMask(iy,ix) ~= 0
            pointCounter  = pointCounter + 1;
            pointLocation = pointLocation + ix;
        end    
    end
    % if there are multiple points in one line then calculate average
    if pointCounter ~= 0
        pointLocation = pointLocation / pointCounter;
        positionVector = [pointLocation,iy];
        rotation_height = [positionVector(1)+xdata(1) positionVector(2)+ydata(2)];
        polarPointSet_mm(idr,iy,:) = rotation_height;
    end       
end
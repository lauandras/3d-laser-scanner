function [rect,NullNull,nullnull]=imageCrop
img=imread('calibration_images\Image21.png');
[croppedimage, rect] = imcrop(img);
nullnull(1)=cameraParams.ReprojectedPoints(1,1,21)-rect(1);
nullnull(2)=cameraParams.ReprojectedPoints(1,2,21)-rect(2);

NullNull=[cameraParams.ReprojectedPoints(24,1,21)-rect(1)...
    cameraParams.ReprojectedPoints(24,2,21)-rect(2)];

squareInPixels=(cameraParams.ReprojectedPoints(6,2,21)-...
    cameraParams.ReprojectedPoints(1,2,21))/5;

NullNull(2)=NullNull(2)+squareInPixels;
function [tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams)

v4=cameraParams.ReprojectedPoints(1,:,paralellImageNumber)-[rect(1) rect(2)];
v1=cameraParams.ReprojectedPoints(6,:,paralellImageNumber)-[rect(1) rect(2)];
v3=cameraParams.ReprojectedPoints(49,:,paralellImageNumber)-[rect(1) rect(2)];
v2=cameraParams.ReprojectedPoints(54,:,paralellImageNumber)-[rect(1) rect(2)];

worldCoordinates=14.55*[-4 -6; -4 -1; 4 -6; 4 -1];

tform = maketform('projective',[v4; v1; v3; v2],worldCoordinates);
[newImage,xdata,ydata]=imtransform(imgCropped,tform);

imsize=size(newImage);
tfHeight=imsize(1);
tfWidth=imsize(2);
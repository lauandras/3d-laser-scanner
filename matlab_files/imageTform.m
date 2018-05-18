function [tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams)
% determine the transformation object according to the image, what was
% parallel with the laserline

% getting the coordinates of the v1,v2,v3,v4 in the cropped image
% coordinate system
p1=cameraParams.ReprojectedPoints(1,:,paralellImageNumber)-[rect(1) rect(2)];
p2=cameraParams.ReprojectedPoints(6,:,paralellImageNumber)-[rect(1) rect(2)];
p4=cameraParams.ReprojectedPoints(49,:,paralellImageNumber)-[rect(1) rect(2)];
p3=cameraParams.ReprojectedPoints(54,:,paralellImageNumber)-[rect(1) rect(2)];

% size of an element of the checkerboard in [mm]
checkerBoardSize = 14.55;
% wordCoordinates
v1 = [-4 -6];
v2 = [-4 -1];
v4 = [4 -6];
v3 = [4 -1];
% with this modification 1[px] will be equal with 1[mm]
worldCoordinates=checkerBoardSize*[v1; v2; v4; v3];

% determine the transformation
tform = maketform('projective',[p1; p2; p4; p3],worldCoordinates);

% transform the cropped image 
[newImage,xdata,ydata]=imtransform(imgCropped,tform);

% getting the transformed image size 
imsize=size(newImage);
tfHeight=imsize(1);
tfWidth=imsize(2);
end
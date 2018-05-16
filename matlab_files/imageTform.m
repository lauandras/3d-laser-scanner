function [tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,tfPoints)

v4=tfPoints(4,:)-[rect(1) rect(2)];
v1=tfPoints(1,:)-[rect(1) rect(2)];
v3=tfPoints(3,:)-[rect(1) rect(2)];
v2=tfPoints(2,:)-[rect(1) rect(2)];

worldCoordinates=14.55*[-4 -6; -4 -1; 4 -6; 4 -1];

tform = maketform('projective',[v4; v1; v3; v2],worldCoordinates);
[newImage,xdata,ydata]=imtransform(imgCropped,tform);

imsize=size(newImage);
tfHeight=imsize(1);
tfWidth=imsize(2);
function [horizontalVectorNorm,verticalVectorNorm]=vectorNorms
imageNumber=23;
squareSize=14.55; %mm

%Irányvektorok
horizontalVector=[0 0];
verticalVector=[0 0];

for i=0:5
    horizontalVector(1)=horizontalVector(1)+...
        cameraParams.ReprojectedPoints(1+i,1,imageNumber)-...
        cameraParams.ReprojectedPoints(49+i,1,imageNumber);
    horizontalVector(2)=horizontalVector(2)+...
        cameraParams.ReprojectedPoints(49+i,2,imageNumber)-...
        cameraParams.ReprojectedPoints(1+i,2,imageNumber);
end
horizontalVector=horizontalVector/6;
squareInPixelsHorizontal=sqrt(sum(horizontalVector.*horizontalVector))/8;

for j=0:8
    verticalVector(1)=verticalVector(1)+...
        cameraParams.ReprojectedPoints(1+j*6,1,imageNumber)-...
        cameraParams.ReprojectedPoints(6+j*6,1,imageNumber);
    verticalVector(2)=verticalVector(2)+...
        cameraParams.ReprojectedPoints(6+j*6,2,imageNumber)-...
        cameraParams.ReprojectedPoints(1+j*6,2,imageNumber);
end
verticalVector=verticalVector/9;
squareInPixelsVertical=sqrt(sum(verticalVector.*verticalVector))/5;

horizontalVectorLength=squareInPixelsHorizontal/squareSize*...
    sqrt(sum(horizontalVector.*horizontalVector));
verticalVectorLength=squareInPixelsVertical/squareSize*...
    sqrt(sum(verticalVector.*verticalVector));

horizontalVectorNorm=horizontalVector/horizontalVectorLength;   %px/mm
verticalVectorNorm=verticalVector/verticalVectorLength;         %px/mm
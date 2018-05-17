%----------------------------------------------------
% run this scritp to make images
%----------------------------------------------------

%----------------------------------------------------
%   Camera calibration
%----------------------------------------------------

% laserPin - the pin, on which the linelaser is soldered to
laserPin = 'D2';
prompt = 'On which Port the laser controlling Arduino is connected: ';
laserCom = input(prompt,'s');

% connecting to the laser controlling Arduino on Port 'laserCom'
laserDino = arduino(laserCom,'Nano3');
disp('Laser connected')

% switch on the laser, that you can place the table so, that the laserline
% intersect the rotation axis
writeDigitalPin(laserDino,laserPin,1);

% if 'cameraParams' variable exists, then the calibration process is already done 
if (exist('cameraParams','var')~=1)
    % if not then clear the variables for webCam - 'cam', the camera
    % calibration toolbox will use it
    clear cam
    
    disp('Make minimum 15 pictures, then more 3 so,'+... 
        +'that the chessboard pattern is parallel with the laserline!')
    % starting camera calibration toolbox
    cameraCalibrator
    prompt = 'What is the number of the picture, on '+...
        +'what the laserline is parallel with the chessboard: ';
    paralellImageNumber = input(prompt);
end


%----------------------------------------------------
%   Initialization
%----------------------------------------------------

% if there are no camera or laser or turntable variables
% on the workspace

% exist name -- returns 1 if 'name' is a variable in the workspace and 0 if
% not
if ((exist('a','var')&&exist('laserDino','var')&&exist('cam','var'))~=1)
    clear a
    clear cam
    clear laserDino
    [a,laserDino,cam]=init(laserCom);
end

%--------------------------------------------------------
%   Cropping the valuable areas of the images
%--------------------------------------------------------

disp('Place the object on the turntable and then click the figure!')
% show figure window
figure;
% waiting for the click
waitforbuttonpress;
disp('Select the object on the image, then right click and "Crop Image"!')
% take a snapshot and display it on the figure
img=snapshot(cam);
[imgCropped,rect]=imcrop(img);

%--------------------------------------------------------
%   Transzformáció meghatározása
%--------------------------------------------------------
[tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams);

%--------------------------------------------------------
%   Szúkséges változók deklarációja
%--------------------------------------------------------
rotations=400;
imgSize = size(img);
imgHeight = imgSize(1);
imgWidth  = imgSize(2);
croppedHeight=int16(rect(4));
croppedWidth=int16(rect(3));
polarPointSet_mm = zeros([rotations tfHeight 2]);
filteredImages=zeros(rotations,croppedHeight,croppedWidth);
transformedImages=zeros(rotations,tfHeight,tfWidth);
kepek=zeros([rotations croppedHeight croppedWidth]);
clk='D6';

%--------------------------------------------------------
%   Szkennelés
%--------------------------------------------------------
figure;
f=waitbar(0,'Inicializálás','Name','Making images');
for idr=1:rotations
    laserMask=laser_line_detection(rect,laserDino,laserPin,cam);
    kepek(idr,:,:)=laserMask;
    rotateTable(a,clk,400/rotations);
    tfLaserMask=imtransform(laserMask,tform);
    polarPointSet_mm=createPolarPointSet(tfLaserMask,polarPointSet_mm,idr,xdata,ydata);
    waitbar(idr/rotations,f,sprintf('%d/%d',idr,rotations));
end
close(f)

%--------------------------------------------------------
%   Pontfelhõ generálása
%--------------------------------------------------------
xyz=pointCloud(rotations,polarPointSet_mm,tfHeight);
pcshow(xyz)
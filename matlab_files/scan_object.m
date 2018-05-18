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
%   Determining the image transformation
%--------------------------------------------------------
[tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams);

%--------------------------------------------------------
%   Initializing further variables
%--------------------------------------------------------

% the number of rotatinos with the turntable makes one total rotation 
% (360 degree)
rotations=400;

% getting the height and width of the cropped images
imgSize = size(img);
imgHeight = imgSize(1);
imgWidth  = imgSize(2);
croppedHeight=int16(rect(4));
croppedWidth=int16(rect(3));

% initializing the polar point set with maximum pointnumber
%  - we have 400 pictures from a whole rotation and 
%  - each picture have an tfHeight on which we will iterate through
%  - each point have a radius and height coordinate
polarPointSet_mm = zeros([rotations tfHeight 2]);

% initializing the arrays, what are containing all off the images
filteredImages=zeros(rotations,croppedHeight,croppedWidth);
transformedImages=zeros(rotations,tfHeight,tfWidth);
kepek=zeros([rotations croppedHeight croppedWidth]);

% set the clock signal pin on which we are communicating with the turntable
clk='D6';

%--------------------------------------------------------
%   Scanning
%--------------------------------------------------------

% create window
figure;
% create status bar
f=waitbar(0,'Initialization','Name','Making images');
for idr=1:rotations
    % capturing an image and detect the laserline on it
    laserMask=laser_line_detection(rect,laserDino,laserPin,cam);
    kepek(idr,:,:)=laserMask;
    % rotating the table
    rotateTable(a,clk,1);
    % transforming the img
    tfLaserMask=imtransform(laserMask,tform);
    % generating the polar pointset
    polarPointSet_mm=createPolarPointSet(tfLaserMask,polarPointSet_mm,idr,xdata,ydata);
    % refreshing the status bar
    waitbar(idr/rotations,f,sprintf('%d/%d',idr,rotations));
end
close(f)

%--------------------------------------------------------
%   Pontfelhõ generálása xyz koordinatarendszerbe
%--------------------------------------------------------
xyz=pointCloud(rotations,polarPointSet_mm,tfHeight);
pcshow(xyz)
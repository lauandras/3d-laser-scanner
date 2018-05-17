%----------------------------------------------------
% run this scritp to make images
%----------------------------------------------------

%----------------------------------------------------
%   Camera calibration
%----------------------------------------------------
laserPin = 'D2';
prompt = 'On which Port is the laser controlling Arduino is connected: ';
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
%   Inicializ�l�s, ha nincs kamera VAGY l�zer VAGY forg�asztal
%----------------------------------------------------
%exist() 1-et ad vissza, ha a v�ltoz� l�tezik a workspace-en, 0-�t, ha nem
if ((exist('a','var')&&exist('laserDino','var')&&exist('cam','var'))~=1)
    clear a
    clear cam
    clear laserDino
    [a,laserDino,cam]=init(laserCom);
end

%--------------------------------------------------------
%   K�p �rdemi r�sz�nek kijel�l�se
%--------------------------------------------------------
disp('Tegye a t�rgyat a forg�asztalra, ha megvan kattintson a figurre!')
figure;
waitforbuttonpress;
disp('Jel�lje ki a k�pen a t�rgyat, majd jobb eg�rgomb �s "Crop Image"!')
img=snapshot(cam);
[imgCropped,rect]=imcrop(img);

%--------------------------------------------------------
%   Transzform�ci� meghat�roz�sa
%--------------------------------------------------------
[tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams);

%--------------------------------------------------------
%   Sz�ks�ges v�ltoz�k deklar�ci�ja
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
%   Szkennel�s
%--------------------------------------------------------
figure;
f=waitbar(0,'Inicializ�l�s','Name','Making images');
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
%   Pontfelh� gener�l�sa
%--------------------------------------------------------
xyz=pointCloud(rotations,polarPointSet_mm,tfHeight);
pcshow(xyz)
% run this scritp to make images
rotations=400;
%----------------------------------------------------
%   Kamera kalibr�ci�ja
%----------------------------------------------------
laserPin = 'D2';
if (exist('cameraParams')~=1)
    clear cam
    disp('K�sz�tsen 15 k�pet 4 m�sodperces k�zid�vel, majd m�g 3-at �gy, hogy a sakkt�bla minta a l�zerrel p�rhuzamos!')
    cameraCalibrator
    %prompt = 'Mi annak a k�pf�jlnak a neve, amin a l�zerrel p�rhuzamos minta van?';
    %paralellImage = input(prompt,'s');
    prompt = 'Mi annak k�pnek a sorsz�ma, amin a l�zerrel p�rhuzamos minta van?';
    paralellImageNumber = input(prompt);
end

%----------------------------------------------------
%   Inicializ�l�s, ha nincs kamera, l�zer �s forg�asztal
%----------------------------------------------------
if ((exist('a')&&exist('laserDino')&&exist('cam'))~=1)
    prompt = 'Melyik porthoz van csatlakoztatva a l�zer vez�rl�je: ';
    laserCom = input(prompt,'s');
    [a,laserDino,cam]=init(laserCom);
end

%--------------------------------------------------------
%   K�p �rdemi r�sz�nek kijel�l�se
%--------------------------------------------------------
disp('Tegye a t�rgyat a forg�asztalra, ha megvan kattintson a figurre!')
f = figure;
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
f=waitbar(0,'1','Name','Making images',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f,'canceling',0);
for idr=1:rotations
    laserMask=laser_line_detection(rect,laserDino,laserPin,cam);
    kepek(idr,:,:)=laserMask;
    rotateTable(a,clk,1);
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
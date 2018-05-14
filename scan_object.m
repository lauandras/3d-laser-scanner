% run this scritp to make images
rotations=400;
%----------------------------------------------------
%   Kamera kalibrációja
%----------------------------------------------------
laserPin = 'D2';
if (exist('cameraParams')~=1)
    clear cam
    disp('Készítsen 15 képet 4 másodperces közidõvel, majd még 3-at úgy, hogy a sakktábla minta a lézerrel párhuzamos!')
    cameraCalibrator
    %prompt = 'Mi annak a képfájlnak a neve, amin a lézerrel párhuzamos minta van?';
    %paralellImage = input(prompt,'s');
    prompt = 'Mi annak képnek a sorszáma, amin a lézerrel párhuzamos minta van?';
    paralellImageNumber = input(prompt);
end

%----------------------------------------------------
%   Inicializálás, ha nincs kamera, lézer és forgóasztal
%----------------------------------------------------
if ((exist('a')&&exist('laserDino')&&exist('cam'))~=1)
    prompt = 'Melyik porthoz van csatlakoztatva a lézer vezérlõje: ';
    laserCom = input(prompt,'s');
    [a,laserDino,cam]=init(laserCom);
end

%--------------------------------------------------------
%   Kép érdemi részének kijelölése
%--------------------------------------------------------
disp('Tegye a tárgyat a forgóasztalra, ha megvan kattintson a figurre!')
f = figure;
waitforbuttonpress;
disp('Jelölje ki a képen a tárgyat, majd jobb egérgomb és "Crop Image"!')
img=snapshot(cam);
[imgCropped,rect]=imcrop(img);

%--------------------------------------------------------
%   Transzformáció meghatározása
%--------------------------------------------------------
[tfHeight,tfWidth,tform,xdata,ydata]=imageTform(imgCropped,rect,paralellImageNumber,cameraParams);

%--------------------------------------------------------
%   Szúkséges változók deklarációja
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
%   Szkennelés
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
%   Pontfelhõ generálása
%--------------------------------------------------------
xyz=pointCloud(rotations,polarPointSet_mm,tfHeight);
pcshow(xyz)
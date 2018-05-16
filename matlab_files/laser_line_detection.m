function laserMask=laser_line_detection(rect,laserDino,laserPin,cam)
%brighness 130 - def
%contrast 45 - def
%gamma 82
%hue 0 - def
%saturation 80 but it better when lower in darkness
%sharpness 10 - def
%white balance - def

%clear cam;
%cam = webcam('USB2.0_Camera');
%cam.Gamma=82;
%cam.Saturation=0;
%preview(cam);

%--------------------------------------------------------
%   Képkészítés lézerfénnyel és anélkül
%--------------------------------------------------------
writeDigitalPin(laserDino,laserPin,1);
pause(1);
laserOn = snapshot(cam);
pause(1);
writeDigitalPin(laserDino,laserPin,0);
pause(1);
laserOff = snapshot(cam);

%--------------------------------------------------------
%   Képek vágása
%--------------------------------------------------------
laserOnCropped=imcrop(laserOn,rect);
laserOffCropped=imcrop(laserOff,rect);

%--------------------------------------------------------
%   HSV transzformáció, rgb2gray és szûrés
%--------------------------------------------------------
% maskLon = createMaskHSVInDark(laserOnCropped);
% maskLoff = createMaskHSVInDark(laserOffCropped);
% gmlon = rgb2gray(maskLon);
% gmloff = rgb2gray(maskLoff);
%filtered_gray1 = imgaussfilt(gmlon-gmloff,1.1);
grayOn=rgb2gray(laserOnCropped);
grayOff=rgb2gray(laserOffCropped);
filtered_gray = imgaussfilt(grayOn-grayOff,0.8);

%-----------------------------------------------------
% testing sigma values - conclusion 0.8-1.0 are better
%-----------------------------------------------------
% for id = 0.1:0.1:1
%     filtered_img = imgaussfilt(grayOn-grayOff,id);
%     imshow(filtered_img);
%     title(id);
%     pause(2);
% end

% BW1 = edge(filtered_gray,'Sobel','vertical');
%BW2 = edge(filtered_gray,'Prewitt','vertical'); %this is the best in darkness
% 
% imshowpair(BW1,BW2,'montage');
% title('Sobel Filter    compare with graypreimg    Prewitt Filter');

laserMask = detectLaserLineOnImg(filtered_gray);

imshowpair(laserOnCropped,laserMask,'montage');
title('Cropped image    compare with    LaserMask');
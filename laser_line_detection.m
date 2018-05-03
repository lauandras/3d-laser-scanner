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

% making images with and without line laser
writeDigitalPin(laserDino,laserPin,1);
%disp('laserOn')
pause(1);
laserOn = snapshot(cam);
pause(1);
writeDigitalPin(laserDino,laserPin,0);
%disp('laserOff')
pause(1);
laserOff = snapshot(cam);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TODO : call imageCrop with parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%imshowpair(laserOn,laserOff,'montage');
%pause(2);
maskLon = createMaskHSVInDark(laserOn);
maskLoff = createMaskHSVInDark(laserOff);
gmlon = rgb2gray(maskLon);
gmloff = rgb2gray(maskLoff);

grayOn = rgb2gray(laserOn);
grayOff = rgb2gray(laserOff);

imshowpair(grayOn,grayOff,'montage');
pause(2);

imshowpair(gmlon,gmloff,'montage');
pause(2);

filtered_gray1 = imgaussfilt(gmlon-gmloff,1.1);
filtered_gray2 = imgaussfilt(grayOn-grayOff,0.8);

%-----------------------------------------------------
% testing sigma values - conclusion 0.8-1.0 are better
%-----------------------------------------------------
% for id = 0.1:0.1:1
%     filtered_img = imgaussfilt(grayOn-grayOff,id);
%     imshow(filtered_img);
%     title(id);
%     pause(2);
% end

imshowpair(filtered_gray1,filtered_gray2,'montage');
%pause(2);


% BW1 = edge(filtered_gray,'Sobel','vertical');
%BW2 = edge(filtered_gray,'Prewitt','vertical'); %this is the best in darkness
% 
% imshowpair(BW1,BW2,'montage');
% title('Sobel Filter    compare with graypreimg    Prewitt Filter');

laserMask1 = detectLaserLineOnImg(filtered_gray1);
laserMask2 = detectLaserLineOnImg(filtered_gray2);

imshowpair(laserMask1,laserMask2,'montage');
title('LaserMask1    compare with    LaserMask2');
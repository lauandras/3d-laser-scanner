%brighness 130 - def
%contrast 45 - def
%gamma 82
%hue 0 - def
%saturation 80 but it better when lower in darkness
%sharpness 10 - def
%white balance - def
%clear cam;
%cam = webcam('USB2.0_Camera');
cam.Gamma=82;
cam.Saturation=0;
%preview(cam);
preimg = snapshot(cam);
imshow(preimg)
img1 = createMaskRGB(preimg);
gray0 = rgb2gray(preimg);
gray1 = rgb2gray(img1);
imshowpair(gray0,gray1,'montage')
%BW1 = edge(preimg,'sobel');
%BW2 = edge(preimg,'canny');
%imshowpair(BW1,BW2,'montage');
%title('Sobel Filter    compare with preimg    Canny Filter');
BW3 = edge(gray0,'Sobel','vertical');
BW4 = edge(gray0,'Prewitt','vertical'); %this is the best in darkness

imshowpair(BW3,BW4,'montage');
title('Sobel Filter    compare with graypreimg    Canny Filter');
clear all
a = arduino('btspp://98D33190154F','Nano3');
disp('Arduino kapcsolat létrejött')
clk='D6';
dir='D7';
halfStep='D8';
enable='D9';
reset='D10';

writeDigitalPin(a,enable,1);
writeDigitalPin(a,reset,1);
writeDigitalPin(a,dir,1);
writeDigitalPin(a,halfStep,1);
pause(2);

cam=webcam('USB2.0_Camera');
disp('Kamera csatlakoztatva')

grayImage=zeros(480,640);
kepek=zeros(400,480,640);
figure;
f=waitbar(0,'Képek készítése');
for idx=1:400
    % Acquire a single image.
   rgbImage = snapshot(cam);

   % Convert RGB to grayscale.
   grayImage = rgb2gray(rgbImage);
   kepek(idx,:,:)=grayImage;
   % Display the image.
    BW1 = edge(grayImage,'sobel');
    BW2 = edge(grayImage,'canny');
    imshowpair(BW1,BW2,'montage')
    title('Sobel Filter                                   Canny Filter');
    
    writeDigitalPin(a, clk, 0);
    pause(0.06);
    writeDigitalPin(a, clk, 1);
    waitbar(idx/400,f,'Képek készítése');
    pause(0.06);
end
close(f)
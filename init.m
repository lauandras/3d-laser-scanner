% function to initialize variables
clear all

%------------------------------------------
% connection to the table rotating arduino
%------------------------------------------
a = arduino('btspp://98D33190154F','Nano3');
disp('Turntable connected')
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

%--------------------------------------------
% connection to the laser controlling arduino
%--------------------------------------------
laserPin = 'D2';
laserDino = arduino('COM6','Nano3');
disp('Laser connected')
%------------------------------------------ 
% connect to the usb webcamera
%------------------------------------------
cam=webcam('USB2.0_Camera');
disp('Webcam connected')
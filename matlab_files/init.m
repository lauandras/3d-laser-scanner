function [a,laserDino,cam]=init(laserCom,turnTableCom)
% function to initialize variables

%------------------------------------------
% connection to the table rotating arduino
%------------------------------------------
a = arduino(turnTableCom,'Nano3');
%a = arduino('COM9','Nano3');
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

%--------------------------------------------
% connection to the laser controlling arduino
%--------------------------------------------
laserPin = 'D2';
laserDino = arduino(laserCom,'Nano3');
disp('Laser connected')
writeDigitalPin(laserDino,laserPin,0);

%------------------------------------------ 
% connect to the usb webcamera
%------------------------------------------
cam=webcam('USB2.0_Camera');
disp('Webcam connected')
end
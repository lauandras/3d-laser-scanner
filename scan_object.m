% run this scritp to make images
rotations=20;

grayImage=zeros(480,640);
kepek=zeros(rotations,480,640);
figure;
f=waitbar(0,'K�pek k�sz�t�se');
for idx=1:rotations
    laser_line_detection;
    for tobb=1:10
        writeDigitalPin(a, clk, 0);
        pause(0.06);
        writeDigitalPin(a, clk, 1);
        waitbar(idx/rotations,f,'K�pek k�sz�t�se');
        pause(0.06);
    end
end
close(f)
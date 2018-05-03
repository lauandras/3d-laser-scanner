% run this scritp to make images
rotations=20;

grayImage=zeros(480,640);
kepek=zeros(rotations,480,640);
figure;
f=waitbar(0,'Making images');
for idx=1:rotations
    printf('%d/%d\n', idx, rotations);
    
    laser_line_detection;
    rotateTable(a,clk,10);
    waitbar(idx/rotations,f,'Making images');
end
close(f)
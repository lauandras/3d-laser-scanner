% run this scritp to make images
rotations=20;

grayImage=zeros(480,640);
kepek=zeros(rotations,480,640);
figure;
f=waitbar(0,'Making images');
for idr=1:rotations
    printf('%d/%d\n', idr, rotations);
    
    laser_line_detection;
    rotateTable(a,clk,10);
    %createPolarPointSet;
    waitbar(idr/rotations,f,'Making images');
end
close(f)
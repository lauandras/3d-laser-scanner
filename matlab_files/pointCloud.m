function xyz=pointCloud(rotations,polarPointSet_mm,tfHeight)
xyz=zeros([tfHeight*rotations,3]);
for i=1:rotations
    angle=2*pi/(rotations-1)*(i-1);
    for j=1:tfHeight
        % calculating xyz coordinates from the polar ones
        xyz((i-1)*tfHeight+j,1)=polarPointSet_mm(i,j,1)*cos(angle);
        xyz((i-1)*tfHeight+j,2)=polarPointSet_mm(i,j,1)*sin(angle);
        % if our point is under the origo (y axis is mirrored) then put the
        % point in the zero level
        if (-polarPointSet_mm(i,j,2)<0) 
            xyz((i-1)*tfHeight+j,3)=0;
        else
            xyz((i-1)*tfHeight+j,3)=-polarPointSet_mm(i,j,2);
        end
    end
end
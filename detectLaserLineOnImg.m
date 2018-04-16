function laserMask = detectLaserLineOnImg(filteredGrayImg)
%DETECTLASERLINE Summary of this function goes here
%   Detailed explanation goes here

    %laserMask - modified but copied from http://www.instructables.com/id/3D-Laser-Scanning-DIY/
    imgSize = size(filteredGrayImg);
    I_new =zeros(imgSize);

    for iy = 1:imgSize(1)
        xme = max(filteredGrayImg(iy,:));
        xme1 = find(filteredGrayImg(iy,:)==xme, 1, 'last' );
        I_new(iy,xme1) = 1;  
    end

    snap = I_new;
    snap = bwareaopen(snap,20);
    I_c = zeros(size(snap));

    for iy = 1:imgSize(1)-1
        for ix = 1:imgSize(2)
            I_c(iy,ix,:) =snap(iy+1,ix,:)-snap(iy,ix,:);
        end
    end
    I_R =zeros(size(snap));
    for iy = 1:imgSize(1)
        for ix = 1:imgSize(2)-1
            I_R(iy,ix,:) =snap(iy,ix+1,:)-snap(iy,ix,:);
        end
    end
    I_G =zeros(size(snap));
    for iy = 1:imgSize(1)-1
        for ix = 1:imgSize(2)-1
            I_G(iy,ix,:) = sqrt((I_c(iy,ix,:)^2)+(I_R(iy,ix,:)^2));
        end
    end
    I_G = bwareaopen(I_G,20);
    laserMask = zeros(size(I_new));
    for y0 = 1:imgSize(1)
            meanx = round(mean(find(I_G(y0,:)==1))); %Find center of laser on Y line
            if isnan(meanx) == 1 % if no laser on Y that row is = 0;
                laserMask(y0,:)= 0;
            else
                laserMask(y0,meanx)= 1; % if laser on Y set 1 Pixel to = 1 at laser center
            end      
    end
end


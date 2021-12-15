image = imread('testOriginal.tif');

imshow(image);

%make output
out = double(array(image));
[rows cols] = size(out);
out = zeros(rows,cols,3); 


%make kernel
R = zeros(rows, cols);
  R(2:2:end,1:2:end) = 1;
G = zeros(rows, cols);
  G(1:2:end,1:2:end) = 1;
  G(2:2:end,2:2:end) = 1;
B = zeros(rows, cols);
 B(1:2:end,2:2:end) = 1;
              

%step 1 HIGH-ORDER EXTRAPOLATION 
r = zeros(rows,cols,3);
b = zeros(rows,cols,3);
g = zeros(rows,cols,3);



redChannel = image(:, :, 1);
greenChannel = image(:, :, 2); 
blueChannel = image(:, :, 3);

%{
for r = 1:size(image, 1)    % for number of rows of the image
    for c = 1:size(image, 2)    % for number of columns of the image
        if rem(r, 2) == 1 && rem(c, 2) == 1
                    disp("R");
                    r(:,:,1) = 
                    
        end
        if rem(r, 2) == 1 && rem(c, 2) == 0
                    disp("G");
        end
        if rem(r, 2) == 0 && rem(c, 2) == 1
                    disp("G");
        end
        if rem(r, 2) == 0 && rem(c, 2) == 0
                    disp("B");
        end
    end
end
%}

top = circshift(im,[-1 0]) + 0.75*(im-circshift(im,[-2 0])) - 0.25*(circshift(im,[-1 0]) - circshift(im,[-3 0]));
bottom = circshift(im,[1 0]) + 0.75*(im-circshift(im,[2 0])) - 0.25*(circshift(im,[1 0]) - circshift(im,[3 0]));
left = circshift(im,[0 -1]) + 0.75*(im-circshift(im,[0 -2])) - 0.25*(circshift(im,[0 -1]) - circshift(im,[0 -3]));
right = circshift(im,[0 1]) + 0.75*(im-circshift(im,[0 2])) - 0.25*(circshift(im,[0 1]) - circshift(im,[0 3]));

                
% step 2 EDGE ORIENTATION CLASSIFIER AND THE WEIGHTED MEDIAN FILTER

Vert_G_RB = abs(circshift(im,[-1 0]) - circshift(im,[1 0]));
Hors_G_RB = abs(circshift(im,[0 1]) - circshift(im,[0 -1]));
orientationGatRB = zeros(size(im));
orientationGatRB(Vert_G_RB < Hors_G_RB) = 1;

Vert_RB_BR = abs(circshift(im,[-1 -1]) - circshift(im,[1 1]));
Hors_RB_BR = abs(circshift(im,[-1 1]) - circshift(im,[1 -1]));
orientationRBatBR = zeros(size(im));
orientationRBatBR(Vert_RB_BR < Hors_RB_BR) = 1;

Vert_B_G = abs(circshift(bluep,[-1 -1]) - circshift(bluep,[1 1]));
Hors_B_G = abs(circshift(redp,[-1 1]) - circshift(redp,[1 -1]));
orientationBatG = zeros(size(im));
orientationBatG(Vert_B_G < Hors_B_G) = 1;


% step 3 CALCULATE WEIGHTED FINAL VALUES 

greenp = zeros(size(im));
greenp(orientationGatRB == 1) = median([left1(orientationGatRB == 1) right1(orientationGatRB == 1) top1(orientationGatRB == 1) top1(orientationGatRB == 1) bottom1(orientationGatRB == 1) bottom1(orientationGatRB == 1)],2);
greenp(orientationGatRB == 0) = median([left1(orientationGatRB == 0) left1(orientationGatRB == 0) right1(orientationGatRB == 0) right1(orientationGatRB == 0) top1(orientationGatRB == 0) bottom1(orientationGatRB == 0)],2);
greenp(greenLocations == 1) = im(greenLocations == 1);
out(:,:,2) = greenp;

top2 = circshift(im,[-1 -1]) + (out(:,:,2) - circshift(out(:,:,2),[-1 -1]));
left2 = circshift(im,[-1 1]) + (out(:,:,2) - circshift(out(:,:,2),[-1 1]));
right2 = circshift(im,[1 -1]) + (out(:,:,2) - circshift(out(:,:,2),[1 -1]));
bottom2 = circshift(im,[1 1]) + (out(:,:,2) - circshift(out(:,:,2),[1 1]));

redp = zeros(size(im));
redp(orientationRBatBR == 1) = median([left2(orientationRBatBR == 1) right2(orientationRBatBR == 1) top2(orientationRBatBR == 1) top2(orientationRBatBR == 1) bottom2(orientationRBatBR == 1) bottom2(orientationRBatBR == 1)],2);
redp(orientationRBatBR == 0) = median([left2(orientationRBatBR == 0) left2(orientationRBatBR == 0) right2(orientationRBatBR == 0) right2(orientationRBatBR == 0) top2(orientationRBatBR == 0) bottom2(orientationRBatBR == 0)],2);
out(:,:,1) = redp;

top3 = circshift(redp,[-1 0]) + (out(:,:,2) - circshift(out(:,:,2),[-1 0]));
left3 = circshift(redp,[0 -1]) + (out(:,:,2) - circshift(out(:,:,2),[0 -1]));
right3 = circshift(redp,[0 1]) + (out(:,:,2) - circshift(out(:,:,2),[0 1]));
bottom3 = circshift(redp,[1 0]) + (out(:,:,2) - circshift(out(:,:,2),[1 0]));

tempPlane2(orientationBatG == 1) = median([left4(orientationBatG == 1) right4(orientationBatG == 1) top4(orientationBatG == 1) top4(orientationBatG == 1) bottom4(orientationBatG == 1) bottom4(orientationBatG == 1)],2);
tempPlane2(orientationBatG == 0) = median([left4(orientationBatG == 0) left4(orientationBatG == 0) right4(orientationBatG == 0) right4(orientationBatG == 0) top4(orientationBatG == 0) ...
bottom4(orientationBatG == 0)],2);

bluep(greenLocations == 1) = tempPlane2(greenLocations == 1);
out(:,:,3) = bluep;

imshow(out)
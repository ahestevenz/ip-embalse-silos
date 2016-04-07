%% ipAverage
%% Get images
directory='../../info/Embalse_images_measurements/matlab/img';
initial = imread([directory,'/IMG_0071.tif']);
sumImage = double(initial); 
for i=72:80 
  rgbImage = imread([directory,'/IMG_00',num2str(i),'.tif']);
  sumImage = sumImage + double(rgbImage);
end;

%% Mean calculation
meanImage = sumImage / 10;
meanImageUint8=uint8(meanImage);

%% Background subtraction
darkImage=imread([directory,'/IMG_0070.tif']);
meanSubtractImageUint8=imsubtract(meanImageUint8,darkImage);

%% Export ouput images
imwrite(meanImageUint8,[directory,'/IMG_MEAN.tif']);
imwrite(meanSubtractImageUint8,[directory,'/IMG_DIFF_MEAN.tif']);

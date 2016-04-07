%% ipGetCentroids
%% Clean Workspace
clear All

%% Get image
directory='../../info/Embalse_images_measurements/matlab/img';
[pathstr,name,ext] = fileparts(directory);
inputImage=imread([directory,'/IMG_MEAN.tif']); % This image is generated by ipAverage.m script
inputImage(:,:,1)=0; % Delete the red channel. Thermal noise.
grayImage=rgb2gray(inputImage); % Grayscale conversion
[y_size, x_size]=size(grayImage);
export_images=true;

%% Physical parameters
pixelXSize=119;%minsky=122; %img=119;
pixelYSize=123;%minsky=129; %img=123;
septaXSize=28;%minsky=28; %img=28;
septaYSize=24;%minsky=22; %img=24

%% Centroids
x_c=zeros(1,10);
y_c=zeros(1,10);
centroids=zeros(1,200);
k=1;

for i=1:10
      for j=1:10
          if i==1
              x_c(1)=floor(pixelXSize/2);
          else
              x_c(i)=x_c(i-1)+septaXSize+pixelXSize;
          end
          if j==1
              y_c(1)=floor(pixelYSize/2);
          else
              y_c(j)=y_c(j-1)+septaYSize+pixelYSize;
          end
        centroids(k)=x_c(i);
        centroids(k+1)=y_c(j);
        k=k+2;
     end
end

%% Get pixels values
pixelsValues=zeros(119,123,100);
pixelsMean=zeros(1,100);
[y_size_p, x_size_p, pixels_]=size(pixelsValues);

k=1;
for l=1:100
    for i=-floor(pixelXSize/2)+1:1:floor(pixelXSize/2)+1
        for j=-floor(pixelYSize/2)+1:1:floor(pixelYSize/2)+1
            pixelsValues(i+floor(pixelXSize/2),j+floor(pixelYSize/2),l)=grayImage(centroids(k)+i,centroids(k+1)+j);
        end
    end
    k=k+2;
end

for l=1:100
    pixelsMean(l)=sum(sum(pixelsValues(:,:,l)))/(y_size_p*x_size_p);
end
    
pixelsMeanMatrix=vec2mat(pixelsMean,10);
    
%% Graphic
figure
h=bar3(pixelsMeanMatrix);
colormap jet;
colorbar;

shading interp;
 for i = 1:length(h)
     zdata = get(h(i),'ZData');
     set(h(i),'CData',zdata)
     set(h,'EdgeColor','k') 
 end
 rotate3d

%% Export images

if (export_images)
    if ~exist(['Export/',name], 'dir');mkdir('Export/',name);end
    saveas(gcf,['Export/',name,'/Luminancia_perspectiva3D'],'epsc');    
    h=view(0, 90);
    saveas(gcf,['Export/',name,'/Luminancia_perspectiva2D'],'epsc');     
    h=view(-45, 30);
end

    
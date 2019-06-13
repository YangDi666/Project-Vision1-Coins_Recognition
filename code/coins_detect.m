function [wallet,sum,stats,result_detect]=coins_detect(myImage,SF)

%% This function can detect and distinguish different kinds of coins
%% and count the total value of coins. 
%% The input myImage is the original image and SF is the scale factor. 
%% The output sum is the total value, wallet(matrice 1*8) is the number of each kind of coin, 
%% stats conserve the 3 parameters(diameter, centroid, pixelList)of each detected disk and 
%% result_detect is the type of each coin. 

%% 1 Pretreatment and detect shadows
I=imfilter(myImage,fspecial('gaussian',[3,3],0.5),'replicate');
I_hsv = rgb2hsv(I);
r = medfilt2(double(myImage(:,:,1)), [3,3]); 
g = medfilt2(double(myImage(:,:,2)), [3,3]);
b = medfilt2(double(myImage(:,:,3)), [3,3]);

% detection of shadows
shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
shadow_mask = shadow_ratio>0.088;
shadow_mask = bwareaopen(shadow_mask, 150);
shadow_mask1=imclose(shadow_mask,strel('disk',10));

%% 2 Detect coins by the method of gradient
I_test=(I_hsv(:,:,3));
[gmax1,gh,gv]=tse_imgrad(I_test,'sobel');
g1=sqrt(gh.^2+gv.^2);
[fs,h]=tse_imhysthreshold(g1);
fs=imfill(fs,'holes');

mask=imopen(fs,strel('disk',1));
mask=imfill(mask,'holes');
mask=imopen(mask,strel('disk',2));
mask=imfill(mask,'holes');
mask=imopen(mask,strel('disk',3));
mask=imfill(mask,'holes');
mask=imopen(mask,strel('disk',4));
mask=imfill(mask,'holes');
mask=imopen(mask,strel('disk',5));
mask=imfill(mask,'holes');

%delete the shadows 
result1=mask-shadow_mask1;
result1=imfill(result1,'holes');
result1=bwareaopen(result1, 200);

%% 3 Detect coins by the method of the 2nd dimension of the image hsv. 
I_test2=I_hsv(:,:,2);
I_test2=imadjust(I_test2);
% figure(6);
% imshow(I_test2);
%I_wb=tse_imthreshold(I_test2,1,'entropy');
%I_wb=tse_imthreshold(I_test2,2,'variance');
%I_wb=tse_imthreshold(I_test2,1,'variance')&tse_imthreshold(I_test2,1,'entropy');
threshold1=multithresh(I_test2,2);
I_wb=(I_test2>threshold1(1,2));
I_wb1=imfill(I_wb,'holes');
I_wb2=imclose(I_wb1,strel('disk',5));

%delete the shadows 
result2=I_wb2-shadow_mask1;
result2=imclose(result2,strel('disk',1));
result2=imfill(result2,'holes');
result2=imclose(result2,strel('disk',2));
result2=imfill(result2,'holes');
result2=imclose(result2,strel('disk',10));
result2=imfill(result2,'holes');
result22=imclearborder(result2);
result22=bwareaopen(result22, 200);
marker=result22&result1;
result2=imreconstruct(marker,result22);

% figure(8),imshow(result22);title('Segmentation by method 2');

% We found that using threshold to the second dimension of the image hsv 
% was better than using gradient(except 2 euros sometimes and 1 euros).
% The radius we got was much closer to the original image. 
% Finally, we used the method 1 to detect the coin 2euro(sometimes and 1euro) 
% and used method 2 to detect other coins. 

%% 4 Combination 
% Now we add the segments of 2 euros in the image we got at the third 
% step.In the end, the combination of images at the step 2 and 3 is the
% final result. 
rest=result1-result2;
marker=imopen(rest,strel('disk',30));
marker=im2bw(marker);
euro2=imreconstruct(marker,result1);
%  figure(10);
%  imshow(euro2);title('Segmentation of the coin 2euro(sometimes and 1euro)');

%result of the segmentation
result=euro2|result2;
result=imclearborder(result);
result=bwareaopen(result, 500);
% figure(11);imshow(result);title('Final result');
% figure(12);imshow(label2rgb(I_label),[]);title('Label of final result');

%% 5 Distinguish coins by the diameter and RGB
% use commandes imopen and imclose to make the color of coin more stable
% and this will helpful for distinction of coins by the color later.
result_detect=[];
Ie=imopen(myImage,strel('disk',10));
Ies=imclose(Ie,strel('disk',10));
wallet=zeros(1,8);
stats = regionprops(result,'EquivDiameter','Centroid','PixelList');
diameter=zeros(1,size(stats,1));

% detection
for i=1:size(stats,1)
     diameter(i) = stats(i).EquivDiameter;
     
     % 1 cent
     if (14.742/SF)<=diameter(i)&&diameter(i)<(17.577/SF)
         wallet(1,1)=wallet(1,1)+1;
             result_detect=[result_detect,1];
     end
     
    % distinguish 2 cent and 10 cent
    % we find that the diffrence between the valeur of red division and the
    % valeur of green divsion is the key to distinguish gold and copper.
    if (17.577/SF)<=diameter(i)&&diameter(i)<=(20.5538/SF)
        cent=round(stats(i).Centroid);
        valPixelR=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,1);
        valPixelG=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,2);
        aveR=mean(valPixelR(:));
        aveG=mean(valPixelG(:));
        aveRG=aveR-aveG;
        if(aveRG<=24)
            wallet(1,4)=wallet(1,4)+1;
            result_detect=[result_detect,10];
        else
            wallet(1,2)=wallet(1,2)+1;        
            result_detect=[result_detect,2];
        end
    end
    
    % distinguish 5 cent and 20 cent     
    % we also use R-G 
    if (20.5538/SF)<diameter(i)&&diameter(i)<(22.9635/SF)
        cent=round(stats(i).Centroid);
        valPixelR=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,1);
        valPixelG=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,2);
        aveR=mean(valPixelR(:));
        aveG=mean(valPixelG(:));
        aveRG=aveR-aveG;
        if(aveRG<=25)
            wallet(1,5)=wallet(1,5)+1;
            result_detect=[result_detect,20];
        else
            wallet(1,3)=wallet(1,3)+1;
            result_detect=[result_detect,5];
        end
    end

    % distinguish 1euro and 50 cent
    % we use R-G again
    if (22.9635/SF)<=diameter(i)&&diameter(i)<=(24.948/SF)
        cent=round(stats(i).Centroid);
        valPixelR=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,1);
        valPixelG=Ies(cent(1,2)-100:cent(1,2)+100,cent(1,1)-100:cent(1,1)+100,2);
        aveR=mean(valPixelR(:));
        aveG=mean(valPixelG(:));
        aveRG=aveR-aveG;
        if(aveRG<7)
            wallet(1,7)=wallet(1,7)+1;
            result_detect=[result_detect,100];
        else
            wallet(1,6)=wallet(1,6)+1;
            result_detect=[result_detect,50];
        end
    end
    
    % 2euro
    if (24.948/SF)<diameter(i)&&diameter(i)<=(28.35/SF)
       wallet(1,8)=wallet(1,8)+1;
       result_detect=[result_detect,200];
    end
    
    % null
    if (28.35/SF)<diameter(i)||diameter(i)<=(14.742/SF)
        result_detect=[result_detect,0];
    end
end


%% 6 Count the value of coins
    sum=wallet(1,1)*0.01+wallet(1,2)*0.02+wallet(1,3)*0.05+...
        wallet(1,4)*0.1+wallet(1,5)*0.2+wallet(1,6)*0.5...
        +wallet(1,7)*1+wallet(1,8)*2;
end
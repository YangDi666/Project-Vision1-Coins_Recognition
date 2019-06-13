%% This test is for Analysis II

clc; clear all; close all;
I = imread('group23.jpg');

R=[0.1:0.1:1];
sum_r=[];
for r = R
% add a Gaussian noise
I_noise=imnoise(im2double(I)/r,'gaussian');
figure;
imshow(I_noise,[]);
% coins detection
[wallet,sum,stats,result_detect]=coins_detect2(I_noise,0.019);
sum_r=[sum_r,sum];

for i=1:size(stats,1)
            cent=round(stats(i).Centroid);
            switch result_detect(i)
                case 1
                    text(cent(1,1),cent(1,2),'C1','horiz','center','color','y') ;
                case 2
                    text(cent(1,1),cent(1,2),'C2','horiz','center','color','y') ;
                case 5
                    text(cent(1,1),cent(1,2),'C5','horiz','center','color','y') ;
                case 10
                    text(cent(1,1),cent(1,2),'C10','horiz','center','color','y') ;
                case 20
                    text(cent(1,1),cent(1,2),'C20','horiz','center','color','y') ;
                case 50
                    text(cent(1,1),cent(1,2),'C50','horiz','center','color','y') ;
                case 100
                    text(cent(1,1),cent(1,2),'E1','horiz','center','color','y') ;
                case 200
                    text(cent(1,1),cent(1,2),'E2','horiz','center','color','y') ;
            end
end
sum
end
sum_r
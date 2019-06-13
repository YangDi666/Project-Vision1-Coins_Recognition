%% This test is for analysis I
clear all, close all;
I = imread('group23.jpg');
figure;
imshow(I);

% function 'coins_detect' is for our own dataset SF1=0.02835
% function 'coins_detect2' is for provided dataset SF2=0.019

% [wallet,sum,stats,result_detect]=coins_detect(I,0.02835);
[wallet,sum,stats,result_detect]=coins_detect2(I,0.019);

sum
wallet
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
   
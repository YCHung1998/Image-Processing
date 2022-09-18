clc;clear;close all
% Floyd-Steinberg Method
filename = 'lena_std.tif';
I = imread(filename);
Config;
G = rgb2gray(I);
% ThresList = [200 160 140];
ThresList = [128 128 140];
ThresGray = 128;
% 0       0
% 0   I   0 Ipad 是將 I 擴增 在 左 右 下 方增一排 0
% 0       0
% 000000000
IR = FloydSteinberg(I(:,:,1), ThresList(1));
IG = FloydSteinberg(I(:,:,2), ThresList(2));
IB = FloydSteinberg(I(:,:,3), ThresList(3));
IGray = FloydSteinberg(G, ThresGray);
Inew = cat(3, IR, IG, IB);

IZ  = zeros(size(I));
irt = IZ;irt(:,:,1) = IR;
igt = IZ;igt(:,:,2) = IG;
ibt = IZ;ibt(:,:,3) = IB;

%% Insert text
Fontsize = 30;
It    = insertText(I, [1 1], 'Origin', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Inewt = insertText(Inew ,[1 1], 'cat', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
IRt   = insertText(irt, [1 1], 'Red', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
IGt   = insertText(igt, [1 1], 'Green', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
IBt   = insertText(ibt ,[1 1], 'Blue', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

Rt    = insertText(IR, [1 1], 'Red', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Gt    = insertText(IG, [1 1], 'Green', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Bt    = insertText(IB ,[1 1], 'Blue', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Grayt = insertText(IGray ,[1 1], 'Gray', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

%% Visualize
figure();
fig1 = imshow(Inew);
figure();
fig2 = montage({It, Rt, Gt, Bt, Grayt}, 'Size', [1 5]);
title(['RGB thres ' num2str(ThresList(1)) ', ' num2str(ThresList(2)) ', ' num2str(ThresList(3))]);
figure();
fig3 = montage({It, IRt, IGt, IBt, Inewt}, 'Size', [1 5]);title('single channel')
%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    if ~exist('HW3', 'dir')
        mkdir('HW3')
    end
    saveas(fig1, fullfile('HW3', 'result_Floyd_Steinberg.png'));
    saveas(fig2, fullfile('HW3', 'result__G.png'));
    saveas(fig3, fullfile('HW3', 'result.png'));
end
%% Function
function Ic = FloydSteinberg(I, Threshold)
[rowI, colI, ~] = size(I);
Ipad = padarray(I,[1 1],0,'both');
Ipad = Ipad(2:end, :);
for ii = 1 : rowI                 %要讓它從 Ipad 裡面的 I 開始數
    for jj = 2 : (colI+1)         %要讓它從 Ipad 裡面的 I 開始數
        if Ipad(ii,jj) >= 128 %calculate quantization error E
            E = Ipad(ii,jj) - 255;
        else
            E = Ipad(ii,jj);
        end
        Ipad(ii  ,jj+1)  = Ipad(ii ,jj+1)  + E*7/16;
        Ipad(ii+1,jj-1)  = Ipad(ii+1,jj-1) + E*3/16;
        Ipad(ii+1,jj  )  = Ipad(ii+1,jj )  + E*5/16;
        Ipad(ii+1,jj+1)  = Ipad(ii+1,jj+1) + E*1/16;
    end
end
Ia = Ipad( 1:rowI , 2:(colI + 1));
Ib = floor(Ia + 0.5);
Dither = Threshold*ones(size(I));
Ic = uint8((Ib > Dither)*255);
end

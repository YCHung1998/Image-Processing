clc;clear;close all
% Convert RGB image to Gray Image
% ref of figure : http://www.lenna.org/
filename = 'lena_std.tif';
I = imread(filename);
Config
Gray = rgb2gray(I);
mG = mean(im2double(I), [3]);


R = I;
R(:,:,[2 3]) = 0;
G = I;
G(:,:,[1 3]) = 0;
B = I;
B(:,:,[1 2]) = 0;

%% Insert text
Fontsize = 30;
It    = insertText(I, [1 1], 'Origin', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Rt   = insertText(R, [1 1], 'Red', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Gt   = insertText(G, [1 1], 'Green', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Bt   = insertText(B ,[1 1], 'Blue', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

Grayt   = insertText(Gray, [1 1], 'MATLAB', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
mGrayt   = insertText(mG ,[1 1], 'Mean', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

%% Visualize
figure();
fig1 = montage({Grayt, mGrayt});
title('rgb2gay v.s. mean of RGB channel')

figure('Name', 'RGB');
fig2 = montage({It, Rt, Gt, Bt}, 'Size', [2 2]);
%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    if ~exist('HW1', 'dir')
        mkdir('HW1')
    end
    saveas(fig1, fullfile('HW1', 'result_gray.png'));
    saveas(fig2, fullfile('HW1', 'result_rgb.png'));
end
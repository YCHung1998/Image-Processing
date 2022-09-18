clc;clear;close all
filename = 'lena_std.tif';
I = imread(filename);
Config;
G = rgb2gray(I);
Ipad = padarray(I, [1 1], 0, 'both');
Gpad = padarray(G, [1 1], 0, 'both');
%% Mean
meanF = fspecial('average',5);
meanI = imfilter(I, meanF, 'replicate');
meanG = imfilter(G, meanF, 'replicate');

%% Median
[rowI, colI, ~] = size(I);
medianI = Ipad;
medianG = Gpad;

for ii = 2:(rowI+1)
    for jj = 2:(colI+1)
        medianI(ii,jj, :) = median(medianI(ii-1:ii+1,jj-1:jj+1,:), [1 2]);
    end
end

for ii = 2:(rowI+1)
    for jj = 2:(colI+1)
        medianG (ii,jj) = median(reshape(medianG(ii-1:ii+1,jj-1:jj+1),1,9));
    end
end

%% Unsharpen
ratio = 0.25;
unsharpF = fspecial('unsharp',ratio);
unsharpI = imfilter(I, unsharpF);
unsharpG = imfilter(G, unsharpF);

%% Insert text
Fontsize = 30;
It       = insertText(I, [1 1], 'Origin', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
meanIt  = insertText(meanI, [1 1], 'mean', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
medianIt = insertText(medianI ,[1 1], 'median', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
unsharpIt       = insertText(unsharpI, [1 1], 'unsharp', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);


%% Visualize

figure();
fig1 = montage({It, meanIt, medianIt, unsharpIt; ...
    G, meanG, medianG, unsharpG}, 'Size', [4 2]);
% ylabel({'original', 'mean', 'median', 'unsharpen'})
title('RGB v.s. Gray')

figure();
fig2 = montage({meanIt, meanG}, 'Size', [1 2]);
figure();
fig3 = montage({medianIt, medianG}, 'Size', [1 2]);
figure();
fig4 = montage({unsharpIt, unsharpG}, 'Size', [1 2]);

%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    HW = 'HW5';
    if ~exist(HW, 'dir')
        mkdir(HW)
    end
    saveas(fig1, fullfile(HW, 'result.png'));
    saveas(fig2, fullfile(HW, 'result_mean.png'));
    saveas(fig3, fullfile(HW, 'result_median.png'));
    saveas(fig4, fullfile(HW, 'result_unsharp.png'));
    % saveas(fig2, fullfile(HW, 'result_rgb.png'));
end
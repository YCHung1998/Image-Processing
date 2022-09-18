clc;clear;close all
% Not Yet
filename = 'lena_std.tif';
I = imread(filename);
Config
G = rgb2gray(I);
% imhist(G)
edges = linspace(-0.5,255.5, 256);
% figure;histogram(G, 'BinEdges', edges);
G_HE = histeq(G);

% dI = double(I);
% Ir = dI.*repmat(double(G_HE)./double(G),1,1,3);
% figure;imshow(Ir)

figure();
subplot(211)
% imhist(G)
fig1 = histogram(G, 'BinEdges', edges);
title('image histogram')
xlabel('Gray')
ylabel('count')
subplot(212)
% imhist(G_HE)
histogram(G_HE, 'BinEdges', edges);
xlabel('Histogram Equalization')
ylabel('count')

figure();fig2 = montage({I, G, G, G_HE}, 'Size', [2 2]);
%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    HW = 'HW4';
    if ~exist(HW, 'dir')
        mkdir(HW)
    end
    saveas(fig1, fullfile(HW, 'result.png'));
end

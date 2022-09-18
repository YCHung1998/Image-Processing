clc;clear;close all
% Dithering
filename = 'lena_std.tif';
I = imread(filename);
G = rgb2gray(I);
Config;

D4rep = [0 128 32 160; ...
    192 64 224 96; ...
    48 176 16 144; ...
    240 112 208 80];

[r,c] = size(G);
[dr,dc] = size(D4rep);
% 計算列最少需要幾個 D matrix 才能蓋住
no_r = floor(r/dr+.5);
no_c = floor(c/dc+.5);
Drep = repmat(D4rep, [no_r no_c]);

% Cut off non necessary
Dither = Drep(1:r, 1:c);
S = double(G);
M = Dither - double(G);
M1 = floor((M+abs(M)/2));
result = repmat(uint8(double(S>Dither)*255), 1, 1, 3);


%% Dither in four gray value
% num = 85
D4 = [0 56; ...
    84 28];
[d1r,d1c] = size(D4);
no_r1   = floor(r/d1r + 0.5);
no_c1   = floor(c/d1c + 0.5);
D4rep   = repmat(D4, no_r1, no_c1);
Dither4 = D4rep(1:r,1:c);
S       = double(G);
Q       = floor(S./85+0.5);
result4 = Q + ((double(G)-85*Q)>Dither4);
result4 = repmat(uint8(result4*85), 1,1,3);

%% Insert text
Fontsize = 30;
It       = insertText(I, [1 1], 'Origin', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
resultt  = insertText(result, [1 1], 'Dither1', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
result4t = insertText(result4 ,[1 1], 'Dither4', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Gt       = insertText(G, [1 1], 'Gray', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

%% Visualize
figure('Name', 'Dither in BINARY　value');
fig1 = imshow(result);

figure('Name', 'Dither in 4 gray value');
fig2 = imshow(result4);

figure();
fig3 = montage({It, resultt, result4t, Gt});

%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    if ~exist('HW2', 'dir')
        mkdir('HW2')
    end
    saveas(fig1, fullfile('HW2', 'result_dither1.png'));
    saveas(fig2, fullfile('HW2', 'result_dither4.png'));
    saveas(fig3, fullfile('HW2', 'result.png'));
end
